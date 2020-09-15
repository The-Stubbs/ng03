# -*- coding: utf-8 -*-

from game.views._base import *

class View(BaseView):

    def dispatch(self, request, *args, **kwargs):

        response = super().pre_dispatch(request, *args, **kwargs)
        if response: return response

        self.selectedMenu = "gm_battles"

        id = ToInt(request.GET.get("id"), 0)
        if id == 0:
            return HttpResponseRedirect("/game/gm_profile_reports/")

        creator = self.userId

        fromview = ToInt(request.GET.get("v"), self.userId)

        display_battle = True

        # check that we took part in the battle to display it
        oRs = dbRow("SELECT battleid FROM gm_battle_ships WHERE battleid=" + str(id) + " AND owner_id=" + str(self.userId) + " LIMIT 1")
        display_battle = oRs != None

        if not display_battle and self.allianceId:
            if self.allianceRights["can_see_reports"]:
                # check if it is a report from alliance gm_profile_reports
                oRs = dbRow("SELECT owner_id FROM gm_battle_ships WHERE battleid=" + str(id) + " AND (SELECT alliance_id FROM gm_profiles WHERE id=owner_id)=" + str(self.allianceId) + " LIMIT 1")
                display_battle = oRs != None
                if oRs:
                    creator = oRs[0]#fromview

        if display_battle:

            content = formatBattle(self, id, creator, fromview, False)
            return self.display(content)
        else:
            return HttpResponseRedirect("/game/gm_profile_reports/")
