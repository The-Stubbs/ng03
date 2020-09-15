# -*- coding: utf-8 -*-

from django.http import HttpResponse
from django.utils.dateparse import parse_date

from game.views._base import *

class View(GlobalView):

    def dispatch(self, request, *args, **kwargs):

        response = super().pre_dispatch(request, *args, **kwargs)
        if response: return response

        self.onlineusers_refreshtime = 60

        self.selected_menu = "gm_chats"

        chatid = ToInt(request.GET.get("id"), 0)
        action = request.GET.get("a")

        if action == "send":
            return self.addLine(chatid, request.GET.get("l", ""))

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
                query = "SELECT chatid FROM gm_alliances WHERE id=" + str(self.AllianceId)
                oRs = oConnExecute(query)

                if oRs:
                    self.request.session["alliancechat_" + str(self.AllianceId)] = oRs[0]
                    return oRs[0]
                    
        return id

    def addLine(self, chatid, msg):
        msg = msg.strip()[:260]
        if msg != "":
            connExecuteRetryNoRecords("INSERT INTO gm_chat_lines(chatid, allianceid, userid, login, message) VALUES(" + str(chatid) + "," + str(sqlValue(self.AllianceId)) + "," + str(self.UserId) + "," + dosql(self.oPlayerInfo["login"]) + "," + dosql(msg) + ")")
        return HttpResponse(" ")

    def refreshContent(self, chatid):
        if chatid != 0 and self.request.session.get("chat_joined_" + str(chatid)) != "1": return

        userChatId = chatid

        chatid = self.getChatId(chatid)

        refresh_userlist = True

        lastmsgid = self.request.session.get("lastchatmsg_" + str(chatid), "")
        if lastmsgid == "": lastmsgid = 0

        query = "SELECT gm_chat_lines.id, datetime, allianceid, login, message" + \
                " FROM gm_chat_lines" + \
                " WHERE chatid=" + str(chatid) + " AND gm_chat_lines.id > GREATEST((SELECT id FROM gm_chat_lines WHERE chatid="+ str(chatid) +" ORDER BY datetime DESC OFFSET 100 LIMIT 1), " + str(lastmsgid) + ")" + \
                " ORDER BY gm_chat_lines.id"
        oRss = oConnExecuteAll(query)

        if oRss == None: oRss = None

        # if there's no line to send and no list of gm_profiles to send, exit
        if oRss == None and not refresh_userlist:
            return " " # return an empty string : fix safari "undefined XMLHttpRequest.status" bug

        # load the template

        content = GetTemplate(self.request, "gm_chats-handler")
        content.AssignValue("login", self.oPlayerInfo["login"])
        content.AssignValue("chatid", userChatId)

        if oRss:
            list = []
            content.AssignValue("lines", list)
            for oRs in oRss:
                item = {}
                list.append(item)
                
                self.request.session["lastchatmsg_" + str(chatid)] = oRs[0]

                item["lastmsgid"] = oRs[0]
                item["datetime"] = oRs[1]
                item["author"] = oRs[3]
                item["line"] = oRs[4]
                item["alliancetag"] = getAllianceTag(oRs[2])

        # update user lastactivity in the DB and retrieve gm_profiles online only every 3 minutes
        if refresh_userlist:
            if self.request.session.get(sPrivilege) < 100:    # prevent admin from showing their presence in gm_chats
                connExecuteRetryNoRecords("INSERT INTO gm_chat_online_profiles(chatid, userid) VALUES(" + str(chatid) + "," + str(self.UserId) + ")")

            # self.request.session["lastchatactivity_" + str(chatid)] = timezone.now()

            # retrieve online gm_profiles in gm_chats
            query = "SELECT gm_profiles.alliance_id, gm_profiles.login, date_part('epoch', now()-gm_chat_online_profiles.lastactivity)" + \
                    " FROM gm_chat_online_profiles" + \
                    "    INNER JOIN gm_profiles ON (gm_profiles.id=gm_chat_online_profiles.userid)" + \
                    " WHERE gm_chat_online_profiles.lastactivity > now()-INTERVAL '10 minutes' AND chatid=" + str(chatid)
            oRss = oConnExecuteAll(query)

            list = []
            content.AssignValue("online_users", list)
            for oRs in oRss:
                item = {}
                list.append(item)
                
                item["alliancetag"] = getAllianceTag(oRs[0])
                item["user"] = oRs[1]
                item["lastactivity"] = oRs[2]

        content.Parse("refresh")

        return render(self.request, content.template, content.data)

    def refreshChat(self, chatid):
        return self.refreshContent(chatid)

    def displayChatList(self):

        content = GetTemplate(self.request, "gm_chats-handler")
        content.AssignValue("login", self.oPlayerInfo["login"])

        query = "SELECT name, topic, count(gm_chat_online_profiles.userid)" + \
                " FROM gm_chats" + \
                "    LEFT JOIN gm_chat_online_profiles ON (gm_chat_online_profiles.chatid = gm_chats.id AND gm_chat_online_profiles.lastactivity > now()-INTERVAL '10 minutes')" + \
                " WHERE name IS NOT NULL AND password = \'\' AND public" + \
                " GROUP BY name, topic" + \
                " ORDER BY length(name), name"
        oRss = oConnExecuteAll(query)

        list = []
        content.AssignValue("publicchats", list)
        for oRs in oRss:
            item = {}
            list.append(item)
            
            item["name"] = oRs[0]
            item["topic"] = oRs[1]
            item["online"] = oRs[2]

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

        content = GetTemplate(self.request, "gm_chats")
        content.AssignValue("login", self.oPlayerInfo["login"])
        content.AssignValue("chatinstance", self.request.session.get("chatinstance"))

        if (self.AllianceId):
            chatid = self.getChatId(0)
            self.request.session["lastchatmsg_" + str(chatid)] = ""
            #self.request.session["lastchatactivity_" + str(chatid)] = str(timezone.now()-timezone.timedelta(seconds=self.onlineusers_refreshtime))

            content.Parse("alliance")

        query = "SELECT gm_chats.id, gm_chats.name, gm_chats.topic" + \
                " FROM gm_profile_chats" + \
                "    INNER JOIN gm_chats ON (gm_chats.id=gm_profile_chats.chatid AND ((gm_chats.password = '') OR (gm_chats.password = gm_profile_chats.password)))" + \
                " WHERE userid = " + str(self.UserId) + \
                " ORDER BY gm_profile_chats.added"
        oRss = oConnExecuteAll(query)

        list = []
        content.AssignValue("joins", list)
        for oRs in oRss:
            if self.addChat(oRs[0]):
                item = {}
                list.append(item)
                
                item["id"] = oRs[0]
                item["name"] = oRs[1]
                item["topic"] = oRs[2]

                self.request.session["lastchatmsg_" + str(oRs[0])] = ""

        content.AssignValue("now", timezone.now())

        content.Parse("gm_chats")

        return self.Display(content)

    def joinChat(self):

        content = GetTemplate(self.request, "gm_chats-handler")
        content.AssignValue("login", self.oPlayerInfo["login"])

        pwd = self.request.GET.get("pass", "").strip()

        # join gm_chats
        query = "SELECT user_chat_join(" + dosql(self.request.GET.get("gm_chats", "").strip()) + "," + dosql(pwd) + ")"
        oRs = oConnExecute(query)

        chatid = oRs[0]

        if not self.addChat(oRs[0]): return

        if chatid != 0:
            # save the chatid to the user chatlist
            query = "INSERT INTO gm_profile_chats(userid, chatid, password) VALUES(" + str(self.UserId) + "," + str(chatid) + "," + dosql(pwd) + ")"
            oConnDoQuery(query)

            query = "SELECT name, topic FROM gm_chats WHERE id=" + str(chatid)
            oRs = oConnExecute(query)

            if oRs:
                content.AssignValue("id", chatid)
                content.AssignValue("name", oRs[0])
                content.AssignValue("topic", oRs[1])
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

        query = "DELETE FROM gm_profile_chats WHERE userid=" + str(self.UserId) + " AND chatid=" + str(chatid)
        oConnDoQuery(query)

        query = "DELETE FROM gm_chats WHERE id > 0 AND NOT public AND name IS NOT NULL AND id=" + str(chatid) + " AND (SELECT count(1) FROM gm_profile_chats WHERE chatid=gm_chats.id) = 0"
        oConnDoQuery(query)
        
        return HttpResponse(" ")
