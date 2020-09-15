# -*- coding: utf-8 -*-

from game.views._base import *

class View(BaseView):

    def dispatch(self, request, *args, **kwargs):

        response = super().pre_dispatch(request, *args, **kwargs)
        if response: return response

        self.selectedMenu = "gm_fleets.orbiting"

        return self.listFleetsOrbiting()

    # list gm_fleets not belonging to the player that are near his planets
    def listFleetsOrbiting(self):

        content = self.loadTemplate("gm_fleets-orbiting")

        query = "SELECT gm_planets.id, gm_planets.name, gm_planets.galaxy, gm_planets.sector, gm_planets.planet," + \
                " gm_fleets.id, gm_fleets.name, gm_profiles.login, gm_alliances.tag, internal_profile_get_relation(gm_fleets.ownerid, gm_planets.ownerid), gm_fleets.signature" + \
                " FROM gm_planets" + \
                "    INNER JOIN gm_fleets ON gm_fleets.planetid=gm_planets.id" + \
                "    INNER JOIN gm_profiles ON gm_fleets.ownerid=gm_profiles.id" + \
                "    LEFT JOIN gm_alliances ON gm_profiles.alliance_id=gm_alliances.id" + \
                " WHERE gm_planets.ownerid=" + str(self.userId) + " AND gm_fleets.ownerid != gm_planets.ownerid AND action != 1 AND action != -1" + \
                " ORDER BY gm_planets.id, upper(gm_alliances.tag), upper(gm_fleets.name)"
        oRss = dbRows(query)

        if oRss == None:
            content.Parse("nofleets")
        else:
            lastplanetid=-1

            planets = []
            content.AssignValue("planets", planets)
            
            for oRs in oRss:
                
                if oRs[0] != lastplanetid:
                    planet = { "gm_fleets":[] }
                    planets.append(planet)
                    
                    planet["planetid"] = oRs[0]
                    planet["planetname"] = oRs[1]
                    planet["g"] = oRs[2]
                    planet["s"] = oRs[3]
                    planet["p"] = oRs[4]
                    
                    lastplanetid = oRs[0]

                item = {}
                planet["gm_fleets"].append(item)

                if (oRs[8]):
                    item["tag"] = oRs[8]
                    item["alliance"] = True

                if oRs[9] == -1:
                    item["enemy"] = True
                elif oRs[9] == 0:
                    item["friend"] = True
                elif oRs[9] == 1:
                    item["ally"] = True

                item["fleetname"] = oRs[6]
                item["fleetowner"] = oRs[7]
                item["fleetsignature"] = oRs[10]

        return self.display(content)
