# -*- coding: utf-8 -*-

from game.views._base import *

class View(BaseView):

    def dispatch(self, request, *args, **kwargs):

        response = super().pre_dispatch(request, *args, **kwargs)
        if response: return response

        if self.allianceId == None:
            self.selectedMenu = "noalliance.invitations"
        else:
            self.selectedMenu = "alliance.invitations"

        self.sLeaveCost = "leavealliancecost"

        self.leave_status = ""
        self.invitation_status = ""
        action = request.GET.get("a", "").strip()
        alliance_tag = request.GET.get("tag", "").strip()

        if action == "accept":
            oRs = dbRow("SELECT user_alliance_invitation_accept(" + str(self.userId) + "," + sqlStr(alliance_tag) + ")")

            if oRs[0] == 0:
                return HttpResponseRedirect("/game/alliance/")

            elif oRs[0] == 4:
                self.invitation_status = "max_members_reached"
            elif oRs[0] == 6:
                self.invitation_status = "cant_rejoin_previous_alliance"

        elif action == "decline":
            dbRow("SELECT user_alliance_invitation_decline(" + str(self.userId) + "," + sqlStr(alliance_tag) + ")")
        elif action == "leave":
            if self.request.session.get(self.sLeaveCost) and request.POST.get("leave") == 1:
                oRs = dbRow("SELECT user_alliance_leave(" + str(self.userId) + "," + self.request.session.get(self.sLeaveCost) + ")")
                if oRs[0] == 0:
                    return HttpResponseRedirect("/game/alliance/")

            else:
                self.leave_status = "not_enough_credits"

        return self.DisplayInvitations()

    def DisplayInvitations(self):
        content = self.loadTemplate("alliance-invitations")

        oRs = dbRow("SELECT date_part('epoch', static_alliance_joining_delay()) / 3600")
        content.AssignValue("hours_before_rejoin", int(oRs[0]))

        query = "SELECT gm_alliances.tag, gm_alliances.name, gm_alliance_invitations.created, gm_profiles.login" + \
                " FROM gm_alliance_invitations" + \
                "        INNER JOIN gm_alliances ON gm_alliances.id = gm_alliance_invitations.allianceid"+ \
                "        LEFT JOIN gm_profiles ON gm_profiles.id = gm_alliance_invitations.recruiterid"+ \
                " WHERE userid=" + str(self.userId) + " AND NOT declined" + \
                " ORDER BY created DESC"

        oRss = dbRows(query)

        i = 0
        list = []
        for oRs in oRss:
            item = {}
            item["tag"] = oRs[0]
            item["name"] = oRs[1]

            created = oRs[2]
            item["date"] = created

            item["recruiter"] = oRs[3]

            if self.userInfo["can_join_alliance"]:
                if self.allianceId:
                    item["cant_accept"] = True
                else:
                    item["accept"] = True

            else:
                item["cant_join"] = True

            list.append(item)

            i = i + 1
        content.AssignValue("invitations", list)

        if self.invitation_status != "": content.Parse(self.invitation_status)

        if i == 0: content.Parse("noinvitations")

        # Parse "cant_join" section if the player can't create/join an alliance
        if not self.userInfo["can_join_alliance"]: content.Parse("cant_join")

        # Display the "leave" section if the player is in an alliance
        if self.allianceId and self.userInfo["can_join_alliance"]:

            oRs = dbRow("SELECT internal_profile_get_alliance_leaving_cost(" + str(self.userId) + ")")

            self.request.session[self.sLeaveCost] = oRs[0]
            if self.request.session.get(self.sLeaveCost) < 2000: self.request.session[self.sLeaveCost] = 0

            content.AssignValue("credits", self.request.session.get(self.sLeaveCost))

            if self.request.session.get(self.sLeaveCost) > 0: content.Parse("charges")

            if self.leave_status != "": content.Parse(self.leave_status)

            content.Parse("leave")

        self.FillHeaderCredits(content)

        return self.display(content)
