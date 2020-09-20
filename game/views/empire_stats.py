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

    # List all the available ships for construction
    def ListShips(self):

        # list ships that can be built on the planet
        query = "SELECT category, shipid, killed, lost" + \
                " FROM gm_profile_kills" + \
                "    INNER JOIN dt_ships ON (dt_ships.id = gm_profile_kills.shipid)" + \
                " WHERE userid=" + str(self.userId) + \
                " ORDER BY shipid"
        rows = dbRows(query)

        content = self.loadTemplate("gm_fleets-ships-stats")

        count = 0
        kills = 0
        losses = 0
        
        cats = []
        content.AssignValue("cats", cats)
        
        lastCategory = -1
        for row in rows:
            
            if row[0] != lastCategory:
                
                cat = { "id":row[0], "ships":[], "kills":0, "losses":0 }
                cats.append(cat)
                
                lastCategory = row[0]

            item = {}
            cat["ships"].append(item)
            
            item["id"] = row[1]
            item["name"] = getShipLabel(row[1])
            item["killed"] = row[2]
            item["lost"] = row[3]

            kills += row[2]
            losses += row[3]
            
            count = count + 1

        if count == 0: content.Parse("no_ship")
        else: content.Parse("total")
        
        content.AssignValue("kills", kills)
        content.AssignValue("losses", losses)

        return self.display(content)
