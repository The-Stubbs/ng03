# -*- coding: utf-8 -*-

from web_game.game._global import *

class View(GlobalView):

    def dispatch(self, request, *args, **kwargs):

        response = super().pre_dispatch(request, *args, **kwargs)
        if response: return response

        self.selected_menu = "gm_fleets.gm_fleets"

        return self.DisplayFleetsPage()

    def DisplayFleetsPage(self):

        content = GetTemplate(self.request, "gm_fleets")

        query = "SELECT category, label" + \
                " FROM gm_profile_fleet_categories" + \
                " WHERE userid=" + str(self.UserId) + \
                " ORDER BY upper(label)"
        oRss = oConnExecuteAll(query)

        list = []
        content.AssignValue("categories", list)
        for oRs in oRss:
            item = {}
            list.append(item)
            
            item["id"] = oRs[0]
            item["label"] = oRs[1]

        content.Parse("master")

        return self.Display(content)

