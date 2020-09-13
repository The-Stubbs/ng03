# -*- coding: utf-8 -*-

from web_game.game._global import *

from web_game.game.lib_battle import *

class View(GlobalView):

    def dispatch(self, request, *args, **kwargs):

        response = super().pre_dispatch(request, *args, **kwargs)
        if response: return response

        self.selected_menu = "gm_battles"

        id = ToInt(request.GET.get("id"), 0)
        if id == 0:
            return HttpResponseRedirect("/game/gm_profile_reports/")

        creator = self.UserId

        fromview = ToInt(request.GET.get("v"), self.UserId)

        display_battle = True

        # check that we took part in the battle to display it
        oRs = oConnExecute("SELECT battleid FROM gm_battle_ships WHERE battleid=" + str(id) + " AND owner_id=" + str(self.UserId) + " LIMIT 1")
        display_battle = oRs != None

        if not display_battle and self.AllianceId:
            if self.oAllianceRights["can_see_reports"]:
                # check if it is a report from alliance gm_profile_reports
                oRs = oConnExecute("SELECT owner_id FROM gm_battle_ships WHERE battleid=" + str(id) + " AND (SELECT alliance_id FROM gm_profiles WHERE id=owner_id)=" + str(self.AllianceId) + " LIMIT 1")
                display_battle = oRs != None
                if oRs:
                    creator = oRs[0]#fromview

        if display_battle:

            content = FormatBattle(self, id, creator, fromview, False)
            return self.Display(content)
        else:
            return HttpResponseRedirect("/game/gm_profile_reports/")
