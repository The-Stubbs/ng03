# -*- coding: utf-8 -*-

from game.views._base import *

class View(GlobalView):

    def dispatch(self, request, *args, **kwargs):

        response = super().pre_dispatch(request, *args, **kwargs)
        if response: return response

        self.selected_menu = "fleets_ships_stats"

        return self.ListShips()

    # List all the available ships for construction
    def ListShips(self):

        # list ships that can be built on the planet
        query = "SELECT category, shipid, killed, lost" + \
                " FROM gm_profile_kills" + \
                "    INNER JOIN dt_ships ON (dt_ships.id = gm_profile_kills.shipid)" + \
                " WHERE userid=" + str(self.UserId) + \
                " ORDER BY shipid"
        oRss = oConnExecuteAll(query)

        content = GetTemplate(self.request, "gm_fleets-ships-stats")

        count = 0
        kills = 0
        losses = 0
        
        cats = []
        content.AssignValue("cats", cats)
        
        lastCategory = -1
        for oRs in oRss:
            
            if oRs[0] != lastCategory:
                
                cat = { "id":oRs[0], "ships":[], "kills":0, "losses":0 }
                cats.append(cat)
                
                lastCategory = oRs[0]

            item = {}
            cat["ships"].append(item)
            
            item["id"] = oRs[1]
            item["name"] = getShipLabel(oRs[1])
            item["killed"] = oRs[2]
            item["lost"] = oRs[3]

            kills += oRs[2]
            losses += oRs[3]
            
            count = count + 1

        if count == 0: content.Parse("no_ship")
        else: content.Parse("total")
        
        content.AssignValue("kills", kills)
        content.AssignValue("losses", losses)

        return self.Display(content)
