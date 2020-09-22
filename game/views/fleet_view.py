# -*- coding: utf-8 -*-

from game.views._base import *

#-------------------------------------------------------------------------------
class View(BaseView):
    
    success_url = "/game/fleet-view/"
    template_name = "fleet-view"
    selected_menu = "fleets"

    #---------------------------------------------------------------------------
    def dispatch(self, request, *args, **kwargs):

        response = super().pre_dispatch(request, *args, **kwargs)
        if response: return response
        
        alliance_id = -1
        if self.allianceId and self.hasRight("can_order_other_fleets"):
            alliance_id = self.allianceId
        
        id = ToInt(request.GET.get("id"), 0)
        query = "SELECT id, ownerid" + \
                " FROM vw_gm_fleets as f" + \
                " WHERE (ownerid=" + str(self.userId) + " OR (shared AND owner_alliance_id=" + str(alliance_id) + ")) AND id=" + str(id) + " AND (SELECT privilege FROM gm_profiles WHERE gm_profiles.id = f.ownerid) = 0"
        row = dbRow(query)
        if row == None: return HttpResponseRedirect("/game/fleets/")
        
        self.fleet_id = row[0]
        self.fleet_owner_id = row[1]
        
        return super().dispatch(request, *args, **kwargs)

    #---------------------------------------------------------------------------
    def processAction(self, request, action):

        if action == "invade":
        
            take = request.POST.get("take", "")
            droppods = ToInt(request.POST.get("droppods"), 0)
            
            row = dbRow("SELECT user_fleet_invade(" + str(self.fleet_owner_id) + "," + str(self.fleet_id) + "," + str(droppods) + "," + str(ToBool(take, False)) + ")")
            if row[0] > 0:
                self.success_url = "/game/invasion/?id=" + str(row[0]) + "+fleetid=" + str(self.fleet_id)
                return 0
            
            return row[0]
            
        elif action == "rename" and self.fleet_owner_id == self.userId:
        
            name = request.POST.get("name").strip()
            if not isValidObjectName(name): return -1
            
            dbExecute("UPDATE gm_fleets SET name=" + sqlStr(name) + " WHERE action=0 AND not engaged AND ownerid=" + str(self.userId) + " AND id=" + str(self.fleet_id))
            return 0

        elif action == "assigncommander":
        
            commander = ToInt(request.POST.get("commander"), 0)
        
            if commander != 0: dbRow("SELECT user_commander_assign(" + str(self.fleet_owner_id) + "," + str(commander) + ",NULL," + str(self.fleet_id) + ")")
            else: dbExecute("UPDATE gm_fleets SET commanderid=null WHERE ownerid=" + str(self.fleet_owner_id) + " AND id=" + str(self.fleet_id))

            dbRow("SELECT internal_fleet_update_bonuses(" + str(self.fleet_id) + ")")
            return 0
            
        elif action == "move":
        
            g = ToInt(request.POST.get("g"), -1)
            s = ToInt(request.POST.get("s"), -1)
            p = ToInt(request.POST.get("p"), -1)
            if g == -1 or s == -1 or p == -1: return -1
                        
            row = dbRow("SELECT user_fleet_move(" + str(self.fleet_owner_id) + "," + str(self.fleet_id) + "," + str(g) + "," + str(s) + "," + str(p) + ")")
            if row[0] == 0:
            
                type = ToInt(request.POST.get("movetype"), 0)
                if type == 1:
                    dbExecute("UPDATE gm_fleets SET next_waypointid = internal_profile_create_fleet_route_unload_move(planetid) WHERE ownerid=" + str(self.fleet_owner_id) + " AND id=" + str(self.fleet_id))
                elif type == 2:
                    dbExecute("UPDATE gm_fleets SET next_waypointid = internal_profile_create_fleet_route_recycle_move(planetid) WHERE ownerid=" + str(self.fleet_owner_id) + " AND id=" + str(self.fleet_id))
            
            return row[0]
            
        elif action == "share":
        
            dbExecute("UPDATE gm_fleets SET shared=not shared WHERE ownerid=" + str(self.fleet_owner_id) + " AND id=" + str(self.fleet_id))
            return 0
        
        elif action == "abandon":
        
            dbRow("SELECT sp_abandon_fleet(" + str(self.userId) + "," + str(self.fleet_id) + ")")
            return 0
        
        elif action == "attack":
        
            dbExecute("UPDATE gm_fleets SET attackonsight=firepower > 0 WHERE ownerid=" + str(self.fleet_owner_id) + " AND id=" + str(self.fleet_id))
            return 0
        
        elif action == "defend":
        
            dbExecute("UPDATE gm_fleets SET attackonsight=False WHERE ownerid=" + str(self.fleet_owner_id) + " AND id=" + str(self.fleet_id))
            return 0
        
        elif action == "recycle":
        
            row = dbRow("SELECT user_fleet_start_recycling(" + str(self.fleet_owner_id) + "," + str(self.fleet_id) + ")")
            return row[0]
            
        elif action == "stoprecycling":
        
            dbRow("SELECT user_fleet_cancel_recycling(" + str(self.fleet_owner_id) + "," + str(self.fleet_id) + ")")
            return 0
        
        elif action == "stopwaiting":
        
            dbRow("SELECT user_fleet_cancel_waiting(" + str(self.fleet_owner_id) + "," + str(self.fleet_id) + ")")
            return 0
        
        elif action == "merge":
        
            destfleetid = ToInt(request.POST.get("with"), 0)
            
            dbRow("SELECT user_fleet_merge(" + str(self.userId) + "," + str(self.fleet_id) + ","+ str(destfleetid) +")")
            return 0

        elif action == "return":
        
            dbRow("SELECT user_fleet_cancel_moving(" + str(self.fleet_owner_id) + "," + str(self.fleet_id) + ")")
            return 0
            
        elif action == "install":
        
            shipid = ToInt(request.POST.get("s"), 0)
            
            row = dbRow("SELECT user_fleet_deploy(" + str(self.fleet_owner_id) + "," + str(self.fleet_id) + "," + str(shipid) + ")")
            return row[0]
        
        elif action == "warp":
        
            dbRow("SELECT user_fleet_warp(" + str(self.fleet_owner_id) + "," + str(self.fleet_id) + ")")
            return 0
            
    #---------------------------------------------------------------------------
    def fillContent(self, request, data):
        
        # --- fleet data
        
        query = "SELECT id, name, attackonsight, engaged, size, signature, speed, remaining_time, commanderid, commandername," + \
                " planetid, planet_name, planet_galaxy, planet_sector, planet_planet, planet_ownerid, planet_owner_name, planet_owner_relation," + \
                " destplanetid, destplanet_name, destplanet_galaxy, destplanet_sector, destplanet_planet, destplanet_ownerid, destplanet_owner_name, destplanet_owner_relation," + \
                " cargo_capacity, cargo_ore, cargo_hydro, cargo_scientists, cargo_soldiers, cargo_workers," + \
                " recycler_output, orbit_ore > 0 OR orbit_hydro > 0, action, total_time, idle_time, date_part('epoch', static_planet_invasion_delay())," + \
                " long_distance_capacity, droppods, warp_to," + \
                "( SELECT int4(COALESCE(max(gm_planets.radar_strength), 0)) FROM gm_planets WHERE gm_planets.galaxy = f.planet_galaxy AND gm_planets.sector = f.planet_sector AND gm_planets.ownerid IS NOT NULL AND EXISTS ( SELECT 1 FROM vw_gm_friend_radars WHERE vw_gm_friend_radars.friend = gm_planets.ownerid AND vw_gm_friend_radars.userid = " + str(self.userId) + ")) AS from_radarstrength, " + \
                "( SELECT int4(COALESCE(max(gm_planets.radar_strength), 0)) FROM gm_planets WHERE gm_planets.galaxy = f.destplanet_galaxy AND gm_planets.sector = f.destplanet_sector AND gm_planets.ownerid IS NOT NULL AND EXISTS ( SELECT 1 FROM vw_gm_friend_radars WHERE vw_gm_friend_radars.friend = gm_planets.ownerid AND vw_gm_friend_radars.userid = " + str(self.userId) + ")) AS to_radarstrength," + \
                "firepower > 0, next_waypointid, (SELECT routeid FROM gm_fleet_route_waypoints WHERE id=f.next_waypointid), now(), spawn_ore + spawn_hydro," + \
                "radar_jamming, planet_floor, real_signature, required_vortex_strength, upkeep, CASE WHEN planet_owner_relation IN (-1,-2) THEN static_orbitting_fleet_ship_upkeep() ELSE static_fleet_ship_upkeep() END AS upkeep_multiplicator," + \
                " ((internal_commander_get_fleet_bonus_efficiency(size::bigint - leadership, 2.0)-1.0)*100)::integer AS commander_efficiency, leadership, ownerid, shared," + \
                " (SELECT prestige_points >= tool_compute_prestige_cost_for_new_planet(planets) FROM gm_profiles WHERE id=ownerid) AS can_take_planet," + \
                " (SELECT tool_compute_prestige_cost_for_new_planet(planets) FROM gm_profiles WHERE id=ownerid) AS prestige_cost" + \
                " FROM vw_gm_fleets as f" + \
                " WHERE ownerid=" + str(self.fleet_owner_id) + " AND id=" + str(self.fleet_id)
        row = dbRow(query)

        if self.allianceId and row[57]: data["shared"] = True
            
        data["now"] = row[46]

        if row[8]:
            data["commander"] = {}
            data["commander"]["id"] = row[8]
            data["commander"]["name"] = row[9]
            
        data["leadership"] = row[55]
        data["commander_efficiency"] = row[54]
        data["signature"] = row[5]
        data["real_signature"] = row[50]
        data["upkeep"] = row[52]
        data["upkeep_multiplicator"] = row[53]
        data["long_distance_capacity"] = row[38]
        data["required_vortex_strength"] = row[51]
        data["droppods"] = row[39]

        if row[38] < row[50]: data["insufficient_long_distance_capacity"] = True
        
        data["ore"] = row[27]
        data["hydro"] = row[28]
        data["scientists"] = row[29]
        data["soldiers"] = row[30]
        data["workers"] = row[31]
        data["load"] = row[27] + row[28] + row[29] + row[30] + row[31]
        data["capacity"] = row[26]
        data["id"] = row[0]
        data["name"] = row[1]
        data["stance"] = row[2]
        data["size"] = row[4]
        data["speed"] = row[6]
        data["recycler_output"] = row[32]
        data["time"] = row[7]
        
        data["planet"] = {}
        data["planet"]["id"] = row[10]
        data["planet"]["g"] = row[12]
        data["planet"]["s"] = row[13]
        data["planet"]["p"] = row[14]
        data["planet"]["relation"] = row[17]
        data["planet"]["name"] = self.getPlanetName(row[17], row[41], row[16], row[11])
        
        if row[34] == -1 or row[34] == 1:
            data["moving"] = True
            
            data["destination"] = {}
            data["destination"]["id"] = row[18]
            data["destination"]["g"] = row[20]
            data["destination"]["s"] = row[21]
            data["destination"]["p"] = row[22]
            data["destination"]["relation"] = row[25]
            data["destination"]["name"] = self.getPlanetName(row[25], row[42], row[24], row[19])

            timelimit = int(100 / row[6] * 3600)
            if timelimit < 120: timelimit = 120
            if not row[3] and row[35] - row[7] < timelimit and row[10]:
                data["timelimit"] = timelimit - (row[35] - row[7])

        else:
            if row[3]: data["fighting"] = True
            elif row[34] == 2: data["recycling"] = True
            elif row[34] == 4: data["waiting"] = True
            else:

                if row[40]: data["warp"] = True

                if row[32] == 0 or (not row[33] and row[47] == 0):
                    data["cant_recycle"] = True

                can_install_building = (row[15] == None or row[17] >= rHostile) and (row[40] == None)

                if row[17] >= rFriend: data["unloadcargo"] = True
                if row[17] == rSelf and row[49] > 0:
                    data["loadcargo"] = True
                    data["manage"] = True

                if row[34] == 0 and row[4] > 1 and self.fleet_owner_id == self.userId:
                    data["split"] = True

                if row[15] and row[17] < rFriend and row[30] > 0:
                    if row[36] < row[37]: t = row[37] - row[36]
                    else: t = 0 
                    data["invade_time"] = int(t)

                    if row[39] == 0: data["cant_invade"] = True
                    else:
                        if row[58]:
                            data["prestige"] = row[59]
                            data["can_take"] = True

                        data["invade"] = True
                    
                else: data["cant_invade"] = True

                if row[34] == 0:
                    data["patrolling"] = True
                    data["idle"] = True

        # --- moving planets data
        
        if row[34] == 0:
            
            data["planets"] = []
            
            query = "SELECT id, name, galaxy, sector, planet FROM gm_planets WHERE planet_floor > 0 AND planet_space > 0 AND ownerid=" + str(self.userId) + " ORDER BY id"
            rows = dbRows(query)
            if rows:
                for row in rows:
                
                    planet = {}
                    data["planets"].append(planet)
                    
                    planet["name"] = i[1]
                    planet["g"] = i[2]
                    planet["s"] = i[3]
                    planet["p"] = i[4]

            data["fleetplanets"] = []
            
            query = " SELECT DISTINCT ON (f.planetid) f.name, f.planetid, f.planet_galaxy, f.planet_sector, f.planet_planet" + \
                    " FROM vw_gm_fleets AS f" + \
                    "   LEFT JOIN gm_planets AS p ON (f.planetid=p.id)" + \
                    " WHERE f.ownerid=" + str(self.userId) + " AND p.ownerid IS DISTINCT FROM " + str(self.userId) + \
                    " ORDER BY f.planetid" + \
                    " LIMIT 200"
            rows = dbRows(query)
            if rows:
                for row in rows:
                
                    fleet = {}
                    data["fleetplanets"].append(fleet)

                    fleet["name"] = row[0]
                    fleet["g"] = row[2]
                    fleet["s"] = row[3]
                    fleet["p"] = row[4]

            data["merchantplanets"] = []
            
            query = " SELECT id, galaxy, sector, planet" + \
                    " FROM gm_planets" + \
                    " WHERE ownerid=3"
            if row[12]: query = query + " AND galaxy=" + str(row[12])
            query = query + " ORDER BY id"
            rows = dbRows(query)
            if rows:
                for row in rows:
                
                    merchant = {}
                    data["merchantplanets"].append(merchant)
                    
                    merchant["g"] = row[1]
                    merchant["s"] = row[2]
                    merchant["p"] = row[3]
                    
        # --- routes data
        
        if row[45]:
            
            data["actions"] = []
            
            query = "SELECT gm_fleet_route_waypoints.id, ""action"", p.id, p.galaxy, p.sector, p.planet, p.name, internal_profile_get_name(p.ownerid), internal_profile_get_relation(p.ownerid,"+str(self.userId)+")," + \
                    " gm_fleet_route_waypoints.ore, gm_fleet_route_waypoints.hydro" + \
                    " FROM gm_fleet_route_waypoints" + \
                    "   LEFT JOIN gm_planets AS p ON (gm_fleet_route_waypoints.planetid=p.id)" + \
                    " WHERE routeid=" + str(row[45]) + " AND gm_fleet_route_waypoints.id >= " + str(row[44]) + \
                    " ORDER BY gm_fleet_route_waypoints.id"
            rows = dbRows(query)
            for row in rows:
            
                action = {}
                data["actions"].append(action)
                
                action["type"] = row[1]
                
                if row[2]:
                
                    action["planet"] = {}
                    
                    action["planet"]["id"] = row[2]
                    action["planet"]["g"] = row[3]
                    action["planet"]["s"] = row[4]
                    action["planet"]["p"] = row[5]
                    action["planet"]["relation"] = row[8]

                    if row[8] >= rAlliance: action["planet"]["name"] = row[6]
                    elif row[8] >= rUninhabited: action["planet"]["name"] = row[7]
                    else: action["planet"]["name"] = ""

        # --- commanders data
        
        data["cmd_none"] = []
        data["cmd_fleet"] = []
        data["cmd_planet"] = []
        
        query = " SELECT c.id, c.name, c.fleetname, c.planetname, gm_fleets.id AS available" + \
                " FROM vw_gm_profile_commanders AS c" + \
                "   LEFT JOIN gm_fleets ON (c.fleetid=gm_fleets.id AND c.ownerid=gm_fleets.ownerid AND NOT engaged AND action=0)" + \
                " WHERE c.ownerid=" + str(self.fleet_owner_id) + \
                " ORDER BY c.fleetid IS NOT NULL, c.planetid IS NOT NULL, c.fleetid, c.planetid "
        rows = dbRows(query)        
        for row in rows:
        
            cmd = { "id":row[0], "name":row[1] }
            
            if row[2] == None:
                if row[3] == None:
                    data["cmd_none"].append(cmd)

                else:
                    cmd["planetname"] = row[3]
                    data["cmd_planet"].append(cmd)
                    
            else:
                cmd["fleetname"] = row[2]
                if row[4]: cmd["fleetavailable"] = True
                data["cmd_fleet"].append(cmd)
        
        # --- orbitting fleets data
        
        if row[34] != -1:
        
            data["fleets"] = []
            
            query = "SELECT vw_gm_fleets.id, vw_gm_fleets.name, size, signature, speed, cargo_capacity-cargo_free, cargo_capacity, action, ownerid, owner_name, gm_alliances.tag, internal_profile_get_relation(" + str(self.userId) + ",ownerid)" + \
                    " FROM vw_gm_fleets" + \
                    "   LEFT JOIN gm_alliances ON gm_alliances.id=owner_alliance_id" + \
                    " WHERE planetid=" + str(row[10]) + " AND vw_gm_fleets.id != " + str(row[0]) + " AND NOT engaged AND action != 1 AND action != -1" + \
                    " ORDER BY upper(vw_gm_fleets.name)"
            rows2 = dbRows(query)
            for row2 in rows2:
            
                fleet = {}
            
                fleet["id"] = row2[0]
                fleet["name"] = row2[1]
                fleet["size"] = row2[2]
                fleet["speed"] = row2[4]
                fleet["load"] = row2[5]
                fleet["cargo"] = row2[6]

                if row[17] > rFriend or row2[11] > rFriend or row[48] == 0 or row[41] > row[48]: fleet["signature"] = row2[3]
                else: fleet["signature"] = 0

                if row2[8] == self.userId:
                    if row[34] == 0 and row2[7] == 0: fleet["merge"] = True
                    fleet["playerfleet"] = True
                    data["fleets"].append(fleet)
                    
                else:
                    displayFleet = False

                    fleet["owner"] = row2[9]
                    fleet["tag"] = row2[10]

                    if row2[11] == 1:
                        displayFleet = True
                        fleet["ally"] = True
                        
                    elif row2[11] == 0:
                        displayFleet = True
                        fleet["friend"] = True
                        
                    elif row2[11] == -1:
                        displayFleet = row[34] != 1
                        if displayFleet: fleet["enemy"] = True

                    if displayFleet:
                        data["fleets"].append(fleet)
        
        # --- fleet ships data
        
        data["ships"] = []
        
        if row[15]: planet_ownerid = row[15]
        else: planet_ownerid = self.userId
        
        query = "SELECT dt_ships.id, gm_fleet_ships.quantity," + \
                " signature, capacity, handling, speed, weapon_turrets, weapon_dmg_em+weapon_dmg_explosive+weapon_dmg_kinetic+weapon_dmg_thermal AS weapon_power, weapon_tracking_speed, hull, shield, recycler_output, long_distance_capacity, droppods," + \
                " buildingid, internal_planet_can_build_on(" + str(row[10]) + ", dt_ships.buildingid," + str(planet_ownerid) + ")=0 AS can_build" + \
                " FROM gm_fleet_ships" + \
                "    LEFT JOIN dt_ships ON (gm_fleet_ships.shipid = dt_ships.id)" + \
                " WHERE fleetid=" + str(fleetid) + \
                " ORDER BY dt_ships.category, dt_ships.label"
        rows2 = dbDictRows(query)
        for row2 in rows2:
        
            ship = {}
            data["ships"].append(ship)

            ship["id"] = row2["id"]
            ship["quantity"] = row2["quantity"]
            ship["name"] = getShipLabel(row2["id"])
            ship["description"] = getShipDescription(row2["id"])
            ship["ship_signature"] = row2["signature"]
            ship["ship_cargo"] = row2["capacity"]
            ship["ship_handling"] = row2["handling"]
            ship["ship_speed"] = row2["speed"]
            ship["ship_turrets"] = row2["weapon_turrets"]
            ship["ship_power"] = row2["weapon_power"]
            ship["ship_tracking_speed"] = row2["weapon_tracking_speed"]
            ship["ship_hull"] = row2["hull"]
            ship["ship_shield"] = row2["shield"]
            ship["ship_recycler_output"] = row2["recycler_output"]
            ship["ship_long_distance_capacity"] = row2["long_distance_capacity"]
            ship["ship_droppods"] = row2["droppods"]

            if row2["buildingid"] and self.can_install_building and row2["can_build"]: ship["install"] = True
            
        # -- header displaying
        
        if row[34] == 0 and row[17] == rSelf:
            self.currentPlanetId = row[10]
            self.showHeader = True
