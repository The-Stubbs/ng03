# -*- coding: utf-8 -*-

from game.views._base import *

class View(BaseView):

    def dispatch(self, request, *args, **kwargs):

        response = super().pre_dispatch(request, *args, **kwargs)
        if response: return response

        self.selectedMenu = "alliance.tributes"

        self.invitation_success = ""
        self.cease_success = ""

        cat = ToInt(request.GET.get("cat"), 0)
        if cat < 1 or cat > 3: cat = 1

        if not (self.allianceRights["can_create_nap"] or self.allianceRights["can_break_nap"]) and cat == 3: cat = 1

        #
        # Process actions
        #

        # redirect the player to the alliance page if he is not part of an alliance
        if self.allianceId == None:
            return HttpResponseRedirect("/game/alliance/")

        action = request.GET.get("a", "")

        self.tag = ""
        self.credits = 0

        if action == "cancel":
            self.tag = request.GET.get("tag").strip()
            oRs = dbRow("SELECT user_alliance_tribute_cancel(" + str(self.userId) + "," + sqlStr(self.tag) + ")")

            if oRs[0] == 0:
                self.cease_success = "ok"
            elif oRs[0] == 1:
                self.cease_success = "norights"
            elif oRs[0] == 2:
                self.cease_success = "unknown"

        elif action == "new":

            self.tag = request.POST.get("tag", "").strip()
            self.credits = ToInt(request.POST.get("credits"), 0)

            if self.tag != "" and self.credits > 0:
                oRs = dbRow("SELECT user_alliance_tribute_create(" + str(self.userId) + "," + sqlStr(self.tag) + "," + str(self.credits) + ")")
                if oRs[0] == 0:
                    self.invitation_success = "ok"
                    self.tag = ""
                elif oRs[0] == 1:
                    self.invitation_success = "norights"
                elif oRs[0] == 2:
                    self.invitation_success = "unknown"
                elif oRs[0] == 3:
                    self.invitation_success = "already_exists"

        return self.displayPage(cat)

    def displayTributesReceived(self, content):
        col = ToInt(self.request.GET.get("col"), 0)
        if col < 1 or col > 2: col = 1

        reversed = False
        if col == 1:
            orderby = "tag"
        elif col == 2:
            orderby = "created"
            reversed = True

        if self.request.GET.get("r", "") != "":
            reversed = not reversed
        else:
            content.Parse("tributes_received_r" + str(col))

        if reversed: orderby = orderby + " DESC"
        orderby = orderby + ", tag"

        # List
        query = "SELECT w.created, gm_alliances.id, gm_alliances.tag, gm_alliances.name, w.credits, w.next_transfer"+ \
                " FROM gm_alliance_tributes w" + \
                "    INNER JOIN gm_alliances ON (allianceid = gm_alliances.id)" + \
                " WHERE target_allianceid=" + str(self.allianceId) + \
                " ORDER BY " + orderby
        oRss = dbRows(query)

        i = 0
        list = []
        content.AssignValue("items", list)
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

        if i == 0: content.Parse("none")

    def displayTributesSent(self, content):
        col = ToInt(self.request.GET.get("col"), 0)
        if col < 1 or col > 2: col = 1

        reversed = False
        if col == 1:
            orderby = "tag"
        elif col == 2:
            orderby = "created"
            reversed = True

        if self.request.GET.get("r", "") != "":
            reversed = not reversed
        else:
            content.Parse("tributes_sent_r" + str(col))

        if reversed: orderby = orderby + " DESC"
        orderby = orderby + ", tag"

        # List
        query = "SELECT w.created, gm_alliances.id, gm_alliances.tag, gm_alliances.name, w.credits"+ \
                " FROM gm_alliance_tributes w" + \
                "    INNER JOIN gm_alliances ON (target_allianceid = gm_alliances.id)" + \
                " WHERE allianceid=" + str(self.allianceId) + \
                " ORDER BY " + orderby
        oRss = dbRows(query)

        i = 0
        list = []
        content.AssignValue("items", list)
        for oRs in oRss:
            item = {}
            list.append(item)
            
            item["place"] = i+1
            item["created"] = oRs[0]
            item["tag"] = oRs[2]
            item["name"] = oRs[3]
            item["credits"] = oRs[4]

            if self.allianceRights["can_break_nap"]: item["cancel"] = True

            i = i + 1

        if self.allianceRights["can_break_nap"] and (i > 0): content.Parse("tributes_sent_cancel")

        if i == 0: content.Parse("none")

        if self.cease_success != "":
            content.Parse(self.cease_success)
            content.Parse("tributes_sent_message")

    def displayNew(self, content):

        if self.invitation_success != "":
            content.Parse(self.invitation_success)
            content.Parse("new_message")

        content.AssignValue("tag", self.tag)
        content.AssignValue("credits", self.credits)

        content.Parse("new")

    def displayPage(self, cat):
        content = self.loadTemplate("alliance-tributes")
        content.AssignValue("cat", cat)

        if cat  == 1:
            self.displayTributesReceived(content)
        elif cat  == 2:
            self.displayTributesSent(content)
        elif cat  == 3:
            self.displayNew(content)

        content.Parse("cat" + str(cat) + "_selected")

        content.Parse("cat1")
        content.Parse("cat2")
        if self.allianceRights["can_create_nap"]: content.Parse("cat3")
        content.Parse("nav")

        return self.display(content)
