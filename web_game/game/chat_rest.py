# -*- coding: utf-8 -*-

from web_game.game._global import *



class View(GlobalView):

    def dispatch(self, request, *args, **kwargs):

        response = super().pre_dispatch(request, *args, **kwargs)
        if response: return response
        
        return super().dispatch(request, *args, **kwargs)



    def get(self, request, *args, **kwargs):
    
        action = request.GET.get("a", "")

        # --- post a new line

        if action == "send":
        
            chatid = ToInt(request.GET.get("id"), -1)
            
            msg = request.GET.get("l", "")
            msg = msg.strip()[:260]
            if msg != "":
                connExecuteRetryNoRecords("INSERT INTO chat_lines(chatid, allianceid, userid, login, message) VALUES(" + str(chatid) + "," + str(sqlValue(self.AllianceId)) + "," + str(self.UserId) + "," + dosql(self.oPlayerInfo["login"]) + "," + dosql(msg) + ")")
                
            return HttpResponse(" ")

        # --- retrieve last messages and online users

        elif action == "refresh":
        
            chatid = ToInt(request.GET.get("id"), -1)
           
            if chatid != -1 and request.session.get("chat_joined_" + str(chatid)) != "1":
                return HttpResponse(" ")

            content = GetTemplate(request, "chat_rest")
            
            content.AssignValue("chatid", chatid)
            content.Parse("refresh")

            if chatid == 0 and self.AllianceId:
            
                chatid = request.session.get("alliancechat_" + str(self.AllianceId), "")
                if id == "":
                
                    query = "SELECT chatid FROM alliances WHERE id=" + str(self.AllianceId)
                    oRs = oConnExecute(query)
                    if oRs:
                    
                        request.session["alliancechat_" + str(self.AllianceId)] = oRs[0]
                        chatid = oRs[0]

            lastmsgid = request.session.get("lastchatmsg_" + str(chatid), "")
            if lastmsgid == "": lastmsgid = 0

            query = " SELECT chat_lines.id, datetime, allianceid, login, message" + \
                    " FROM chat_lines" + \
                    " WHERE chatid=" + str(chatid) + " AND chat_lines.id > GREATEST((SELECT id FROM chat_lines WHERE chatid="+ str(chatid) +" ORDER BY datetime DESC OFFSET 100 LIMIT 1), " + str(lastmsgid) + ")" + \
                    " ORDER BY chat_lines.id"
            oRss = oConnExecuteAll(query)
            if oRss:
            
                list = []
                content.AssignValue("lines", list)
                
                for oRs in oRss:
                
                    item = {}
                    list.append(item)
                    
                    item["datetime"] = oRs[1]
                    item["author"] = oRs[3]
                    item["line"] = oRs[4]
                    item["alliancetag"] = getAllianceTag(oRs[2])
                    
                    request.session["lastchatmsg_" + str(chatid)] = oRs[0]

            connExecuteRetryNoRecords("INSERT INTO chat_onlineusers(chatid, userid) VALUES(" + str(chatid) + "," + str(self.UserId) + ")")

            query = " SELECT users.alliance_id, users.login, date_part('epoch', now()-chat_onlineusers.lastactivity)" + \
                    " FROM chat_onlineusers" + \
                    "   INNER JOIN users ON (users.id=chat_onlineusers.userid)" + \
                    " WHERE chat_onlineusers.lastactivity > now()-INTERVAL '10 minutes' AND chatid=" + str(chatid)
            oRss = oConnExecuteAll(query)

            list = []
            content.AssignValue("online_users", list)
            
            for oRs in oRss:
            
                item = {}
                list.append(item)
                
                item["alliancetag"] = getAllianceTag(oRs[0])
                item["user"] = oRs[1]
                item["lastactivity"] = oRs[2]

            return render(request, content.template, content.data)

        # --- join to a chat

        elif action == "join":
        
            pwd = request.GET.get("pass", "").strip()
            name = request.GET.get("chat", "").strip()
            
            query = "SELECT sp_chat_join(" + dosql(name) + "," + dosql(pwd) + ")"
            oRs = oConnExecute(query)

            chatid = oRs[0]
            
            if request.session.get("chat_joined_" + str(chatid)) != "1":
            
                request.session["chat_joined_count"] = ToInt(request.session.get("chat_joined_count"), 0) + 1
                request.session["chat_joined_" + str(chatid)] = "1"
                
            content = GetTemplate(request, "chat_rest")
            
            if chatid != 0:
                
                query = "INSERT INTO users_chats(userid, chatid, password) VALUES(" + str(self.UserId) + "," + str(chatid) + "," + dosql(pwd) + ")"
                oConnDoQuery(query)

                query = "SELECT name, topic FROM chat WHERE id=" + str(chatid)
                oRs = oConnExecute(query)

                if oRs:
                    
                    content.AssignValue("id", chatid)
                    content.AssignValue("name", oRs[0])
                    content.AssignValue("topic", oRs[1])
                    
                    content.Parse("join")

                    request.session["lastchatmsg_" + str(chatid)] = ""

                else: content.Parse("join_error")

            else: content.Parse("join_badpassword")

            return render(request, content.template, content.data)

        # --- leave a chat

        elif action == "leave":
        
            chatid = ToInt(request.GET.get("id"), -1)
            
            request.session["lastchatmsg_" + str(chatid)] = ""

            if request.session.get("chat_joined_" + str(chatid)) == "1":
            
                request.session["chat_joined_" + str(chatid)] = ""
                request.session["chat_joined_count"] = ToInt(request.session.get("chat_joined_count"), 1) - 1

            query = "DELETE FROM users_chats WHERE userid=" + str(self.UserId) + " AND chatid=" + str(chatid)
            oConnDoQuery(query)

            query = "DELETE FROM chat WHERE id > 0 AND NOT public AND name IS NOT NULL AND id=" + str(chatid) + " AND (SELECT count(1) FROM users_chats WHERE chatid=chat.id) = 0"
            oConnDoQuery(query)
            
            return HttpResponse(" ")

        # --- get public chats

        elif action == "chatlist":
        
            content = GetTemplate(request, "chat_rest")

            list = []
            content.AssignValue("publicchats", list)
            
            query = " SELECT name, topic, count(chat_onlineusers.userid)" + \
                    " FROM chat" + \
                    "   LEFT JOIN chat_onlineusers ON (chat_onlineusers.chatid = chat.id AND chat_onlineusers.lastactivity > now()-INTERVAL '10 minutes')" + \
                    " WHERE name IS NOT NULL AND password = \'\' AND public" + \
                    " GROUP BY name, topic" + \
                    " ORDER BY length(name), name"
            oRss = oConnExecuteAll(query)

            for oRs in oRss:
            
                item = {}
                list.append(item)
                
                item["name"] = oRs[0]
                item["topic"] = oRs[1]
                item["online"] = oRs[2]

            return render(request, content.template, content.data)

        return HttpResponse(" ")
