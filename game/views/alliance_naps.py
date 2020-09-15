# -*- coding: utf-8 -*-

from game.views._base import *

class View(BaseView):

    def dispatch(self, request, *args, **kwargs):

        response = super().pre_dispatch(request, *args, **kwargs)
        if response: return response

        self.selectedMenu = "alliance.naps"

        self.invitation_success = ""
        self.break_success = ""
        self.nap_success = ""

        cat = ToInt(request.GET.get("cat"), 0)
        if cat < 1 or cat > 3: cat = 1

        if not self.allianceRights["can_create_nap"] and cat == 3: cat = 1
        if not (self.allianceRights["can_create_nap"] or self.allianceRights["can_break_nap"]) and cat != 1: cat = 1

        #
        # Process actions
        #

        # redirect the player to the alliance page if he is not part of an alliance
        if self.allianceId == None:
            return HttpResponseRedirect("/game/alliance/")

        action = request.GET.get("a", "")
        targetalliancetag = request.GET.get("tag", "").strip()

        self.tag = ""
        self.hours = 24

        if action == "accept":
            oRs = dbRow("SELECT user_alliance_nap_offer_accept(" + str(self.userId) + "," + sqlStr(targetalliancetag) + ")")
            if oRs[0] == 0:
                self.nap_success = "ok"
            elif oRs[0] == 5:
                self.nap_success = "too_many"

        elif action == "decline":
            dbRow("SELECT user_alliance_nap_offer_decline(" + str(self.userId) + "," + sqlStr(targetalliancetag) + ")")
        elif action == "cancel":
            dbRow("SELECT user_alliance_nap_offer_cancel(" + str(self.userId) + "," + sqlStr(targetalliancetag) + ")")
        elif action == "sharelocs":
            dbRow("SELECT user_alliance_nap_toggle_loc_sharing(" + str(self.userId) + "," + sqlStr(targetalliancetag) + ")")
        elif action == "shareradars":
            dbRow("SELECT user_alliance_nap_toggle_radar_sharing(" + str(self.userId) + "," + sqlStr(targetalliancetag) + ")")
        elif action == "break":
            oRs = dbRow("SELECT user_alliance_nap_break(" + str(self.userId) + "," + sqlStr(targetalliancetag) + ")")

            if oRs[0] == 0:
                self.break_success = "ok"
            elif oRs[0] == 1:
                self.break_success = "norights"
            elif oRs[0] == 2:
                self.break_success = "unknown"
            elif oRs[0] == 3:
                self.break_success = "nap_not_found"
            elif oRs[0] == 4:
                self.break_success = "not_enough_credits"

        elif action == "new":
            self.tag = request.POST.get("tag", "").strip()

            self.hours = ToInt(request.POST.get("hours"), 0)

            oRs = dbRow("SELECT user_alliance_nap_offer_create(" + str(self.userId) + "," + sqlStr(self.tag) + "," + str(self.hours) + ")")
            if oRs[0] == 0:
                self.invitation_success = "ok"
                self.tag = ""
                self.hours = 24
            elif oRs[0] == 1:
                self.invitation_success = "norights"
            elif oRs[0] == 2:
                self.invitation_success = "unknown"
            elif oRs[0] == 3:
                self.invitation_success = "already_naped"
            elif oRs[0] == 4:
                self.invitation_success = "request_waiting"
            elif oRs[0] == 6:
                self.invitation_success = "already_requested"

        return self.displayPage(cat)

    def displayNAPs(self, content):
        col = ToInt(self.request.GET.get("col"), 0)
        if col < 1 or col > 4: col = 1
        if col == 2: col = 1

        reversed = False
        if col == 1:
            orderby = "tag"
        elif col == 3:
            orderby = "created"
            reversed = True
        elif col == 4:
            orderby = "break_interval"
        elif col == 5:
            orderby = "share_locs"
        elif col == 6:
            orderby = "share_radars"

        if self.request.GET.get("r", "") != "":
            reversed = not reversed
        else:
            content.Parse("r" + str(col))

        if reversed: orderby = orderby + " DESC"
        orderby = orderby + ", tag"

        # List Non Aggression Pacts
        query = "SELECT n.allianceid2, tag, name, "+ \
                " (SELECT COALESCE(sum(score)/1000, 0) AS score FROM gm_profiles WHERE alliance_id=allianceid2), n.created, date_part('epoch', n.break_interval)::integer, date_part('epoch', break_on-now())::integer," + \
                " share_locs, share_radars" + \
                " FROM gm_alliance_naps n" + \
                "    INNER JOIN gm_alliances ON (allianceid2 = gm_alliances.id)" + \
                " WHERE allianceid1=" + str(self.allianceId) + \
                " ORDER BY " + orderby
        oRss = dbRows(query)

        i = 0
        list = []
        content.AssignValue("naps", list)
        for oRs in oRss:
            item = {}
            list.append(item)
            
            item["place"] = i+1
            item["tag"] = oRs[1]
            item["name"] = oRs[2]
            item["score"] = oRs[3]
            item["created"] = oRs[4]

            if oRs[6] == None:
                item["break_interval"] = oRs[5]
                item["time"] = True
            else:
                item["break_interval"] = oRs[6]
                item["countdown"] = True

            if oRs[7]:
                item["locs_shared"] = True
            else:
                item["locs_not_shared"] = True

            if self.allianceRights["can_create_nap"]:
                item["toggle_share_locs"] = True

            if oRs[8]:
                item["radars_shared"] = True
            else:
                item["radars_not_shared"] = True

            if self.allianceRights["can_create_nap"]:
                item["toggle_share_radars"] = True

            if self.allianceRights["can_break_nap"]:
                if oRs[6] == None:
                    item["break"] = True
                else:
                    item["broken"] = True

            i = i + 1

        if self.allianceRights["can_break_nap"] and (i > 0): content.Parse("break")

        if i == 0: content.Parse("nonaps")

        if self.break_success != "":
            content.Parse(self.break_success)
            content.Parse("message")

    def displayPropositions(self, content):

        # List NAPs that other gm_alliances have offered
        query = "SELECT gm_alliances.tag, gm_alliances.name, gm_alliance_nap_offers.created, recruiters.login, declined, date_part('epoch', break_interval)::integer" + \
                " FROM gm_alliance_nap_offers" + \
                "            INNER JOIN gm_alliances ON gm_alliances.id = gm_alliance_nap_offers.allianceid" + \
                "            LEFT JOIN gm_profiles AS recruiters ON recruiters.id = gm_alliance_nap_offers.recruiterid" + \
                " WHERE targetallianceid=" + str(self.allianceId) + " AND NOT declined" + \
                " ORDER BY created DESC"
        oRss = dbRows(query)

        i = 0
        list = []
        content.AssignValue("propositions", list)
        for oRs in oRss:
            item = {}
            list.append(item)
            
            item["tag"] = oRs[0]
            item["name"] = oRs[1]
            item["date"] = oRs[2]
            item["recruiter"] = oRs[3]

            if oRs[4]: item["declined"] = True
            else: item["waiting"] = True

            item["break_interval"] = oRs[5]

            i = i + 1

        if i == 0: content.Parse("nopropositions")

        if self.nap_success != "":
            content.Parse(self.nap_success)
            content.Parse("message")

    def displayRequests(self, content):

        # List NAPs we proposed to other gm_alliances
        query = "SELECT gm_alliances.tag, gm_alliances.name, gm_alliance_nap_offers.created, recruiters.login, declined, date_part('epoch', break_interval)::integer" + \
                " FROM gm_alliance_nap_offers" + \
                "            INNER JOIN gm_alliances ON gm_alliances.id = gm_alliance_nap_offers.targetallianceid" + \
                "            LEFT JOIN gm_profiles AS recruiters ON recruiters.id = gm_alliance_nap_offers.recruiterid" + \
                " WHERE allianceid=" + str(self.allianceId) + \
                " ORDER BY created DESC"

        oRss = dbRows(query)

        i = 0
        list = []
        content.AssignValue("newnaps", list)
        for oRs in oRss:
            item = {}
            list.append(item)
            
            item["tag"] = oRs[0]
            item["name"] = oRs[1]
            item["date"] = oRs[2]
            item["recruiter"] = oRs[3]

            if oRs[4]: item["declined"] = True
            else: item["waiting"] = True

            item["break_interval"] = oRs[5]

            i = i + 1

        if i == 0: content.Parse("norequests")

        if self.invitation_success != "":
            content.Parse(self.invitation_success)
            content.Parse("message")

        content.AssignValue("tag", self.tag)
        content.AssignValue("hours", self.hours)

    def displayPage(self, cat):
        content = self.loadTemplate("alliance-naps")
        content.AssignValue("cat", cat)

        if cat == 1:
            self.displayNAPs(content)
        elif cat == 2:
            self.displayPropositions(content)
        elif cat == 3:
            self.displayRequests(content)

        if self.allianceRights["can_create_nap"] or self.allianceRights["can_break_nap"]:

            query = "SELECT int4(count(*)) FROM gm_alliance_nap_offers" + \
                    " WHERE targetallianceid=" + str(self.allianceId) + " AND NOT declined"
            oRs = dbRow(query)
            content.AssignValue("proposition_count", oRs[0])

            query = "SELECT int4(count(*)) FROM gm_alliance_nap_offers" + \
                    " WHERE allianceid=" + str(self.allianceId) + " AND NOT declined"
            oRs = dbRow(query)
            content.AssignValue("request_count", oRs[0])

            content.Parse("cat" + str(cat) + "_selected")
            content.Parse("cat1")
            content.Parse("cat2")
            if self.allianceRights["can_create_nap"]: content.Parse("cat3")
            content.Parse("nav")

        return self.display(content)
