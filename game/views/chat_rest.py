# -*- coding: utf-8 -*-

from game.views._base import *

#-------------------------------------------------------------------------------
class View(RestView):

    #---------------------------------------------------------------------------
    def processAction(self, request, action):
    
        if action == "send":
        
            id = ToInt(request.POST.get("id"), 0)
            msg = request.POST.get("l","").strip()[:260]
            
            if msg != "":
                dbExecuteRetryNoRow("INSERT INTO gm_chat_lines(chatid, allianceid, userid, login, message) VALUES(" + str(id) + "," + str(sqlValue(self.allianceId)) + "," + str(self.userId) + "," + sqlStr(self.userInfo["login"]) + "," + sqlStr(msg) + ")")
                
            return HttpResponse(" ")

        elif action == "refresh":
        
            id = ToInt(request.POST.get("id"), 0)
            if id != 0 and request.session.get("chat_joined_" + str(id)) != "1": return

            chatid = self.getChatId(id)

            data = {}

            lastmsgid = request.session.get("lastchatmsg_" + str(chatid), "")
            if lastmsgid == "": lastmsgid = 0
            
            data["lines"] = []
            
            query = "SELECT gm_chat_lines.id, datetime, allianceid, login, message" + \
                    " FROM gm_chat_lines" + \
                    " WHERE chatid=" + str(chatid) + " AND gm_chat_lines.id > GREATEST((SELECT id FROM gm_chat_lines WHERE chatid="+ str(chatid) +" ORDER BY datetime DESC OFFSET 100 LIMIT 1), " + str(lastmsgid) + ")" + \
                    " ORDER BY gm_chat_lines.id"
            rows = dbRows(query)
            if rows:
                for row in rows:
                    
                    line = {}
                    data["lines"].append(line)

                    line["id"] = row[0]
                    line["date"] = row[1]
                    line["author"] = row[3]
                    line["msg"] = row[4]
                    line["tag"] = getAllianceTag(row[2])
                    
                    request.session["lastchatmsg_" + str(chatid)] = row[0]
                    
            else: return HttpResponse(" ")

            if request.session.get(sPrivilege, 0) < 5:
                dbExecute("INSERT INTO gm_chat_online_profiles(chatid, userid) VALUES(" + str(chatid) + "," + str(self.userId) + ")")

            data["users"] = []
            
            query = "SELECT gm_profiles.alliance_id, gm_profiles.login, date_part('epoch', now()-gm_chat_online_profiles.lastactivity)" + \
                    " FROM gm_chat_online_profiles" + \
                    "   INNER JOIN gm_profiles ON (gm_profiles.id=gm_chat_online_profiles.userid)" + \
                    " WHERE gm_chat_online_profiles.lastactivity > now()-INTERVAL '10 minutes' AND chatid=" + str(chatid)
            rows = dbRows(query)
            if rows:
                for row in rows:
                
                    user = {}
                    data["users"].append(user)
                    
                    user["tag"] = getAllianceTag(row[0])
                    user["name"] = row[1]
                    user["lastactivity"] = row[2]

            data["refresh"] = True

            return render(request, "chat-rest.html", data)

        elif action == "join":
        
            name = request.POST.get("name","").strip()
            pwd = request.POST.get("pwd","").strip()

            query = "SELECT user_chat_join(" + sqlStr(name) + "," + sqlStr(pwd) + ")"
            row = dbRow(query)
            
            data = {}
            
            chatid = row[0]
            if chatid != 0:
            
                self.addChat(row[0])

                query = "INSERT INTO gm_profile_chats(userid, chatid, password) VALUES(" + str(self.userId) + "," + str(chatid) + "," + sqlStr(pwd) + ")"
                dbExecute(query)

                query = "SELECT name, topic FROM gm_chats WHERE id=" + str(chatid)
                row = dbRow(query)
                if row:
                
                    data["id"] = chatid
                    data["name"] row[0]
                    data["topic"] row[1]
                    data["setactive"] = True
                    data["join"] = True

                    request.session["lastchatmsg_" + str(chatid)] = ""

                else: data["join_error"] = True

            else: data["join_badpassword"] = True

            return render(request, "chat-rest.html", data)

        elif action == "leave":
        
            id = ToInt(request.POST.get("id"), 0)
            
            request.session["lastchatmsg_" + str(id)] = ""

            if request.session.get("chat_joined_" + str(id)) == "1":
            
                request.session["chat_joined_" + str(id)] = ""
                request.session["chat_joined_count"] = request.session.get("chat_joined_count") - 1

            query = "DELETE FROM gm_profile_chats WHERE userid=" + str(self.userId) + " AND chatid=" + str(id)
            dbExecute(query)

            query = "DELETE FROM gm_chats WHERE id > 0 AND NOT public AND name IS NOT NULL AND id=" + str(id) + " AND (SELECT count(1) FROM gm_profile_chats WHERE chatid=gm_chats.id) = 0"
            dbExecute(query)
            
            return HttpResponse(" ")

        elif action == "publiclist":
        
            data = {}
            
            data["publicchats"] = []
            
            query = "SELECT name, topic, count(gm_chat_online_profiles.userid)" + \
                    " FROM gm_chats" + \
                    "   LEFT JOIN gm_chat_online_profiles ON (gm_chat_online_profiles.chatid = gm_chats.id AND gm_chat_online_profiles.lastactivity > now()-INTERVAL '10 minutes')" + \
                    " WHERE name IS NOT NULL AND password = \'\' AND public" + \
                    " GROUP BY name, topic" + \
                    " ORDER BY length(name), name"
            rows = dbRows(query)
            if rows:
                for row in rows:
                
                    chat = {}
                    data["publicchats"].append(chat)
                    
                    chat["name"] = row[0]
                    chat["topic"] = row[1]
                    chat["online"] = row[2]

            return render(request, "chat-rest.html", data)

    #---------------------------------------------------------------------------
    def getChatId(self, id):

        if id == 0 and self.allianceId:
        
            id = self.request.session.get("alliancechat_" + str(self.allianceId))
            if id == None or id == "":
            
                query = "SELECT chatid FROM gm_alliances WHERE id=" + str(self.allianceId)
                row = dbRow(query)
                if row:
                
                    self.request.session["alliancechat_" + str(self.allianceId)] = row[0]
                    return row[0]
                    
        return id

    #---------------------------------------------------------------------------
    def addChat(self, chatid):
    
        if self.request.session.get("chat_joined_" + str(chatid)) != "1":
        
            self.request.session["chat_joined_count"] = ToInt(self.request.session.get("chat_joined_count"), 0) + 1
            self.request.session["chat_joined_" + str(chatid)] = "1"
