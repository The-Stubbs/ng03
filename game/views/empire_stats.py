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
    def fillContent(self, request, data):

        # --- ships data
        
        data["categories"] = []
        
        query = "SELECT category, shipid, killed, lost" + \
                " FROM gm_profile_kills" + \
                "   INNER JOIN dt_ships ON (dt_ships.id = gm_profile_kills.shipid)" + \
                " WHERE userid=" + str(self.userId) + \
                " ORDER BY shipid"
        rows = dbRows(query)

        kills = 0
        losses = 0
        
        lastcategory = -1
        for row in rows:
            
            if row[0] != lastcategory:
                
                cat = { "id":row[0], "ships":[], "kills":row[2], "losses":row[3] }
                data["categories"].append(cat)
                
                lastcategory = row[0]

            ship = {}
            cat["ships"].append(ship)
            
            ship["id"] = row[1]
            ship["name"] = getShipLabel(row[1])

            kills += row[2]
            losses += row[3]
        
        data["kills"] = kills
        data["losses"] = losses
