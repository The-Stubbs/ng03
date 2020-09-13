# -*- coding: utf-8 -*-

from web_game.game._global import *

class View(GlobalView):

    def dispatch(self, request, *args, **kwargs):

        response = super().pre_dispatch(request, *args, **kwargs)
        if response: return response

        if self.AllianceId == None:
            self.selected_menu = "noalliance.invitations"
        else:
            self.selected_menu = "alliance.invitations"

        self.sLeaveCost = "leavealliancecost"

        self.leave_status = ""
        self.invitation_status = ""
        action = request.GET.get("a", "").strip()
        alliance_tag = request.GET.get("tag", "").strip()

        if action == "accept":
            oRs = oConnExecute("SELECT user_alliance_invitation_accept(" + str(self.UserId) + "," + dosql(alliance_tag) + ")")

            if oRs[0] == 0:
                return HttpResponseRedirect("/game/alliance/")

            elif oRs[0] == 4:
                self.invitation_status = "max_members_reached"
            elif oRs[0] == 6:
                self.invitation_status = "cant_rejoin_previous_alliance"

        elif action == "decline":
            oConnExecute("SELECT user_alliance_invitation_decline(" + str(self.UserId) + "," + dosql(alliance_tag) + ")")
        elif action == "leave":
            if self.request.session.get(self.sLeaveCost) and request.POST.get("leave") == 1:
                oRs = oConnExecute("SELECT user_alliance_leave(" + str(self.UserId) + "," + self.request.session.get(self.sLeaveCost) + ")")
                if oRs[0] == 0:
                    return HttpResponseRedirect("/game/alliance/")

            else:
                self.leave_status = "not_enough_credits"

        return self.DisplayInvitations()

    def DisplayInvitations(self):
        content = GetTemplate(self.request, "alliance-invitations")

        oRs = oConnExecute("SELECT date_part('epoch', static_alliance_joining_delay()) / 3600")
        content.AssignValue("hours_before_rejoin", int(oRs[0]))

        query = "SELECT gm_alliances.tag, gm_alliances.name, gm_alliance_invitations.created, gm_profiles.login" + \
                " FROM gm_alliance_invitations" + \
                "        INNER JOIN gm_alliances ON gm_alliances.id = gm_alliance_invitations.allianceid"+ \
                "        LEFT JOIN gm_profiles ON gm_profiles.id = gm_alliance_invitations.recruiterid"+ \
                " WHERE userid=" + str(self.UserId) + " AND NOT declined" + \
                " ORDER BY created DESC"

        oRss = oConnExecuteAll(query)

        i = 0
        list = []
        for oRs in oRss:
            item = {}
            item["tag"] = oRs[0]
            item["name"] = oRs[1]

            created = oRs[2]
            item["date"] = created

            item["recruiter"] = oRs[3]

            if self.oPlayerInfo["can_join_alliance"]:
                if self.AllianceId:
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
        if not self.oPlayerInfo["can_join_alliance"]: content.Parse("cant_join")

        # Display the "leave" section if the player is in an alliance
        if self.AllianceId and self.oPlayerInfo["can_join_alliance"]:

            oRs = oConnExecute("SELECT internal_profile_get_alliance_leaving_cost(" + str(self.UserId) + ")")

            self.request.session[self.sLeaveCost] = oRs[0]
            if self.request.session.get(self.sLeaveCost) < 2000: self.request.session[self.sLeaveCost] = 0

            content.AssignValue("credits", self.request.session.get(self.sLeaveCost))

            if self.request.session.get(self.sLeaveCost) > 0: content.Parse("charges")

            if self.leave_status != "": content.Parse(self.leave_status)

            content.Parse("leave")

        self.FillHeaderCredits(content)

        return self.Display(content)
