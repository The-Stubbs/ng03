# -*- coding: utf-8 -*-

from web_game.game._global import *

class View(GlobalView):

    def dispatch(self, request, *args, **kwargs):

        response = super().pre_dispatch(request, *args, **kwargs)
        if response: return response

        self.selected_menu = "alliance.tributes"

        invitation_success = ""
        cease_success = ""

        cat = request.GET.get("cat")
        if cat < 1 or cat > 3: cat = 1

        if not (self.oAllianceRights["can_create_nap"] or self.oAllianceRights["can_break_nap"]) and cat == 3: cat = 1

        #
        # Process actions
        #

        # redirect the player to the alliance page if he is not part of an alliance
        if self.AllianceId == None:
            return HttpResponseRedirect("/game/alliance/")

        action = request.GET.get("a")

        tag = ""

        if action == "cancel"
            tag = request.GET.get("tag").strip()
            oRs = oConnExecute("SELECT sp_alliance_tribute_cancel(" + str(self.UserId) + "," + dosql(tag) + ")")

            if oRs[0] == 0:
                cease_success = "ok"
            elif oRs[0] == 1:
                cease_success = "norights"
            elif oRs[0] == 2:
                cease_success = "unknown"

        elif action == == "new"

            tag = request.POST.get("tag").strip()
            credits = ToInt(request.POST.get("credits"), 0)

            oRs = oConnExecute("SELECT sp_alliance_tribute_new(" + str(self.UserId) + "," + dosql(tag) + "," + str(credits) + ")")
            if oRs[0] == 0:
                invitation_success = "ok"
                tag = ""
            elif oRs[0] == 1:
                invitation_success = "norights"
            elif oRs[0] == 2:
                invitation_success = "unknown"
            elif oRs[0] == 3:
                invitation_success = "already_exists"

        return self.displayPage(cat)

    def DisplayTributesReceived(self, content):
        col = request.GET.get("col")
        if col < 1 or col > 2: col = 1

        if col == 1:
            orderby = "tag"
        elif col == 2:
            orderby = "created"
            reversed = True

        if request.GET.get("r", "") != "":
            reversed = not reversed
        else:
            content.Parse("tributes_received_r" + str(col))

        if reversed: orderby = orderby + " DESC"
        orderby = orderby + ", tag"

        # List
        query = "SELECT w.created, alliances.id, alliances.tag, alliances.name, w.credits, w.next_transfer"+ \
                " FROM alliances_tributes w" + \
                "    INNER JOIN alliances ON (allianceid = alliances.id)" + \
                " WHERE target_allianceid=" + str(self.AllianceId) + \
                " ORDER BY " + orderby
        oRss = oConnExecuteAll(query)

        i = 0
        list = []
        content.AssignValue("tributes_received", list)
        for oRs in oRss:
            item = {}
            list.append(item)
            
            item["place"] = i+1
            item["created"] = oRs[0]
            item["tag"] = oRs[2]
            item["name"] = oRs[3]
            item["credits"] = oRs[4]
            item["next_transfer"] = oRs[5]

            i = i + 1

        if i == 0: content.Parse("tributes_received_none")

    def DisplayTributesSent(self, content):
        col = request.GET.get("col")
        if col < 1 or col > 2: col = 1

        if col == 1
            orderby = "tag"
        elif col == 2
            orderby = "created"
            reversed = True

        if request.GET.get("r", "") != "":
            reversed = not reversed
        else:
            content.Parse("tributes_sent_r" + str(col))

        if reversed: orderby = orderby + " DESC"
        orderby = orderby + ", tag"

        # List
        query = "SELECT w.created, alliances.id, alliances.tag, alliances.name, w.credits"+ \
                " FROM alliances_tributes w" + \
                "    INNER JOIN alliances ON (target_allianceid = alliances.id)" + \
                " WHERE allianceid=" + str(self.AllianceId) + \
                " ORDER BY " + orderby
        oRss = oConnExecuteAll(query)

        i = 0
        list = []
        content.AssignValue("tributes_sent", list)
        for oRs in oRss:
            item = {}
            list.append(item)
            
            item["place"] = i+1
            item["created"] = oRs[0]
            item["tag"] = oRs[2]
            item["name"] = oRs[3]
            item["credits"] = oRs[4]

            if self.oAllianceRights["can_break_nap"]: item["cancel"] = True

            i = i + 1

        if self.oAllianceRights["can_break_nap"] and (i > 0): content.Parse("tributes_sent_cancel")

        if i == 0: content.Parse("tributes_sent_none")

        if cease_success != "":
            content.Parse(cease_success)
            content.Parse("tributes_sent_message")

    def displayNew(self, content):

        if invitation_success != "":
            content.Parse(invitation_success)
            content.Parse("new_message")

        content.AssignValue("tag", tag)
        content.AssignValue("credits", credits)

        content.Parse("new")

    def displayPage(self, cat):
        content = GetTemplate(self.request, "alliance-tributes")
        content.AssignValue("cat", cat)

        if cat  == 1:
            self.displayTributesReceived(content)
        elif cat  == 2:
            self.displayTributesSent(content)
        elif cat  == 3:
            self.displayNew(content)

        content.Parse("cat" + cat + "_selected")

        content.Parse("cat1")
        content.Parse("cat2")
        if self.oAllianceRights["can_create_nap"]: content.Parse("cat3")
        content.Parse("nav")

        return self.Display(content)
