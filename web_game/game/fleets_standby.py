# -*- coding: utf-8 -*-

from web_game.game._global import *

class View(GlobalView):

    def dispatch(self, request, *args, **kwargs):

        response = super().pre_dispatch(request, *args, **kwargs)
        if response: return response

        self.selected_menu = "fleets.standby"

        return self.ListStandby()

    # List the fleets owned by the player
    def ListStandby(self):
        content = GetTemplate(self.request, "fleets-standby")

        # list the ships
        query = "SELECT nav_planet.id, nav_planet.name, nav_planet.galaxy, nav_planet.sector, nav_planet.planet, shipid, quantity" + \
                " FROM planet_ships" + \
                "    INNER JOIN nav_planet ON (planet_ships.planetid = nav_planet.id)" + \
                " WHERE nav_planet.ownerid =" + str(self.UserId) + \
                " ORDER BY nav_planet.id, shipid"
        oRss = oConnExecuteAll(query)

        if oRs == None:
            content.Parse("noships"
        else:
            lastplanetid = oRs[0]

            list = []
            for oRs in oRss:
                item = {}
                list.append(item)
                
                if oRs[0] != lastplanetid:
                    content.Parse("planet"
                    lastplanetid = oRs[0]

                item["planetid", oRs[0]
                item["planetname", oRs[1]
                item["g", oRs[2]
                item["s", oRs[3]
                item["p", oRs[4]
                item["ship", getShipLabel(oRs[5])
                item["quantity", oRs[6]

                content.Parse("planet.ship"

            content.Parse("planet"

        return self.Display(content)

