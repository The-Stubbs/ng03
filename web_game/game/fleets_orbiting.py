# -*- coding: utf-8 -*-

from web_game.game._global import *

class View(GlobalView):

    def dispatch(self, request, *args, **kwargs):

        response = super().pre_dispatch(request, *args, **kwargs)
        if response: return response

        self.selected_menu = "fleets.orbiting"

        listFleetsOrbiting

    # list fleets not belonging to the player that are near his planets
    def listFleetsOrbiting(self):

        content = GetTemplate(self.request, "fleets-orbiting")

        query = "SELECT nav_planet.id, nav_planet.name, nav_planet.galaxy, nav_planet.sector, nav_planet.planet," + \
                " fleets.id, fleets.name, users.login, alliances.tag, sp_relation(fleets.ownerid, nav_planet.ownerid), fleets.signature" + \
                " FROM nav_planet" + \
                "    INNER JOIN fleets ON fleets.planetid=nav_planet.id" + \
                "    INNER JOIN users ON fleets.ownerid=users.id" + \
                "    LEFT JOIN alliances ON users.alliance_id=alliances.id" + \
                " WHERE nav_planet.ownerid=" + str(self.UserId) + " AND fleets.ownerid != nav_planet.ownerid AND action != 1 AND action != -1" + \
                " ORDER BY nav_planet.id, upper(alliances.tag), upper(fleets.name)"
        oRss = oConnExecuteAll(query)

        if oRs == None:
            content.Parse("nofleets"
        else:
            lastplanetid=oRs[0]

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

                if (oRs[8]):
                    item["tag", oRs[8]
                    content.Parse("planet.fleet.alliance"

                if oRs[9] == -1:
                    content.Parse("planet.fleet.enemy"
                elif oRs[9] == 0:
                    content.Parse("planet.fleet.friend"
                elif oRs[9] == 1:
                    content.Parse("planet.fleet.ally"

                item["fleetname", oRs[6]
                item["fleetowner", oRs[7]
                item["fleetsignature", oRs[10]
                content.Parse("planet.fleet"

            content.Parse("planet"

        return self.Display(content)

