# -*- coding: utf-8 -*-

from game.views._base import *

#-------------------------------------------------------------------------------
class View(BaseView):

    success_url = ""
    template_name = ""
    selected_menu = ""

    #---------------------------------------------------------------------------
    def dispatch(self, request, *args, **kwargs):

        response = super().pre_dispatch(request, *args, **kwargs)
        if response: return response
        
        return super().dispatch(request, *args, **kwargs)

    #---------------------------------------------------------------------------

        id = ToInt(request.GET.get("id"), 0)
        if id == 0:
            return HttpResponseRedirect("/game/gm_profile_reports/")

        creator = self.userId

        fromview = ToInt(request.GET.get("v"), self.userId)

        display_battle = True

        # check that we took part in the battle to display it
        row = dbRow("SELECT battleid FROM gm_battle_ships WHERE battleid=" + str(id) + " AND owner_id=" + str(self.userId) + " LIMIT 1")
        display_battle = row != None

        if not display_battle and self.allianceId:
            if self.allianceRights["can_see_reports"]:
                # check if it is a report from alliance gm_profile_reports
                row = dbRow("SELECT owner_id FROM gm_battle_ships WHERE battleid=" + str(id) + " AND (SELECT alliance_id FROM gm_profiles WHERE id=owner_id)=" + str(self.allianceId) + " LIMIT 1")
                display_battle = row != None
                if row:
                    creator = row[0]#fromview

        if display_battle:

            content = formatBattle(self, id, creator, fromview, False)

        else:
            return HttpResponseRedirect("/game/gm_profile_reports/")
