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

        # --- planets data
        
        data["planets"] = []
        
        query = "SELECT gm_planets.id, gm_planets.name, gm_planets.galaxy, gm_planets.sector, gm_planets.planet, shipid, quantity" + \
                " FROM gm_planet_ships" + \
                "   INNER JOIN gm_planets ON (gm_planet_ships.planetid = gm_planets.id)" + \
                " WHERE gm_planets.ownerid =" + str(self.userId) + \
                " ORDER BY gm_planets.id, shipid"
        rows = dbRows(query)
        if rows:
            lastplanetid = -1
            for row in rows:
                
                if row[0] != lastplanetid:
                    lastplanetid = row[0]
                
                    planet = { "ships":[] }
                    data["planets"].append(planet)                    

                    planet["id"] = row[0]
                    planet["name"] = row[1]
                    planet["g"] = row[2]
                    planet["s"] = row[3]
                    planet["p"] = row[4]
                    
                ship = {}
                planet["ships"].append(ship)
                
                ship["ship"] = getShipLabel(row[5])
                ship["quantity"] = row[6]
