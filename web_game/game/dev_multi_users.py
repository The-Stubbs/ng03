# -*- coding: utf-8 -*-

from web_game.game._global import *

class View(GlobalView):

    def dispatch(self, request, *args, **kwargs):

        response = super().pre_dispatch(request, *args, **kwargs)
        if response: return response

        self.selected_menu = "player_multi"

        if self.request.session.get("privilege") < 100:
            response.Redirect "/"

        return self.DisplayForm()

    def DisplayForm(self):

        content = GetTemplate(self.request, "dev-multi")

        query = "SELECT datetime, userid, login, sp__itoa(address), forwarded_address, browser," + \
                " datetime2, userid2, login2, sp__itoa(address2), forwarded_address2, browser2," + \
                " sent_to, received_from, samepassword," + \
                " regdate, email, regdate2, email2, samealliance, a_given1, a_taken1, a_given2, a_taken2," + \
                " browserid, disconnected, browserid2, disconnected2, browserid = browserid2," + \
                " privilege, privilege2, tag, tag2" + \
                " FROM admin_view_multi_accounts" + \
                " WHERE (userid="+userid+" OR userid2="+userid+")  LIMIT 200"

        oRss = oConnExecuteAll(query)

        list = []
        for oRs in oRss:
            item = {}
            list.append(item)
            
            item["timestamp", oRs[0]
            item["userid", oRs[1]
            item["login", oRs[2]
            item["address", oRs[3]
            item["forwarded_address", oRs[4]
            item["browser", oRs[5]
            item["timestamp2", oRs[6]
            item["userid2", oRs[7]
            item["login2", oRs[8]
            item["address2", oRs[9]
            item["forwarded_address2", oRs[10]
            item["browser2", oRs[11]
            item["sent_to", oRs[12]
            item["received_from", oRs[13]

            item["regdate", oRs[15]
            item["email", oRs[16]
            item["regdate2", oRs[17]
            item["email2", oRs[18]

            item["alliance1", oRs[31]
            item["alliance2", oRs[32]

            if oRs[14]: content.Parse("item.samepassword"
            if oRs[19]:
                item["given1", oRs[20]
                item["taken1", oRs[21]
                item["given2", oRs[22]
                item["taken2", oRs[23]

                content.Parse("item.samealliance"

            item["browserid", oRs[24]
            if (oRs[25]):
                item["disconnected", oRs[25]
                content.Parse("item.disconnected"

            item["browserid2", oRs[26]
            if (oRs[27]):
                item["disconnected2", oRs[27]
                content.Parse("item.disconnected2"

            if oRs[28] and oRs[29] = 0 and oRs[30] == 0: content.Parse("item.samebrowserid"

            if oRs[29] == 0: content.Parse("item.can_ban_multi"
            if oRs[30] == 0: content.Parse("item.can_ban_multi2"

            content.Parse("item"

        return self.Display(content)

