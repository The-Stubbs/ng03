# -*- coding: utf-8 -*-

from game.views._base import *

#-------------------------------------------------------------------------------
class View(BaseView):

    def dispatch(self, request, *args, **kwargs):

        response = super().pre_dispatch(request, *args, **kwargs)
        if response: return response

        self.selected_menu = "gm_fleets.standby"

        return self.ListStandby()

    # List the gm_fleets owned by the player
    def ListStandby(self):
        content = self.loadTemplate("gm_fleets-standby")

        # list the ships
        query = "SELECT gm_planets.id, gm_planets.name, gm_planets.galaxy, gm_planets.sector, gm_planets.planet, shipid, quantity" + \
                " FROM gm_planet_ships" + \
                "    INNER JOIN gm_planets ON (gm_planet_ships.planetid = gm_planets.id)" + \
                " WHERE gm_planets.ownerid =" + str(self.userId) + \
                " ORDER BY gm_planets.id, shipid"
        rows = dbRows(query)

        if oRss == None:
            content.Parse("noships")
        else:
            lastplanetid = -1

            list = []
            content.AssignValue("planets", list)
            for row in rows:
                
                if row[0] != lastplanetid:
                    planet = { "ships":[] }
                    list.append(planet)
                    
                    lastplanetid = row[0]

                    planet["planetid"] = row[0]
                    planet["planetname"] = row[1]
                    planet["g"] = row[2]
                    planet["s"] = row[3]
                    planet["p"] = row[4]
                    
                item = {}
                planet["ships"].append(item)
                
                item["ship"] = getShipLabel(row[5])
                item["quantity"] = row[6]

        return self.display(content)
