# -*- coding: utf-8 -*-

from game.views._base import *

#-------------------------------------------------------------------------------
class View(BaseView):

    template_name = "empire-orbittings"
    selected_menu = "orbittings"

    #---------------------------------------------------------------------------
    def dispatch(self, request, *args, **kwargs):

        response = super().pre_dispatch(request, *args, **kwargs)
        if response: return response
        
        return super().dispatch(request, *args, **kwargs)

    #---------------------------------------------------------------------------
    def fillContent(self, request, data):
        
        # --- planets data
        
        data["planets"] = []
        
        query = "SELECT gm_planets.id, gm_planets.name, gm_planets.galaxy, gm_planets.sector, gm_planets.planet," + \
                " gm_fleets.id, gm_fleets.name, gm_profiles.login, gm_alliances.tag, internal_profile_get_relation(gm_fleets.ownerid, gm_planets.ownerid), gm_fleets.signature" + \
                " FROM gm_planets" + \
                "   INNER JOIN gm_fleets ON gm_fleets.planetid=gm_planets.id" + \
                "   INNER JOIN gm_profiles ON gm_fleets.ownerid=gm_profiles.id" + \
                "   LEFT JOIN gm_alliances ON gm_profiles.alliance_id=gm_alliances.id" + \
                " WHERE gm_planets.ownerid=" + str(self.userId) + " AND gm_fleets.ownerid != gm_planets.ownerid AND action != 1 AND action != -1" + \
                " ORDER BY gm_planets.id, upper(gm_alliances.tag), upper(gm_fleets.name)"
        rows = dbRows(query)
        if rows:
        
            lastplanetid = -1
            
            for row in rows:
                
                if row[0] != lastplanetid:
                    lastplanetid = row[0]
                    
                    planet = { "fleets":[] }
                    data["planets"].append(planet)
                    
                    planet["id"] = row[0]
                    planet["name"] = row[1]
                    planet["g"] = row[2]
                    planet["s"] = row[3]
                    planet["p"] = row[4]

                fleet = {}
                planet["fleets"].append(fleet)

                fleet["tag"] = row[8]
                fleet["relation"] = row[9]
                fleet["name"] = row[6]
                fleet["ownername"] = row[7]
                fleet["signature"] = row[10]
