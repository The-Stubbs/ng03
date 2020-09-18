# -*- coding: utf-8 -*-

from game.views._base import *

#-------------------------------------------------------------------------------
class View(BaseView):

    def dispatch(self, request, *args, **kwargs):

        response = super().pre_dispatch(request, *args, **kwargs)
        if response: return response

        self.selected_menu = "gm_fleets.orbiting"

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
            
            for row in oRss:
                
                if row[0] != lastplanetid:
                    planet = { "gm_fleets":[] }
                    planets.append(planet)
                    
                    planet["planetid"] = row[0]
                    planet["planetname"] = row[1]
                    planet["g"] = row[2]
                    planet["s"] = row[3]
                    planet["p"] = row[4]
                    
                    lastplanetid = row[0]

                item = {}
                planet["gm_fleets"].append(item)

                if (row[8]):
                    item["tag"] = row[8]
                    item["alliance"] = True

                if row[9] == -1:
                    item["enemy"] = True
                elif row[9] == 0:
                    item["friend"] = True
                elif row[9] == 1:
                    item["ally"] = True

                item["fleetname"] = row[6]
                item["fleetowner"] = row[7]
                item["fleetsignature"] = row[10]

        return self.display(content)
