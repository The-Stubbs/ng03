# -*- coding: utf-8 -*-

from game.views._base import *

#-------------------------------------------------------------------------------
class View(BaseView):

    success_url = "chats"
    template_name = "chats"
    selected_menu = "chats"

    #---------------------------------------------------------------------------
    def dispatch(self, request, *args, **kwargs):

        response = super().pre_dispatch(request, *args, **kwargs)
        if response: return response
        
        return super().dispatch(request, *args, **kwargs)

    #---------------------------------------------------------------------------
    def processAction(self, request, action):
    
        if action == "send":
        
            id = ToInt(request.POST.get("id"), 0)
            msg = request.POST.get("l", "").strip()[:260]
            
            if msg != "":
                dbExecuteRetryNoRow("INSERT INTO gm_chat_lines(chatid, allianceid, userid, login, message) VALUES(" + str(id) + "," + str(sqlValue(self.allianceId)) + "," + str(self.userId) + "," + sqlStr(self.userInfo["login"]) + "," + sqlStr(msg) + ")")
                
            return HttpResponse(" ")

        elif action == "refresh":
        
            id = ToInt(request.POST.get("id"), 0)
            
            self.refreshChat(chatid)

        elif action == "join":
        
            self.joinChat()

        elif action == "leave":
        
            id = ToInt(request.POST.get("id"), 0)
            
            self.leaveChat(chatid)

        elif action == "chatlist":
        
            self.displayChatList()
            
            
            
            
        self.onlineusers_refreshtime = 60

        self.selected_menu = "gm_chats"

        chatid = ToInt(request.GET.get("id"), 0)


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

    def refreshContent(self, chatid):
        if chatid != 0 and self.request.session.get("chat_joined_" + str(chatid)) != "1": return

        userChatId = chatid

        chatid = self.getChatId(chatid)

        lastmsgid = self.request.session.get("lastchatmsg_" + str(chatid), "")
        if lastmsgid == "": lastmsgid = 0

        query = "SELECT gm_chat_lines.id, datetime, allianceid, login, message" + \
                " FROM gm_chat_lines" + \
                " WHERE chatid=" + str(chatid) + " AND gm_chat_lines.id > GREATEST((SELECT id FROM gm_chat_lines WHERE chatid="+ str(chatid) +" ORDER BY datetime DESC OFFSET 100 LIMIT 1), " + str(lastmsgid) + ")" + \
                " ORDER BY gm_chat_lines.id"
        oRss = dbRows(query)

        # if there's no line to send and no list of gm_profiles to send, exit
        if oRss == None:
            return " " # return an empty string : fix safari "undefined XMLHttpRequest.status" bug

        # load the template

        content = self.loadTemplate("gm_chats-handler")
        content.AssignValue("login", self.userInfo["login"])
        content.AssignValue("chatid", userChatId)

        if oRss:
            list = []
            content.AssignValue("lines", list)
            for row in oRss:
                item = {}
                list.append(item)
                
                self.request.session["lastchatmsg_" + str(chatid)] = row[0]

                item["lastmsgid"] = row[0]
                item["datetime"] = row[1]
                item["author"] = row[3]
                item["line"] = row[4]
                item["alliancetag"] = getAllianceTag(row[2])

        # update user lastactivity in the DB and retrieve gm_profiles online only every 3 minutes
        if self.request.session.get(sPrivilege) < 100:    # prevent admin from showing their presence in gm_chats
            dbExecuteRetryNoRow("INSERT INTO gm_chat_online_profiles(chatid, userid) VALUES(" + str(chatid) + "," + str(self.userId) + ")")

        # self.request.session["lastchatactivity_" + str(chatid)] = timezone.now()

        # retrieve online gm_profiles in gm_chats
        query = "SELECT gm_profiles.alliance_id, gm_profiles.login, date_part('epoch', now()-gm_chat_online_profiles.lastactivity)" + \
                " FROM gm_chat_online_profiles" + \
                "    INNER JOIN gm_profiles ON (gm_profiles.id=gm_chat_online_profiles.userid)" + \
                " WHERE gm_chat_online_profiles.lastactivity > now()-INTERVAL '10 minutes' AND chatid=" + str(chatid)
        oRss = dbRows(query)

        list = []
        content.AssignValue("online_users", list)
        for row in oRss:
            item = {}
            list.append(item)
            
            item["alliancetag"] = getAllianceTag(row[0])
            item["user"] = row[1]
            item["lastactivity"] = row[2]

        content.Parse("refresh")

        return render(self.request, content.template, content.data)


    def displayChatList(self):

        content = self.loadTemplate("gm_chats-handler")
        content.AssignValue("login", self.userInfo["login"])

        query = "SELECT name, topic, count(gm_chat_online_profiles.userid)" + \
                " FROM gm_chats" + \
                "    LEFT JOIN gm_chat_online_profiles ON (gm_chat_online_profiles.chatid = gm_chats.id AND gm_chat_online_profiles.lastactivity > now()-INTERVAL '10 minutes')" + \
                " WHERE name IS NOT NULL AND password = \'\' AND public" + \
                " GROUP BY name, topic" + \
                " ORDER BY length(name), name"
        oRss = dbRows(query)

        list = []
        content.AssignValue("publicchats", list)
        for row in oRss:
            item = {}
            list.append(item)
            
            item["name"] = row[0]
            item["topic"] = row[1]
            item["online"] = row[2]

        return render(self.request, content.template, content.data)

    # add a gm_chats to the joined gm_chats list
    def addChat(self, chatid):
        result = True

        #self.request.session["lastchatactivity_" + str(chatid)] = timezone.now()-self.onlineusers_refreshtime

        if self.request.session.get("chat_joined_" + str(chatid)) != "1":
            self.request.session["chat_joined_count"] = ToInt(self.request.session.get("chat_joined_count"), 0) + 1
            self.request.session["chat_joined_" + str(chatid)] = "1"

            result = True
        
        return result

    # remove a gm_chats from list
    def removeChat(self, chatid):
        if self.request.session.get("chat_joined_" + str(chatid)) == "1":
            self.request.session["chat_joined_" + str(chatid)] = ""
            self.request.session["chat_joined_count"] = self.request.session.get("chat_joined_count") - 1

    def displayChat(self):
        self.request.session["chatinstance"] = ToInt(self.request.session.get("chatinstance"), 0) + 1

        content = self.loadTemplate("gm_chats")
        content.AssignValue("login", self.userInfo["login"])
        content.AssignValue("chatinstance", self.request.session.get("chatinstance"))

        if (self.allianceId):
            chatid = self.getChatId(0)
            self.request.session["lastchatmsg_" + str(chatid)] = ""
            #self.request.session["lastchatactivity_" + str(chatid)] = str(timezone.now()-timezone.timedelta(seconds=self.onlineusers_refreshtime))

            content.Parse("alliance")

        query = "SELECT gm_chats.id, gm_chats.name, gm_chats.topic" + \
                " FROM gm_profile_chats" + \
                "    INNER JOIN gm_chats ON (gm_chats.id=gm_profile_chats.chatid AND ((gm_chats.password = '') OR (gm_chats.password = gm_profile_chats.password)))" + \
                " WHERE userid = " + str(self.userId) + \
                " ORDER BY gm_profile_chats.added"
        oRss = dbRows(query)

        list = []
        content.AssignValue("joins", list)
        for row in oRss:
            if self.addChat(row[0]):
                item = {}
                list.append(item)
                
                item["id"] = row[0]
                item["name"] = row[1]
                item["topic"] = row[2]

                self.request.session["lastchatmsg_" + str(row[0])] = ""

        content.AssignValue("now", timezone.now())

        content.Parse("gm_chats")

        return self.display(content)

    def joinChat(self):

        content = self.loadTemplate("gm_chats-handler")
        content.AssignValue("login", self.userInfo["login"])

        pwd = self.request.GET.get("pass", "").strip()

        # join gm_chats
        query = "SELECT user_chat_join(" + sqlStr(self.request.GET.get("gm_chats", "").strip()) + "," + sqlStr(pwd) + ")"
        row = dbRow(query)

        chatid = row[0]

        if not self.addChat(row[0]): return

        if chatid != 0:
            # save the chatid to the user chatlist
            query = "INSERT INTO gm_profile_chats(userid, chatid, password) VALUES(" + str(self.userId) + "," + str(chatid) + "," + sqlStr(pwd) + ")"
            dbExecute(query)

            query = "SELECT name, topic FROM gm_chats WHERE id=" + str(chatid)
            row = dbRow(query)

            if row:
                content.AssignValue("id", chatid)
                content.AssignValue("name", row[0])
                content.AssignValue("topic", row[1])
                content.Parse("setactive")
                content.Parse("join")

                self.request.session["lastchatmsg_" + str(chatid)] = ""

            else:
                content.Parse("join_error")

        else:
            content.Parse("join_badpassword")

        return render(self.request, content.template, content.data)

    def leaveChat(self, chatid):
        self.request.session["lastchatmsg_" + str(chatid)] = ""

        self.removeChat(chatid)

        query = "DELETE FROM gm_profile_chats WHERE userid=" + str(self.userId) + " AND chatid=" + str(chatid)
        dbExecute(query)

        query = "DELETE FROM gm_chats WHERE id > 0 AND NOT public AND name IS NOT NULL AND id=" + str(chatid) + " AND (SELECT count(1) FROM gm_profile_chats WHERE chatid=gm_chats.id) = 0"
        dbExecute(query)
        
        return HttpResponse(" ")
