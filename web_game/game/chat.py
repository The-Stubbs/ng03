# -*- coding: utf-8 -*-

from web_game.game._global import *

class View(GlobalView):

    def dispatch(self, request, *args, **kwargs):

        response = super().pre_dispatch(request, *args, **kwargs)
        if response: return response

        self.onlineusers_refreshtime = 60

        self.selected_menu = "chat"

        chatid = ToInt(request.GET.get("id"), 0)
        action = request.GET.get("a")

        if action == "send":
            return self.addLine(chatid, request.GET.get("l"))

        if action == "refresh":
            return self.refreshChat(chatid)

        if action == "join":
            return self.joinChat()

        if action == "leave":
            return self.leaveChat(chatid)

        if action == "chatlist":
            return self.displayChatList()

        return self.displayChat()

    def getChatId(self, id):

        if id == 0 and self.AllianceId:
            id = self.request.session.get("alliancechat_" + str(self.AllianceId))

            if id == None or id == "":
                query = "SELECT chatid FROM alliances WHERE id=" + str(self.AllianceId)
                oRs = oConnExecute(query)

                if oRs:
                    self.request.session["alliancechat_" + str(self.AllianceId)] = oRs[0]
                    return oRs[0]
                    
        return id

    def addLine(self, chatid, msg):
        msg = msg.strip()[:260]

        if msg != "":

            connExecuteRetryNoRecords "INSERT INTO chat_lines(chatid, allianceid, userid, login, message) VALUES(" + str(chatid) + "," + sqlValue(self.AllianceId) + "," + str(self.UserId) + "," + dosql(self.oPlayerInfo["login"]) + "," + dosql(msg) + ")"

        return " "

    def refreshContent(self, chatid):
        if chatid != 0 and self.request.session.get("chat_joined_" + str(chatid)) != "1": return

        userChatId = chatid

        chatid = self.getChatId(chatid)

        refresh_userlist = Timer() - self.request.session.get("lastchatactivity_" + str(chatid)) > self.onlineusers_refreshtime

        lastmsgid = self.request.session.get("lastchatmsg_" + str(chatid))
        if lastmsgid == "": lastmsgid = 0

        query = "SELECT chat_lines.id, datetime, allianceid, login, message" + \
                " FROM chat_lines" + \
                " WHERE chatid=" + str(chatid) + " AND chat_lines.id > GREATEST((SELECT id FROM chat_lines WHERE chatid="+ str(chatid) +" ORDER BY datetime DESC OFFSET 100 LIMIT 1), " + str(lastmsgid) + ")" + \
                " ORDER BY chat_lines.id"
        oRss = oConnExecuteAll(query)

        if oRs == None: oRs = Empty

        # if there's no line to send and no list of users to send, exit
        if oRs == None and not refresh_userlist:
            Response.Write " " # return an empty string : fix safari "undefined XMLHttpRequest.status" bug
            return

        # load the template

        content = GetTemplate(self.request, "chat")
        content.AssignValue("login", self.oPlayerInfo["login")
        content.AssignValue("chatid", userChatId

        if not IsEmpty(oRs):
            list = []
            for oRs in oRss:
                item = {}
                list.append(item)
                
                session("lastchatmsg_" + chatid) = oRs[0]

                item["lastmsgid", oRs[0]
                item["datetime", oRs[1].value
                item["author", oRs[3]
                item["line", oRs[4]
                item["alliancetag", getAllianceTag(oRs[2])
                content.Parse("refresh.line"

        # update user lastactivity in the DB and retrieve users online only every 3 minutes
        if refresh_userlist:
            if session(sprivilege) < 100:    # prevent admin from showing their presence in chat
                on error resume next

                connExecuteRetryNoRecords "INSERT INTO chat_onlineusers(chatid, userid) VALUES(" + chatid + "," + str(self.UserId) + ")"

                on error goto 0

            self.request.session.get("lastchatactivity_" + chatid) = Timer()

            # retrieve online users in chat
            query = "SELECT users.alliance_id, users.login, date_part('epoch', now()-chat_onlineusers.lastactivity)" + \
                    " FROM chat_onlineusers" + \
                    "    INNER JOIN users ON (users.id=chat_onlineusers.userid)" + \
                    " WHERE chat_onlineusers.lastactivity > now()-INTERVAL '10 minutes# AND chatid=" + chatid
            oRss = oConnExecuteAll(query)

            list = []
            for oRs in oRss:
                item = {}
                list.append(item)
                
                item["alliancetag", getAllianceTag(oRs[0])
                item["user", oRs[1]
                item["lastactivity", oRs[2]
                content.Parse("refresh.online_users.user"

            content.Parse("refresh.online_users"

        content.Parse("refresh"

        Response.Write content.Output

    def refreshChat(self, chatid):
        refreshContent chatid

    def displayChatList(self):

        content = GetTemplate(self.request, "chat")
        content.AssignValue("login", self.oPlayerInfo["login")

        query = "SELECT name, topic, count(chat_onlineusers.userid)" + \
                " FROM chat" + \
                "    LEFT JOIN chat_onlineusers ON (chat_onlineusers.chatid = chat.id AND chat_onlineusers.lastactivity > now()-INTERVAL '10 minutes')" + \
                " WHERE name IS NOT None AND password = '# AND public" + \
                " GROUP BY name, topic" + \
                " ORDER BY length(name), name"
        oRss = oConnExecuteAll(query)

        list = []
        for oRs in oRss:
            item = {}
            list.append(item)
            
            item["name", oRs[0]
            item["topic", oRs[1]
            item["online", oRs[2]

            content.Parse("publicchats.chat"

        content.Parse("publicchats"

        Response.Write content.Output

    # add a chat to the joined chat list
    def addChat(self, chatid):
        addChat = True

        self.request.session.get("lastchatactivity_" + chatid) = Timer()-self.onlineusers_refreshtime

        if self.request.session.get("chat_joined_" + chatid) != "1":
            self.request.session.get("chat_joined_count") = self.request.session.get("chat_joined_count") + 1
            self.request.session.get("chat_joined_" + chatid) = "1"

            addChat = True

    # remove a chat from list
    def removeChat(self, chatid):
        if self.request.session.get("chat_joined_" + chatid) = "1":
            self.request.session.get("chat_joined_" + chatid) = ""
            self.request.session.get("chat_joined_count") = self.request.session.get("chat_joined_count") - 1

    def displayChat(self):
        self.request.session.get("chatinstance") = self.request.session.get("chatinstance") + 1

        content = GetTemplate(self.request, "chat")
        content.AssignValue("login", self.oPlayerInfo["login")
        content.AssignValue("chatinstance", self.request.session.get("chatinstance")

        if (self.AllianceId):
            chatid = getChatId(0)
            self.request.session.get("lastchatmsg_" + chatid) = ""
            self.request.session.get("lastchatactivity_" + chatid) = Timer()-self.onlineusers_refreshtime

            content.Parse("alliance"

        query = "SELECT chat.id, chat.name, chat.topic" + \
                " FROM users_chats" + \
                "    INNER JOIN chat ON (chat.id=users_chats.chatid AND ((chat.password = '') OR (chat.password = users_chats.password)))" + \
                " WHERE userid = " + str(self.UserId) + \
                " ORDER BY users_chats.added"
        oRss = oConnExecuteAll(query)

        list = []
        for oRs in oRss:
            if addChat(oRs[0]):
                item = {}
                list.append(item)
                
                item["id", oRs[0]
                item["name", oRs[1]
                item["topic", oRs[2]
                content.Parse("join"

                self.request.session.get("lastchatmsg_" + oRs[0]) = ""

        content.AssignValue("now", now()

        content.Parse("chat"

        return self.Display(content)

    def joinChat(self):

        content = GetTemplate(self.request, "chat")
        content.AssignValue("login", self.oPlayerInfo["login")

        pass = request.GET.get("pass").strip()

        # join chat
        query = "SELECT sp_chat_join(" + dosql(request.GET.get("chat").strip()) + "," + dosql(pass) + ")"
        oRs = oConnExecute(query)

        chatid = oRs[0]

        if not addChat(oRs[0]): return

        if chatid != 0:
            on error resume next
            Err.Clear

            # save the chatid to the user chatlist
            query = "INSERT INTO users_chats(userid, chatid, password) VALUES(" + str(self.UserId) + "," + chatid + "," + dosql(pass) + ")"
            oConnDoQuery(query)

            if Err.Number == 0:

                query = "SELECT name, topic FROM chat WHERE id=" + chatid
            oRs = oConnExecute(query)

                if oRs:
                    content.AssignValue("id", chatid
                    content.AssignValue("name", oRs[0]
                    content.AssignValue("topic", oRs[1]
                    content.Parse("join.setactive"
                    content.Parse("join"

                    self.request.session.get("lastchatmsg_" + chatid) = ""

            else:
                content.Parse("join_error"

            on error goto 0
        else:
            content.Parse("join_badpassword"

        Response.Write(content.Output)

    def leaveChat(self, chatid):
        self.request.session.get("lastchatmsg_" + chatid) = ""

        removeChat chatid

        query = "DELETE FROM users_chats WHERE userid=" + str(self.UserId) + " AND chatid=" + chatid
        oConnDoQuery(query)

        query = "DELETE FROM chat WHERE id > 0 AND NOT public AND name IS NOT None AND id=" + chatid + " AND (SELECT count(1) FROM users_chats WHERE chatid=chat.id) = 0"
        oConnDoQuery(query)

