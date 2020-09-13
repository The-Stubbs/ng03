# -*- coding: utf-8 -*-

from web_game.game._global import *

class View(GlobalView):

    def dispatch(self, request, *args, **kwargs):

        response = super().pre_dispatch(request, *args, **kwargs)
        if response: return response

        self.selected_menu = "gm_fleets.standby"

        return self.ListStandby()

    # List the gm_fleets owned by the player
    def ListStandby(self):
        content = GetTemplate(self.request, "gm_fleets-standby")

        # list the ships
        query = "SELECT gm_planets.id, gm_planets.name, gm_planets.galaxy, gm_planets.sector, gm_planets.planet, shipid, quantity" + \
                " FROM gm_planet_ships" + \
                "    INNER JOIN gm_planets ON (gm_planet_ships.planetid = gm_planets.id)" + \
                " WHERE gm_planets.ownerid =" + str(self.UserId) + \
                " ORDER BY gm_planets.id, shipid"
        oRss = oConnExecuteAll(query)

        if oRss == None:
            content.Parse("noships")
        else:
            lastplanetid = -1

            list = []
            content.AssignValue("planets", list)
            for oRs in oRss:
                
                if oRs[0] != lastplanetid:
                    planet = { "ships":[] }
                    list.append(planet)
                    
                    lastplanetid = oRs[0]

                    planet["planetid"] = oRs[0]
                    planet["planetname"] = oRs[1]
                    planet["g"] = oRs[2]
                    planet["s"] = oRs[3]
                    planet["p"] = oRs[4]
                    
                item = {}
                planet["ships"].append(item)
                
                item["ship"] = getShipLabel(oRs[5])
                item["quantity"] = oRs[6]

        return self.Display(content)