# -*- coding: utf-8 -*-

from web_game.game._global import *



class View(GlobalView):
    
    def dispatch(self, request, *args, **kwargs):

        response = super().pre_dispatch(request, *args, **kwargs)
        if response: return response
            
        self.fleet_id = ToInt(request.GET.get("id"), 0)
        
        if self.fleet_id == 0: return HttpResponseRedirect("/game/orbit/")
        
        self.can_command_alliance_fleets = -1
        if self.AllianceId and self.hasRight("can_order_other_fleets"):
            self.can_command_alliance_fleets = self.AllianceId
        
        query = " SELECT ownerid" + \
                " FROM vw_fleets as f" + \
                " WHERE (ownerid=" + str(self.UserId) + " OR (shared AND owner_alliance_id=" + str(self.can_command_alliance_fleets) + ")) AND id=" + str(self.fleet_id) + " AND (SELECT privilege FROM users WHERE users.id = f.ownerid) = 0"
        oRs = oConnExecute(query)
        self.fleet_owner_id = oRs[0]
        
        query = " SELECT id" + \
                " FROM vw_fleets as f" + \
                " WHERE ownerid=" + str(self.fleet_owner_id) + " AND id=" + str(self.fleet_id)
        oRs = oConnExecute(query)
        
        if oRs == None: return HttpResponseRedirect("/game/fleets/")
        
        return super().dispatch(request, *args, **kwargs)
    
    
    
    def post(self, request, *args, **kwargs):
    
        action = request.POST.get("action", "")
        
        # --- invade a planet
        
        if action == "invade":
            
            take = request.POST.get("take", "")
            droppods = ToInt(request.POST.get("droppods"), 0)

            oRs = oConnExecute("SELECT sp_invade_planet(" + str(self.fleet_owner_id) + "," + str(self.fleet_id) + "," + str(droppods) + "," + str(ToBool(take, False)) + ")")
            res = oRs[0]
            
            if res >= 0: return HttpResponseRedirect("/game/invasion/?id=" + str(res) + "+fleetid=" + str(self.fleet_id))
            
            messages.error(request, 'error_invade_' + str(res))
        
        # --- rename fleet
        
        elif action == "rename":
            
            fleetname = request.POST.get("newname").strip()
            if isValidObjectName(fleetname):
                oConnDoQuery("UPDATE fleets SET name=" + dosql(fleetname) + " WHERE action=0 AND not engaged AND ownerid=" + str(self.UserId) + " AND id=" + str(self.fleet_id))
        
        # --- assign/unassign commander
        
        elif action == "assigncommander":
            
            commanderid = ToInt(request.POST.get("commander"), 0)
            if commanderid != 0:
                oConnExecute("SELECT sp_commanders_assign(" + str(self.fleet_owner_id) + "," + str(commanderid) + ",NULL," + str(self.fleet_id) + ")")
            else:
                oConnDoQuery("UPDATE fleets SET commanderid=null WHERE ownerid=" + str(self.fleet_owner_id) + " AND id=" + str(self.fleet_id))

            oConnExecute("SELECT sp_update_fleet_bonus(" + str(self.fleet_id) + ")")
        
        # --- start fleet moving
        
        elif action== "move":

            g = ToInt(request.POST.get("g"), -1)
            s = ToInt(request.POST.get("s"), -1)
            p = ToInt(request.POST.get("p"), -1)
            
            if g != -1 and s != -1 and p != -1:
    
                oRs = oConnExecute("SELECT sp_move_fleet(" + str(self.fleet_owner_id) + "," + str(self.fleet_id) + "," + str(g) + "," + str(s) + "," + str(p) + ")")
                res = oRs[0]
    
                if res == 0:
                    
                    if request.POST.get("movetype") == "1":
                        oConnDoQuery("UPDATE fleets SET next_waypointid = sp_create_route_unload_move(planetid) WHERE ownerid=" + str(self.fleet_owner_id) + " AND id=" + str(self.fleet_id))
                        
                    elif request.POST.get("movetype") == "2":
                        oConnDoQuery("UPDATE fleets SET next_waypointid = sp_create_route_recycle_move(planetid) WHERE ownerid=" + str(self.fleet_owner_id) + " AND id=" + str(self.fleet_id))
                
                else:
                    messages.error(request, 'error_invade_' + str(res))

            else:
                messages.error(request, 'error_move_-1')
        
        return HttpResponseRedirect("/game/fleet_view/?id=" + str(self.fleet_id))



    def get(self, request, *args, **kwargs):
        
        action = request.GET.get("action", "")
        
        # --- toggle fleet alliance sharing
        
        if action == "share":
            oConnDoQuery("UPDATE fleets SET shared=not shared WHERE ownerid=" + str(self.fleet_owner_id) + " AND id=" + str(self.fleet_id))
        
        # --- leave fleet
        
        elif action == "abandon":
            oConnExecute("SELECT sp_abandon_fleet(" + str(self.UserId) + "," + str(self.fleet_id) + ")")
        
        # --- set fleet stance to attack
        
        elif action == "attack":
            oConnDoQuery("UPDATE fleets SET attackonsight=firepower > 0 WHERE ownerid=" + str(self.fleet_owner_id) + " AND id=" + str(self.fleet_id))
        
        # --- set fleet stance to defense
        
        elif action == "defend":
            oConnDoQuery("UPDATE fleets SET attackonsight=False WHERE ownerid=" + str(self.fleet_owner_id) + " AND id=" + str(self.fleet_id))
        
        # --- start recycling

        elif action == "recycle":
            oRs = oConnExecute("SELECT sp_start_recycling(" + str(self.fleet_owner_id) + "," + str(self.fleet_id) + ")")
            if oRs[0] == -2:
                messages.error(request, 'error_recycle_-1')
        
        # --- stop recycling

        elif action == "stoprecycling":
            oConnExecute("SELECT sp_cancel_recycling(" + str(self.fleet_owner_id) + "," + str(self.fleet_id) + ")")
        
        # --- stop waiting

        elif action == "stopwaiting":
            oConnExecute("SELECT sp_cancel_waiting(" + str(self.fleet_owner_id) + "," + str(self.fleet_id) + ")")
        
        # --- merge 2 fleets

        elif action == "merge":
            destfleetid = ToInt(request.GET.get("with"), 0)
            oConnExecute("SELECT sp_merge_fleets(" + str(self.UserId) + "," + str(self.fleet_id) + ","+ str(destfleetid) +")")
        
        # --- stop fleet moving

        elif action == "return":
            oConnExecute("SELECT sp_cancel_move(" + str(self.fleet_owner_id) + "," + str(self.fleet_id) + ")")
        
        # --- deploy building on planet

        elif action == "install":
            shipid = ToInt(request.GET.get("s"), 0)
            oRs = oConnExecute("SELECT sp_start_ship_building_installation(" + str(self.fleet_owner_id) + "," + str(self.fleet_id) + "," + str(shipid) + ")")
            if oRs[0] >= 0:
                self.CurrentPlanet = oRs[0]
            else:
                messages.error(request, 'error_install_-1')
        
        # --- warp fleet to another galaxy

        elif action == "warp":
            oConnExecute("SELECT sp_warp_fleet(" + str(self.fleet_owner_id) + "," + str(self.fleet_id) + ")")
            
        ########################################################################
        
        self.selected_menu = "fleets"

        content = GetTemplate(request, "fleet_view")

        # --- fleet data
        
        fleet = {}
        content.AssignValue("fleet", fleet)
        
        query = " SELECT id, name, attackonsight, engaged, size, signature, speed, remaining_time, commanderid, commandername," + \
                " planetid, planet_name, planet_galaxy, planet_sector, planet_planet, planet_ownerid, planet_owner_name, planet_owner_relation," + \
                " destplanetid, destplanet_name, destplanet_galaxy, destplanet_sector, destplanet_planet, destplanet_ownerid, destplanet_owner_name, destplanet_owner_relation," + \
                " cargo_capacity, cargo_ore, cargo_hydrocarbon, cargo_scientists, cargo_soldiers, cargo_workers," + \
                " recycler_output, orbit_ore > 0 OR orbit_hydrocarbon > 0, action, total_time, idle_time, date_part('epoch', const_interval_before_invasion())," + \
                " long_distance_capacity, droppods, warp_to," + \
                " (SELECT int4(COALESCE(max(nav_planet.radar_strength), 0)) FROM nav_planet WHERE nav_planet.galaxy = f.planet_galaxy AND nav_planet.sector = f.planet_sector AND nav_planet.ownerid IS NOT NULL AND EXISTS ( SELECT 1 FROM vw_friends_radars WHERE vw_friends_radars.friend = nav_planet.ownerid AND vw_friends_radars.userid = " + str(self.UserId) + ")) AS from_radarstrength, " + \
                " (SELECT int4(COALESCE(max(nav_planet.radar_strength), 0)) FROM nav_planet WHERE nav_planet.galaxy = f.destplanet_galaxy AND nav_planet.sector = f.destplanet_sector AND nav_planet.ownerid IS NOT NULL AND EXISTS ( SELECT 1 FROM vw_friends_radars WHERE vw_friends_radars.friend = nav_planet.ownerid AND vw_friends_radars.userid = " + str(self.UserId) + ")) AS to_radarstrength," + \
                " firepower > 0, next_waypointid, (SELECT routeid FROM routes_waypoints WHERE id=f.next_waypointid), now(), spawn_ore + spawn_hydrocarbon," + \
                " radar_jamming, planet_floor, real_signature, required_vortex_strength, upkeep, CASE WHEN planet_owner_relation IN (-1,-2) THEN const_upkeep_ships_in_position() ELSE const_upkeep_ships() END AS upkeep_multiplicator," + \
                " ((sp_commander_fleet_bonus_efficiency(size::bigint - leadership, 2.0)-1.0)*100)::integer AS commander_efficiency, leadership, ownerid, shared," + \
                " (SELECT prestige_points >= sp_get_prestige_cost_for_new_planet(planets) FROM users WHERE id=ownerid) AS can_take_planet," + \
                " (SELECT sp_get_prestige_cost_for_new_planet(planets) FROM users WHERE id=ownerid) AS prestige_cost" + \
                " FROM vw_fleets as f" + \
                " WHERE ownerid=" + str(self.fleet_owner_id) + " AND id=" + str(self.fleet_id)
        oRs = oConnExecute(query)

        fleet["id"] = oRs[0]
        fleet["name"] = oRs[1]
        
        fleet["planet"] = {}
        fleet["planet"]["id"] = oRs[10]
        fleet["planet"]["g"] = oRs[12]
        fleet["planet"]["s"] = oRs[13]
        fleet["planet"]["p"] = oRs[14]
        fleet["planet"]["relation"] = oRs[17]
        fleet["planet"]["planetname"] = self.getPlanetName(oRs[17], oRs[41], oRs[16], oRs[11])
        
        can_deploy = False
        
        if oRs[34] == -1 or oRs[34] == 1:
            fleet["is_moving"] = True
            fleet["remaining_time"] = oRs[7]
             
            fleet["destination"] = {}
            fleet["destination"]["id"] = oRs[18]
            fleet["destination"]["g"] = oRs[20]
            fleet["destination"]["s"] = oRs[21]
            fleet["destination"]["p"] = oRs[22]
            fleet["destination"]["relation"] = oRs[25]
            fleet["destination"]["name"] = self.getPlanetName(oRs[25], oRs[42], oRs[24], oRs[19])

            timelimit = int(100 / oRs[6] * 3600)
            if timelimit < 120: timelimit = 120
            if not oRs[3] and oRs[35] - oRs[7] < timelimit and oRs[10]:
                fleet["returning_timelimit"] = timelimit - (oRs[35] - oRs[7])

        elif oRs[3]:
            fleet["is_fighting"] = True
            
        elif oRs[34] == 2:
            fleet["is_recycling"] = True
            fleet["remaining_time"] = oRs[7]
            
        elif oRs[34] == 4:
            fleet["is_waiting"] = True
            fleet["remaining_time"] = oRs[7]
            
        elif oRs[34] == 0:
            fleet["is_patrolling"] = True

            if oRs[40]: fleet["can_warp"] = True

            fleet["recycler_output"] = oRs[32]
            if oRs[32] > 0 and (oRs[33] > 0 or oRs[47] > 0):
                fleet["can_recycle"] = True

            can_deploy = ((oRs[15] == None) or (oRs[17] >= rHostile)) and (oRs[40] == None)

            if oRs[17] >= rFriend:
                fleet["can_unload"] = True

            if oRs[17] == rSelf and oRs[49] > 0:
                fleet["can_load"] = True
                fleet["can_manage"] = True

            if oRs[4] > 1 and self.fleet_owner_id == self.UserId:
                fleet["can_split"] = True

            fleet["droppods"] = oRs[39]
            if oRs[15] and oRs[17] < rFriend and oRs[30] > 0 and oRs[39] >= 0:
                fleet["can_invade"] = True
                
                if oRs[36] < oRs[37]: fleet["invade_time"] = int(oRs[37] - oRs[36])
                if oRs[58]: fleet["can_take"] = True
                
        if self.AllianceId and oRs[57]: fleet["is_shared"] = True

        if oRs[8]:

            fleet["commander"] = {}
            fleet["commander"]["id"] = oRs[8]
            fleet["commander"]["name"] = oRs[9]

        fleet["size"] = oRs[4]
        fleet["speed"] = oRs[6]
        fleet["stance"] = oRs[2]
        fleet["leadership"] = oRs[55]
        fleet["commander_efficiency"] = oRs[54]
        fleet["signature"] = oRs[5]
        fleet["real_signature"] = oRs[50]
        fleet["upkeep"] = oRs[52]
        fleet["upkeep_multiplicator"] = oRs[53]
        fleet["required_vortex_strength"] = oRs[51]
        fleet["long_distance_capacity"] = oRs[38]
        fleet["ore"] = oRs[27]
        fleet["hydrocarbon"] = oRs[28]
        fleet["scientists"] = oRs[29]
        fleet["soldiers"] = oRs[30]
        fleet["workers"] = oRs[31]
        fleet["load"] = oRs[27] + oRs[28] + oRs[29] + oRs[30] + oRs[31]
        fleet["capacity"] = oRs[26]

        if oRs[43]: fleet["is_military"] = True
        
        # --- fleet planet resources data
        
        query = " SELECT ore, hydrocarbon, scientists, soldiers," + \
                " GREATEST(0, workers - GREATEST(workers_busy, workers_for_maintenance - workers_for_maintenance / 2 + 1, 500))" + \
                " FROM vw_planets WHERE id=" + str(oRs[10])
        poRs = oConnExecute(query)
        
        fleet["planet"]["ore"] = poRs[0]
        fleet["planet"]["hydro"] = poRs[1]
        fleet["planet"]["scientists"] = poRs[2]
        fleet["planet"]["soldiers"] = poRs[3]
        fleet["planet"]["workers"] = poRs[4]

        # --- fleet actions data
        
        if oRs[45]:

            query = " SELECT routes_waypoints.id, ""action"", p.id, p.galaxy, p.sector, p.planet, p.name, sp_get_user(p.ownerid), sp_relation(p.ownerid," + str(self.UserId) + ")," + \
                    " routes_waypoints.ore, routes_waypoints.hydrocarbon" + \
                    " FROM routes_waypoints" + \
                    "   LEFT JOIN nav_planet AS p ON (routes_waypoints.planetid=p.id)" + \
                    " WHERE routeid=" + str(oRs[45]) + " AND routes_waypoints.id >= " + str(oRs[44]) + \
                    " ORDER BY routes_waypoints.id"
            rows = oConnExecuteAll(query)
            if rows:
                
                actions = []
                content.AssignValue("actions", actions)
                
                for RouteRs in rows:
                    
                    action = {}
                    actions.append(action)
                    
                    if RouteRs[2]:
                        
                        action["planet"] = {}
                        action["planet"]["id"] = RouteRs[2]
                        action["planet"]["g"] = RouteRs[3]
                        action["planet"]["s"] = RouteRs[4]
                        action["planet"]["p"] = RouteRs[5]
                        action["planet"]["relation"] = RouteRs[8]
    
                        if RouteRs[8] >= rAlliance: action["planet"]["name"] = RouteRs[6]
                        elif RouteRs[8] >= rUninhabited: action["planet"]["name"] = RouteRs[7]
                        else: action["planet"]["name"] = ""
    
                    if RouteRs[1] == 0:
                        if RouteRs[9] > 0: action["loadall"] = True
                        else: action["unloadall"] = True
                    
                    elif RouteRs[1] == 1: action["move"] = True
                    elif RouteRs[1] == 2: action["recycle"] = True
                    elif RouteRs[1] == 4: action["wait"] = True
                    elif RouteRs[1] == 5: action["invade"] = True
            
        # --- commanders data

        optgroup_none = { 'none':True, 'cmd_options':[] }
        optgroup_fleet = { 'fleet':True, 'cmd_options':[] }
        optgroup_planet = { 'planet':True, 'cmd_options':[] }
        
        query = " SELECT c.id, c.name, c.fleetname, c.planetname, fleets.id AS available" + \
                " FROM vw_commanders AS c" + \
                "   LEFT JOIN fleets ON (c.fleetid=fleets.id AND c.ownerid=fleets.ownerid AND NOT engaged AND action=0)" + \
                " WHERE c.ownerid=" + str(self.fleet_owner_id) + \
                " ORDER BY c.fleetid IS NOT NULL, c.planetid IS NOT NULL, c.fleetid, c.planetid "
        oCmdListRss = oConnExecuteAll(query)
        
        for oCmdListRs in oCmdListRss:
            
            cmd = {}
            
            cmd["id"] = oCmdListRs[0]
            cmd["name"] = oCmdListRs[1]
            
            if oRs[8] == oCmdListRs[0]: cmd["selected"] = True
            
            if oCmdListRs[2] == None:
                
                if oCmdListRs[3] == None:
                    item = "none"
                    optgroup_none['cmd_options'].append(cmd)
                    
                else:
                    cmd["option_name"] = oCmdListRs[3]
                    cmd["assigned"] = True
                    
                    optgroup_planet['cmd_options'].append(cmd)
                    
            else:
                cmd["option_name"] = oCmdListRs[2]

                if oCmdListRs[4]: cmd["assigned"] = True
                else: cmd["unavailable"] = True
                
                optgroup_fleet['cmd_options'].append(cmd)

        optgroups = []
        
        if len(optgroup_none['cmd_options']) > 0: optgroups.append(optgroup_none)
        if len(optgroup_fleet['cmd_options']) > 0: optgroups.append(optgroup_fleet)
        if len(optgroup_planet['cmd_options']) > 0: optgroups.append(optgroup_planet)
        
        content.AssignValue("optgroups", optgroups)
            
        # --- orbitting fleets data

        if oRs[34] != -1:
            
            fleets = []
            content.AssignValue("fleets", fleets)
            
            query = " SELECT vw_fleets.id, vw_fleets.name, size, signature, speed, cargo_capacity-cargo_free, cargo_capacity, action, ownerid, owner_name, alliances.tag, sp_relation(" + str(self.UserId) + ",ownerid), attackonsight" + \
                    " FROM vw_fleets" + \
                    "   LEFT JOIN alliances ON alliances.id=owner_alliance_id" + \
                    " WHERE planetid=" + str(oRs[10]) + " AND vw_fleets.id != " + str(oRs[0]) + " AND NOT engaged AND action != 1 AND action != -1" + \
                    " ORDER BY upper(vw_fleets.name)"
            oFleetsRss = oConnExecuteAll(query)

            for oFleetsRs in oFleetsRss:
                
                fleet = {}
                fleets.append(fleet)
            
                fleet["id"] = oFleetsRs[0]
                fleet["name"] = oFleetsRs[1]
                fleet["size"] = oFleetsRs[2]
                fleet["speed"] = oFleetsRs[4]
                fleet["stance"] = oFleetsRs[12]
                fleet["cargo_load"] = oFleetsRs[5]
                fleet["cargo_capacity"] = oFleetsRs[6]

                if oRs[17] > rFriend or oFleetsRs[11] > rFriend or oRs[48] == 0 or oRs[41] > oRs[48]: fleet["signature"] = oFleetsRs[3]
                else: fleet["signature"] = 0

                if oFleetsRs[8] == self.UserId:
                    if oRs[34] == 0 and oFleetsRs[7] == 0: fleet["merge"] = True

                    fleet["playerfleet"] = True
                    
                else:
                    fleet["owner"] = oFleetsRs[9]
                    fleet["tag"] = oFleetsRs[10]

                    if oFleetsRs[11] == 1: fleet["ally"] = True
                    elif oFleetsRs[11] == 0: fleet["friend"] = True
                    elif oFleetsRs[11] == -1:  fleet["enemy"] = True
            
        # --- moving planets data

        if oRs[34] == 0:
            
            hasAPlanetSelected = False;
            
            group = []
            content.AssignValue("planetgroup", group)
            
            query = "SELECT id, name, galaxy, sector, planet FROM nav_planet WHERE planet_floor > 0 AND planet_space > 0 AND ownerid=" + str(self.UserId) + " ORDER BY id"
            oRss = oConnExecuteAll(query)
            
            for i in oRss:
                
                planet = {}
                group.append(planet)
                
                planet["name"] = i[1]
                planet["g"] = i[2]
                planet["s"] = i[3]
                planet["p"] = i[4]

                if i[0] == oRs[10]:
                    planet["selected"] = True
                    hasAPlanetSelected = True

            group = []
            content.AssignValue("fleetgroup", group)
            
            query = " SELECT DISTINCT ON (f.planetid) f.name, f.planetid, f.planet_galaxy, f.planet_sector, f.planet_planet" + \
                    " FROM vw_fleets AS f" + \
                    "   LEFT JOIN nav_planet AS p ON (f.planetid=p.id)" + \
                    " WHERE f.ownerid=" + str(self.UserId) + " AND p.ownerid IS DISTINCT FROM " + str(self.UserId) + \
                    " ORDER BY f.planetid" + \
                    " LIMIT 200"
            oRss = oConnExecuteAll(query)

            for list_oRs in oRss:
                
                fleet = {}
                group.append(fleet)
                
                fleet["name"] = list_oRs[0]
                fleet["g"] = list_oRs[2]
                fleet["s"] = list_oRs[3]
                fleet["p"] = list_oRs[4]

                if list_oRs[1] == oRs[10] and not hasAPlanetSelected:
                    fleet["selected"] = True

            group = []
            content.AssignValue("merchantplanetsgroup", group)
            
            query = " SELECT id, galaxy, sector, planet" + \
                    " FROM nav_planet" + \
                    " WHERE ownerid=3"
            if oRs[12]: query = query + " AND galaxy=" + str(oRs[12])
            query = query + " ORDER BY id"
            list_oRss = oConnExecuteAll(query)

            for list_oRs in list_oRss:
                
                merchant = {}
                group.append(merchant)
                
                merchant["g"] = list_oRs[1]
                merchant["s"] = list_oRs[2]
                merchant["p"] = list_oRs[3]

                if list_oRs[0] == oRs[10] and not hasAPlanetSelected:
                    merchant["selected"] = True
            
        # --- fleet ships data

        if oRs[15]: planet_ownerid = oRs[15]
        else: planet_ownerid = self.UserId

        if oRs[34] == 0 and oRs[17] == rSelf:
            self.CurrentPlanet = oRs[10]
            self.showHeader = True
        
        ships = []
        content.AssignValue("ships", ships)
        
        query = " SELECT db_ships.id, fleets_ships.quantity," + \
                " signature, capacity, handling, speed, weapon_turrets, weapon_dmg_em+weapon_dmg_explosive+weapon_dmg_kinetic+weapon_dmg_thermal AS weapon_power, weapon_tracking_speed, hull, shield, recycler_output, long_distance_capacity, droppods," + \
                " buildingid, sp_can_build_on(" + str(oRs[10]) + ", db_ships.buildingid," + str(planet_ownerid) + ")=0 AS can_build, db_ships.label, db_ships.description" + \
                " FROM fleets_ships" + \
                "    LEFT JOIN db_ships ON (fleets_ships.shipid = db_ships.id)" + \
                " WHERE fleetid=" + str(self.fleet_id) + \
                " ORDER BY db_ships.category, db_ships.label"
        oRss = oConnRows(query)

        for oRs in oRss:
            
            ship = {}
            ships.append(ship)

            ship["id"] = oRs["id"]
            ship["quantity"] = oRs["quantity"]
            ship["name"] = oRs["label"]
            ship["description"] = oRs["description"]
            ship["signature"] = oRs["signature"]
            ship["cargo"] = oRs["capacity"]
            ship["handling"] = oRs["handling"]
            ship["speed"] = oRs["speed"]
            ship["turrets"] = oRs["weapon_turrets"]
            ship["power"] = oRs["weapon_power"]
            ship["tracking_speed"] = oRs["weapon_tracking_speed"]
            ship["hull"] = oRs["hull"]
            ship["shield"] = oRs["shield"]
            ship["recycler_output"] = oRs["recycler_output"]
            ship["long_distance_capacity"] = oRs["long_distance_capacity"]
            ship["_droppods"] = oRs["droppods"]

            if oRs["buildingid"] and can_deploy and oRs["can_build"]:
                ship["can_install"] = True

        return self.Display(content)
