# -*- coding: utf-8 -*-

from web_game.game._global import *

class View(GlobalView):

    def dispatch(self, request, *args, **kwargs):

        response = super().pre_dispatch(request, *args, **kwargs)
        if response: return response

        self.selected_menu = "player_connections"

        if self.request.session.get("privilege") < 100:
            response.Redirect "/"

        DisplayConnections request.GET.get("browser"), request.GET.get("address"), request.GET.get("browserid"), request.GET.get("u1"), request.GET.get("u2")

    def DisplayConnections(self, browser, address, browserid, user1, user2):

        content = GetTemplate(self.request, "dev-connections")

        if browserid != "":
            query = "SELECT datetime, sp__itoa(address), forwarded_address, browser, users.login, browserid, disconnected" + \
                    " FROM users_connections" + \
                    "    INNER JOIN users ON users.id=userid" + \
                    " WHERE browserid=" + dosql(browserid) + \
                    " ORDER BY datetime DESC, upper(users.login) LIMIT 1000"
        elif address != "":
            query = "SELECT datetime, sp__itoa(address), forwarded_address, browser, users.login, browserid, disconnected" + \
                    " FROM users_connections" + \
                    "    INNER JOIN users ON users.id=userid" + \
                    " WHERE address=sp__atoi(" + dosql(address) + ")" + \
                    " ORDER BY datetime DESC, upper(users.login) LIMIT 1000"
        elif browser != "":
            query = "SELECT datetime, sp__itoa(address), forwarded_address, browser, users.login, browserid, disconnected" + \
                    " FROM users_connections" + \
                    "    INNER JOIN users ON users.id=userid" + \
                    " WHERE lower(browser)=lower(" + dosql(browser) + ")" + \
                    " ORDER BY users_connections.datetime DESC, upper(users.login)" + \
                    " LIMIT 4000"
        elif user1 != "":
            query = "SELECT datetime, sp__itoa(address), forwarded_address, browser, sp_get_user(userid), browserid, disconnected" + \
                    " FROM users_connections" + \
                    " WHERE userid=" + User1 + " OR userid=" + user2 + \
                    " ORDER BY datetime DESC"
        else:
            query = "SELECT datetime, sp__itoa(address), forwarded_address, browser," + dosql(self.oPlayerInfo["login")) + ", browserid, disconnected" + \
                    " FROM users_connections" + \
                    " WHERE userid=" + str(self.UserId) + \
                    " ORDER BY datetime DESC"

        oRss = oConnExecuteAll(query)

        c = 1
        lastuser = ""

        list = []
        for oRs in oRss:
            item = {}
            list.append(item)
            
            item["connected", oRs[0]
            item["address", oRs[1]
            item["forwarded_address", oRs[2]
            if oRs[2] != "": content.Parse("connection.forwarded"
            item["browser", oRs[3]
            item["username", oRs[4]
            item["browserid", oRs[5]
            item["disconnected", oRs[6]

            if lastuser == "": lastuser = oRs[4]
            if lastuser != oRs[4]:
                c = 1 + c mod 2
                lastuser = oRs[4]

            content.Parse("connection.user" + c

            content.Parse("connection"

        return self.Display(content)

