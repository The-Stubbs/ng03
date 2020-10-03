# -*- coding: utf-8 -*-

from web_game.game._global import *



class View(GlobalView):

    def dispatch(self, request, *args, **kwargs):
        
        response = super().pre_dispatch(request, *args, **kwargs)
        if response: return response
            
        return super().dispatch(request, *args, **kwargs)
    
    
    
    def get(self, request, *args, **kwargs):
    
        self.selected_tab = "orbits"
        self.selected_menu = "empire"

        content = GetTemplate(self.request, "empire_orbits")

        # --- orbitting fleets data

        planets = []
        content.AssignValue("planets", planets)
        
        query = " SELECT nav_planet.id, nav_planet.name, nav_planet.galaxy, nav_planet.sector, nav_planet.planet," + \
                " fleets.id, fleets.name, users.login, alliances.tag, sp_relation(fleets.ownerid, nav_planet.ownerid), fleets.signature, fleets.attackonsight" + \
                " FROM nav_planet" + \
                "    INNER JOIN fleets ON fleets.planetid=nav_planet.id" + \
                "    INNER JOIN users ON fleets.ownerid=users.id" + \
                "    LEFT JOIN alliances ON users.alliance_id=alliances.id" + \
                " WHERE nav_planet.ownerid=" + str(self.UserId) + " AND fleets.ownerid != nav_planet.ownerid AND action != 1 AND action != -1" + \
                " ORDER BY nav_planet.id, upper(alliances.tag), upper(fleets.name)"
        oRss = oConnExecuteAll(query)
        if oRss:
        
            lastplanetid = -1
            for oRs in oRss:
                
                if oRs[0] != lastplanetid:
                    lastplanetid = oRs[0]
                
                    planet = { "fleets":[] }
                    planets.append(planet)
                    
                    planet["id"] = oRs[0]
                    planet["name"] = oRs[1]
                    planet["g"] = oRs[2]
                    planet["s"] = oRs[3]
                    planet["p"] = oRs[4]
                    
                item = {}
                planet["fleets"].append(item)

                item["tag"] = oRs[8]
                item["name"] = oRs[6]
                item["owner"] = oRs[7]
                item["relation"] = oRs[9]
                item["signature"] = oRs[10]
                item["stance"] = oRs[11]

        return self.Display(content)
