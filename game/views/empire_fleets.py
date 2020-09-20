# -*- coding: utf-8 -*-

from game.views._base import *

#-------------------------------------------------------------------------------
class View(BaseView):

    success_url = "/game/empire-fleets/"
    template_name = "empire-fleets"
    selected_menu = "fleets"

    #---------------------------------------------------------------------------
    def dispatch(self, request, *args, **kwargs):

        response = super().pre_dispatch(request, *args, **kwargs)
        if response: return response
        
        return super().dispatch(request, *args, **kwargs)

    #---------------------------------------------------------------------------
    def fillContent(self, request, data):

        # --- fleet categories data

        data["categories"] = []
        
        query = "SELECT category, label" + \
                " FROM gm_profile_fleet_categories" + \
                " WHERE userid=" + str(self.userId) + \
                " ORDER BY upper(label)"
        rows = dbRows(query)
        if rows:
            for row in rows:

                category = {}
                data["categories"].append(category)
                
                category["id"] = row[0]
                category["label"] = row[1]

        # --- fleets data

        data["fleets"] = []
        
        query = "SELECT id, name, attackonsight, engaged, size, signature, speed, remaining_time, commanderid, commandername," + \
                " planetid, planet_name, planet_galaxy, planet_sector, planet_planet, planet_ownerid, planet_owner_name, planet_owner_relation," + \
                " destplanetid, destplanet_name, destplanet_galaxy, destplanet_sector, destplanet_planet, destplanet_ownerid, destplanet_owner_name, destplanet_owner_relation," + \
                " cargo_capacity, cargo_ore, cargo_hydro, cargo_scientists, cargo_soldiers, cargo_workers," + \
                " recycler_output, orbit_ore > 0 OR orbit_hydro > 0, action," + \
                "( SELECT int4(COALESCE(max(gm_planets.radar_strength), 0)) FROM gm_planets WHERE gm_planets.galaxy = f.planet_galaxy AND gm_planets.sector = f.planet_sector AND gm_planets.ownerid IS NOT NULL AND EXISTS ( SELECT 1 FROM vw_gm_friend_radars WHERE vw_gm_friend_radars.friend = gm_planets.ownerid AND vw_gm_friend_radars.userid = " + str(self.userId) + ")) AS from_radarstrength, " + \
                "( SELECT int4(COALESCE(max(gm_planets.radar_strength), 0)) FROM gm_planets WHERE gm_planets.galaxy = f.destplanet_galaxy AND gm_planets.sector = f.destplanet_sector AND gm_planets.ownerid IS NOT NULL AND EXISTS ( SELECT 1 FROM vw_gm_friend_radars WHERE vw_gm_friend_radars.friend = gm_planets.ownerid AND vw_gm_friend_radars.userid = " + str(self.userId) + ")) AS to_radarstrength," + \
                " categoryid" + \
                " FROM vw_gm_fleets as f WHERE ownerid=" + str(self.userId)
        rows = dbRows(query)
        if rows:
            for row in rows:
                
                fleet = {}
                data["fleets"].append(fleet)
                
                fleet["id"] = row[0]
                fleet["name"] = row[1]
                fleet["category"] = row[37]
                fleet["size"] = row[4]
                fleet["signature"] = row[5]
                fleet["cargo_load"] = row[27] + row[28] + row[29] + row[30] + row[31]
                fleet["cargo_capacity"] = row[26]
                fleet["cargo_ore"] = row[27]
                fleet["cargo_hydro"] = row[28]
                fleet["cargo_scientists"] = row[29]
                fleet["cargo_soldiers"] = row[30]
                fleet["cargo_workers"] = row[31]
                fleet["commander_name"] = row[9]
                fleet["action"] = abs(row[34])
                fleet["stance"] = row[2]
                fleet["time"] = row[7]
    
                if row[3]: fleet["action"] = "x"
    
                if row[10]:
                    origin = {}
                    fleet["planet"] = origin
                    
                    origin["id"] = row[10]
                    origin["g"] = row[12]
                    origin["s"] = row[13]
                    origin["p"] = row[14]
                    origin["relation"] = row[17]
                    origin["name"] = self.getPlanetName(row[17], row[35], row[16], row[11])
    
                if row[18]:
                    destination = {}
                    fleet["destination"] = destination
                    
                    destination["id"] = row[18]
                    destination["g"] = row[20]
                    destination["s"] = row[21]
                    destination["p"] = row[22]
                    destination["relation"] = row[25]
                    destination["name"] = self.getPlanetName(row[25], row[36], row[24], row[19])
    
                fleet["ships"] = []
                
                query = "SELECT fleetid, gm_fleet_ships.shipid, quantity" + \
                        " FROM gm_fleets" + \
                        "   INNER JOIN gm_fleet_ships ON (gm_fleets.id=gm_fleet_ships.fleetid)" + \
                        " WHERE fleetid=" + str(row[0]) + " AND ownerid=" + str(self.userId) + \
                        " ORDER BY fleetid, gm_fleet_ships.shipid"
                rows2 = dbRows(query)
                if rows2:
                    for row2 in rows2:

                        ship = {}
                        fleet["ships"].append(ship)

                        ship["label"] = getShipLabel(row2[1])
                        ship["count"] = row2[2]
