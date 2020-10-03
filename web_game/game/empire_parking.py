# -*- coding: utf-8 -*-

from web_game.game._global import *



class View(GlobalView):

    def dispatch(self, request, *args, **kwargs):

        response = super().pre_dispatch(request, *args, **kwargs)
        if response: return response
            
        return super().dispatch(request, *args, **kwargs)
    
    
    
    def get(self, request, *args, **kwargs):
    
        self.selected_tab = "parking"
        self.selected_menu = "empire"

        content = GetTemplate(self.request, "empire_parking")

        # --- parking ships data

        planets = []
        content.AssignValue("planets", planets)
        
        query = " SELECT nav_planet.id, nav_planet.name, nav_planet.galaxy, nav_planet.sector, nav_planet.planet, shipid, quantity, db_ships.label" + \
                " FROM planet_ships" + \
                "   INNER JOIN nav_planet ON (planet_ships.planetid = nav_planet.id)" + \
                "   INNER JOIN db_ships ON db_ships.id = shipid" + \
                " WHERE nav_planet.ownerid =" + str(self.UserId) + \
                " ORDER BY nav_planet.id, shipid"
        oRss = oConnExecuteAll(query)
        if oRss:
        
            lastplanetid = -1
            for oRs in oRss:
                
                if oRs[0] != lastplanetid:
                    lastplanetid = oRs[0]
                    
                    planet = { "ships":[] }
                    planets.append(planet)

                    planet["id"] = oRs[0]
                    planet["name"] = oRs[1]
                    planet["g"] = oRs[2]
                    planet["s"] = oRs[3]
                    planet["p"] = oRs[4]
                    
                item = {}
                planet["ships"].append(item)
                
                item["name"] = oRs[7]
                item["quantity"] = oRs[6]

        return self.Display(content)
