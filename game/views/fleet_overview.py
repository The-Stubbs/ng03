# -*- coding: utf-8 -*-

from game.views._base import *

#-------------------------------------------------------------------------------
class View(BaseView):
    
    def dispatch(self, request, *args, **kwargs):

        response = super().pre_dispatch(request, *args, **kwargs)
        if response: return response
        
        self.selected_menu = "gm_fleets.gm_fleets"

        self.action_result = ""
        self.move_fleet_result = ""
        self.can_command_alliance_fleets = -1
        self.can_install_building = False

        if self.allianceId and self.hasRight("can_order_other_fleets"):
            self.can_command_alliance_fleets = self.allianceId

        self.fleet_owner_id = self.userId

        fleetid = ToInt(self.request.GET.get("id"), 0)

        if ToInt(self.request.GET.get("trade",""), 0) == 9:
            self.action_result = "error_trade"

        if fleetid == 0:
            return HttpResponseRedirect("/game/orbit/")

        self.RetrieveFleetOwnerId(fleetid)

        self.ExecuteOrder(fleetid)

        return self.DisplayFleet(fleetid)

    def RetrieveFleetOwnerId(self, fleetid):

        # retrieve fleet owner
        query = "SELECT ownerid" + \
                " FROM vw_gm_fleets as f" + \
                " WHERE (ownerid=" + str(self.userId) + " OR (shared AND owner_alliance_id=" + str(self.can_command_alliance_fleets) + ")) AND id=" + str(fleetid) + " AND (SELECT privilege FROM gm_profiles WHERE gm_profiles.id = f.ownerid) = 0"
        row = dbRow(query)

        if row:
            self.fleet_owner_id = row[0]

    # display fleet info
    def DisplayFleet(self, fleetid):

        content = self.loadTemplate("fleet")

        # retrieve fleet name, size, position, destination
        query = "SELECT id, name, attackonsight, engaged, size, signature, speed, remaining_time, commanderid, commandername," + \
                " planetid, planet_name, planet_galaxy, planet_sector, planet_planet, planet_ownerid, planet_owner_name, planet_owner_relation," + \
                " destplanetid, destplanet_name, destplanet_galaxy, destplanet_sector, destplanet_planet, destplanet_ownerid, destplanet_owner_name, destplanet_owner_relation," + \
                " cargo_capacity, cargo_ore, cargo_hydro, cargo_scientists, cargo_soldiers, cargo_workers," + \
                " recycler_output, orbit_ore > 0 OR orbit_hydro > 0, action, total_time, idle_time, date_part('epoch', static_planet_invasion_delay())," + \
                " long_distance_capacity, droppods, warp_to," + \
                "( SELECT int4(COALESCE(max(gm_planets.radar_strength), 0)) FROM gm_planets WHERE gm_planets.galaxy = f.planet_galaxy AND gm_planets.sector = f.planet_sector AND gm_planets.ownerid IS NOT NULL AND EXISTS ( SELECT 1 FROM vw_gm_friend_radars WHERE vw_gm_friend_radars.friend = gm_planets.ownerid AND vw_gm_friend_radars.userid = "+str(self.userId)+")) AS from_radarstrength, " + \
                "( SELECT int4(COALESCE(max(gm_planets.radar_strength), 0)) FROM gm_planets WHERE gm_planets.galaxy = f.destplanet_galaxy AND gm_planets.sector = f.destplanet_sector AND gm_planets.ownerid IS NOT NULL AND EXISTS ( SELECT 1 FROM vw_gm_friend_radars WHERE vw_gm_friend_radars.friend = gm_planets.ownerid AND vw_gm_friend_radars.userid = "+str(self.userId)+")) AS to_radarstrength," + \
                "firepower > 0, next_waypointid, (SELECT routeid FROM gm_fleet_route_waypoints WHERE id=f.next_waypointid), now(), spawn_ore + spawn_hydro," + \
                "radar_jamming, planet_floor, real_signature, required_vortex_strength, upkeep, CASE WHEN planet_owner_relation IN (-1,-2) THEN static_orbitting_fleet_ship_upkeep() ELSE static_fleet_ship_upkeep() END AS upkeep_multiplicator," + \
                " ((internal_commander_get_fleet_bonus_efficiency(size::bigint - leadership, 2.0)-1.0)*100)::integer AS commander_efficiency, leadership, ownerid, shared," + \
                " (SELECT prestige_points >= tool_compute_prestige_cost_for_new_planet(planets) FROM gm_profiles WHERE id=ownerid) AS can_take_planet," + \
                " (SELECT tool_compute_prestige_cost_for_new_planet(planets) FROM gm_profiles WHERE id=ownerid) AS prestige_cost" + \
                " FROM vw_gm_fleets as f" + \
                " WHERE ownerid=" + str(self.fleet_owner_id) + " AND id=" + str(fleetid)
        row = dbRow(query)

        # if fleet doesnt exist, redirect to the last known planet orbit or display the gm_fleets list
        if row == None:
            return HttpResponseRedirect("/game/gm_fleets/")

        if self.allianceId:
            if row[57]:
                content.Parse("shared")
            else:
                content.Parse("not_shared")
            
        content.AssignValue("now", row[46])

        if row[45]:

            query = "SELECT gm_fleet_route_waypoints.id, ""action"", p.id, p.galaxy, p.sector, p.planet, p.name, internal_profile_get_name(p.ownerid), internal_profile_get_relation(p.ownerid,"+str(self.userId)+")," + \
                    " gm_fleet_route_waypoints.ore, gm_fleet_route_waypoints.hydro" + \
                    " FROM gm_fleet_route_waypoints" + \
                    "    LEFT JOIN gm_planets AS p ON (gm_fleet_route_waypoints.planetid=p.id)" + \
                    " WHERE routeid=" + str(row[45]) + " AND gm_fleet_route_waypoints.id >= " + str(row[44]) + \
                    " ORDER BY gm_fleet_route_waypoints.id"
            RouteRss = dbRows(query)
            
            actions = []
            
            waypointscount = 0
            for RouteRs in RouteRss:
                action = {}
                if RouteRs[2]:
                    action["planetid"] = RouteRs[2]
                    action["g"] = RouteRs[3]
                    action["s"] = RouteRs[4]
                    action["p"] = RouteRs[5]
                    action["relation"] = RouteRs[8]

                    if RouteRs[8] >= rAlliance:
                        action["planetname"] = RouteRs[6]
                    elif RouteRs[8] >= rUninhabited:
                        action["planetname"] = RouteRs[7]
                    else:
                        action["planetname"] = ""

                if RouteRs[1] == 0:
                    if RouteRs[9] > 0:
                        action["loadall"] = True
                    else:
                        action["unloadall"] = True
                        
                elif RouteRs[1] == 1:
                    action["move"] = True
                elif RouteRs[1] == 2:
                    action["recycle"] = True
                elif RouteRs[1] == 4:
                    action["wait"] = True
                elif RouteRs[1] == 5:
                    action["invade"] = True

                actions.append(action)

                waypointscount = waypointscount + 1

            if waypointscount > 0: content.AssignValue("actions", actions)

        #
        # list commmanders
        #
        query = " SELECT c.id, c.name, c.fleetname, c.planetname, gm_fleets.id AS available" + \
                " FROM vw_gm_profile_commanders AS c" + \
                "    LEFT JOIN gm_fleets ON (c.fleetid=gm_fleets.id AND c.ownerid=gm_fleets.ownerid AND NOT engaged AND action=0)" + \
                " WHERE c.ownerid=" + str(self.fleet_owner_id) + \
                " ORDER BY c.fleetid IS NOT NULL, c.planetid IS NOT NULL, c.fleetid, c.planetid "
        oCmdListRss = dbRows(query)

        lastItem = ""
        item = ""
        ShowGroup = True

        optgroup_none = {'none':True, 'cmd_options':[]}
        optgroup_fleet = {'fleet':True, 'cmd_options':[]}
        optgroup_planet = {'planet':True, 'cmd_options':[]}
        
        for oCmdListRs in oCmdListRss:
            cmd = {}
            if oCmdListRs[2] == None:
                if oCmdListRs[3] == None:
                    item = "none"
                    optgroup_none['cmd_options'].append(cmd)
                else:
                    item = "planet"
                    optgroup_planet['cmd_options'].append(cmd)
            else:
                item = "fleet"
                optgroup_fleet['cmd_options'].append(cmd)

            if item != lastItem:
                if ShowGroup: content.Parse("optgroup")
                content.Parse("optgroup."+item)
            
            # check if the commander is the commander of the fleet we display
            if row[8] == oCmdListRs[0]: cmd["selected"] = True

            cmd["cmd_id"] = oCmdListRs[0]
            cmd["cmd_name"] = oCmdListRs[1]

            if item == "planet": 
                cmd["name"] = oCmdListRs[3]
                cmd["assigned"] = True
            elif item == "fleet":
                cmd["name"] = oCmdListRs[2]

                if oCmdListRs[4]:
                    cmd["assigned"] = True
                else:
                    cmd["unavailable"] = True

            content.Parse("optgroup.cmd_option")
            ShowGroup = True
        if ShowGroup: content.Parse("optgroup")

        optgroups = []
        if len(optgroup_none['cmd_options']) > 0: optgroups.append(optgroup_none)
        if len(optgroup_fleet['cmd_options']) > 0: optgroups.append(optgroup_fleet)
        if len(optgroup_planet['cmd_options']) > 0: optgroups.append(optgroup_planet)
        content.AssignValue("optgroups", optgroups)
        
        if row[8] == None: # display "no commander" or "fire commander" in the combobox of gm_commanders
            content.Parse("none")
            content.Parse("nocommander")
        else:
            content.Parse("unassigncommander")

            content.AssignValue("commanderid", row[8])
            content.AssignValue("commandername", row[9])
            content.Parse("commander")

        content.AssignValue("fleet_leadership", row[55])
        content.AssignValue("fleet_commander_efficiency", row[54])
        content.AssignValue("fleet_signature", row[5])
        content.AssignValue("fleet_real_signature", row[50])
        content.AssignValue("fleet_upkeep", row[52])
        content.AssignValue("fleet_upkeep_multiplicator", row[53])
        content.AssignValue("fleet_long_distance_capacity", row[38])
        content.AssignValue("fleet_required_vortex_strength", row[51])
        content.AssignValue("fleet_droppods", row[39])

        if row[39] <= 0: content.Parse("hide_droppods")

        if row[38] < row[50]: content.Parse("insufficient_long_distance_capacity")

        # display resources in cargo and its capacity
        content.AssignValue("fleet_ore", row[27])
        content.AssignValue("fleet_hydro", row[28])
        content.AssignValue("fleet_scientists", row[29])
        content.AssignValue("fleet_soldiers", row[30])
        content.AssignValue("fleet_workers", row[31])

        content.AssignValue("fleet_load", row[27] + row[28] + row[29] + row[30] + row[31])
        content.AssignValue("fleet_capacity", row[26])

        if row[26] <= 0:
            content.Parse("hide_cargo")

        content.AssignValue("fleetid", fleetid)
        content.AssignValue("fleetname", row[1])
        content.AssignValue("fleet_size", row[4])
        content.AssignValue("fleet_speed", row[6])
        content.AssignValue("recycler_output", row[32])

        if row[32] <= 0: content.Parse("hide_recycling")

        # Assign remaining time
        if row[7]:
            content.AssignValue("time", row[7])
        else:
            content.AssignValue("time", 0)

        #
        # display the fleet stance
        #
        if row[2]:
            content.Parse("attack")
        else:
            content.Parse("defend")

        # if the fleet can be set to attack (firepower > 0)
        if row[43]:
            if row[2]:
                content.Parse("setstance_defend")
            else:
                content.Parse("setstance_attack")

            content.Parse("setstance")
        else:
            content.Parse("cant_setstance")

        #
        # display gm_fleets that are near the same planet as this fleet
        # it allows to switch between the gm_fleets and merge them quickly
        #
        
        gm_fleets = []
        
        fleetCount = 0
        if row[34] != -1:
            query = "SELECT vw_gm_fleets.id, vw_gm_fleets.name, size, signature, speed, cargo_capacity-cargo_free, cargo_capacity, action, ownerid, owner_name, gm_alliances.tag, internal_profile_get_relation("+str(self.userId)+",ownerid)" + \
                    " FROM vw_gm_fleets" + \
                    "    LEFT JOIN gm_alliances ON gm_alliances.id=owner_alliance_id" + \
                    " WHERE planetid="+str(row[10])+" AND vw_gm_fleets.id != "+str(row[0])+" AND NOT engaged AND action != 1 AND action != -1" + \
                    " ORDER BY upper(vw_gm_fleets.name)"
            oFleetsRss = dbRows(query)

            for oFleetsRs in oFleetsRss:
                fleet = {}
            
                fleet["id"] = oFleetsRs[0]
                fleet["name"] = oFleetsRs[1]
                fleet["size"] = oFleetsRs[2]

                # row[48) radar_jamming of planet
                if row[17] > rFriend or oFleetsRs[11] > rFriend or row[48] == 0 or row[41] > row[48]:
                    fleet["signature"] = oFleetsRs[3]
                else:
                    fleet["signature"] = 0

                fleet["speed"] = oFleetsRs[4]
                fleet["cargo_load"] = oFleetsRs[5]
                fleet["cargo_capacity"] = oFleetsRs[6]

                if oFleetsRs[8] == self.userId:
                    if row[34] == 0 and oFleetsRs[7] == 0: fleet["merge"] = True

                    fleet["playerfleet"] = True
                    
                    gm_fleets.append(fleet)
                    fleetCount = fleetCount + 1
                else:
                    displayFleet = False

                    fleet["owner"] = oFleetsRs[9]
                    fleet["tag"] = oFleetsRs[10]

                    if oFleetsRs[11] == 1:
                        displayFleet = True
                        fleet["ally"] = True
                    elif oFleetsRs[11] == 0:
                        displayFleet = True
                        fleet["friend"] = True
                    elif oFleetsRs[11] == -1:
                        displayFleet = row[34] != 1
                        if displayFleet: fleet["enemy"] = True

                    # only display ally/nap gm_fleets when leaving a planet
                    if displayFleet:
                        gm_fleets.append(fleet)
                        fleetCount = fleetCount + 1

        if fleetCount == 0: content.Parse("nofleets")
        else: content.AssignValue("gm_fleets", gm_fleets)

        #
        # assign fleet current planet
        #
        content.AssignValue("planetid", row[10])
        content.AssignValue("g", row[12])
        content.AssignValue("s", row[13])
        content.AssignValue("p", row[14])
        content.AssignValue("relation", row[17])
        content.AssignValue("planetname", self.getPlanetName(row[17], row[41], row[16], row[11]))
        
        if row[34] == -1 or row[34] == 1: # fleet is moving when dest_planetid is not None

            # Assign destination planet
            content.AssignValue("t_planetid", row[18])
            content.AssignValue("t_g", row[20])
            content.AssignValue("t_s", row[21])
            content.AssignValue("t_p", row[22])
            content.AssignValue("t_relation", row[25])
            content.AssignValue("t_planetname", self.getPlanetName(row[25], row[42], row[24], row[19]))

            # display Cancel Move orders if fleet has covered less than 100 units of distance, or during 2 minutes
            # and if from_planet is not None
            timelimit = int(100/row[6]*3600)
            if timelimit < 120: timelimit = 120

            if not row[3] and row[35]-row[7] < timelimit and row[10]:
                content.AssignValue("timelimit", timelimit-(row[35]-row[7]))
                content.Parse("cancel_moving")

            if row[10]: content.Parse("from")

            content.Parse("moving")
        else:
            if row[3]: #if is engaged
                content.Parse("fighting")
            elif row[34] == 2:
                content.Parse("recycling")
            elif row[34] == 4:
                content.Parse("waiting")
            else:

                if row[40]: content.Parse("warp")

                if row[32] == 0 or (not row[33] and row[47] == 0): # if no recycler or nothing to recycle
                    content.Parse("cant_recycle")
                else:
                    content.Parse("recycle")

                self.can_install_building = ((row[15] == None) or (row[17] >= rHostile)) and (row[40] == None)

                # assign buildings that can be installed
                # only possible if not moving, not engaged, planet is owned by self or by nobody and is not a vortex

                if row[17] >= rFriend:
                    content.Parse("unloadcargo")

                if row[17] == rSelf and row[49] > 0:
                    content.Parse("loadcargo")
                    content.Parse("manage")

                if row[34] == 0 and row[4] > 1 and self.fleet_owner_id == self.userId:
                    content.Parse("split")

                if row[15] and row[17] < rFriend and row[30] > 0:
                    # fleet has to wait some time (defined in DB) before being able to invade
                    # row[37] is the value returned by const_seconds_before_invasion() from DB
                    if row[36] < row[37]: t = row[37] - row[36]
                    else: t = 0 
                    content.AssignValue("invade_time", int(t))

                    if row[39] == 0:
                        content.Parse("cant_invade")
                    else:
                        if row[58]:
                            content.AssignValue("prestige", row[59])
                            content.Parse("can_take")

                        content.Parse("invade")
                    
                else:
                    content.Parse("cant_invade")

                if row[34] == 0:
                    content.Parse("patrolling") # standing by/patrolling
                    content.Parse("idle")

            #
            # Fleet idling
            #
            if row[34] == 0:
                if self.move_fleet_result != "":
                    content.Parse(self.move_fleet_result)
                    content.Parse("result")
                
                #
                # populate destination list, there are 2 groups : planets and gm_fleets
                #

                # retrieve planet list
                index = 0
                hasAPlanetSelected = False

                query = "SELECT id, name, galaxy, sector, planet FROM gm_planets WHERE planet_floor > 0 AND planet_space > 0 AND ownerid=" + str(Session.get("user")) + " ORDER BY id"
                planetListArray = dbRows(query)
                if planetListArray:
                    planetgroup = []
                    for i in planetListArray:
                        planet = {}
                        
                        planet["index"] = index
                        planet["name"] = i[1]
                        planet["to_g"] = i[2]
                        planet["to_s"] = i[3]
                        planet["to_p"] = i[4]

                        if i[0] == row[10]:
                            planet["selected"] = True
                            hasAPlanetSelected = True

                        planetgroup.append(planet)
                        index += 1
                        
                    content.AssignValue("planetgroup", planetgroup)

                #
                # list planets where we have gm_fleets not on our planets
                #
                query = " SELECT DISTINCT ON (f.planetid) f.name, f.planetid, f.planet_galaxy, f.planet_sector, f.planet_planet" + \
                        " FROM vw_gm_fleets AS f" + \
                        "     LEFT JOIN gm_planets AS p ON (f.planetid=p.id)" + \
                        " WHERE f.ownerid="+ str(self.userId)+" AND p.ownerid IS DISTINCT FROM "+ str(self.userId) + \
                        " ORDER BY f.planetid" + \
                        " LIMIT 200"
                list_rows = dbRows(query)

                showGroup = False
                fleetgroup = []
                for list_oRs in list_oRss:
                    fleet = {}
                    fleet["index"] = index
                    fleet["fleet_name"] = list_oRs[0]
                    fleet["to_g"] = list_oRs[2]
                    fleet["to_s"] = list_oRs[3]
                    fleet["to_p"] = list_oRs[4]

                    if list_oRs[1] == row[10] and not hasAPlanetSelected: fleet["selected"] = True

                    fleetgroup.append(fleet)
                    index += 1
                    showGroup = True

                if showGroup: content.AssignValue("fleetgroup", fleetgroup)

                #
                # list merchant planets in the galaxy of the fleet
                #
                query = " SELECT id, galaxy, sector, planet" + \
                        " FROM gm_planets" + \
                        " WHERE ownerid=3"

                if row[12]:
                    query = query + " AND galaxy=" + str(row[12])

                query = query + " ORDER BY id"

                list_rows = dbRows(query)

                showGroup = False
                merchantplanetsgroup = []
                for list_oRs in list_oRss:
                    merchant = {}
                    merchant["index"] = index
                    merchant["to_g"] = list_oRs[1]
                    merchant["to_s"] = list_oRs[2]
                    merchant["to_p"] = list_oRs[3]

                    if list_oRs[0] == row[10] and not hasAPlanetSelected: merchant["selected"] = True

                    merchantplanetsgroup.append(merchant)
                    index += 1
                    showGroup = True

                if showGroup: content.AssignValue("merchantplanetsgroup", merchantplanetsgroup)

                content.Parse("move_fleet")

                if self.request.session.get(sPrivilege) > 100:

                    #
                    # list gm_fleet_routes
                    #
                    query = " SELECT id, name, repeat" + \
                            " FROM gm_fleet_routes" + \
                            " WHERE ownerid="+ str(self.userId)
                    list_rows = dbRows(query)

                    if list_oRss == None: content.Parse("noroute")
                    else:
                        gm_fleet_routes = []
                        for list_oRs in list_oRss:
                            route = {}
                            route["route_id"] = list_oRs[0]
                            route["route_name"] = list_oRs[1]

                            if list_oRs[0] == row[45]: route["selected"] = True

                            gm_fleet_routes.append(route)

                        content.AssignValue("gm_fleet_routes", gm_fleet_routes)

        if self.request.session.get(sPrivilege) > 100:
            content.Parse("showroute")

        # display action error
        if self.action_result != "": content.Parse(self.action_result)

        content.Parse("overview")

        if row[15]:
            planet_ownerid = row[15]
        else:
            planet_ownerid = self.userId

        # display header
        if row[34] == 0 and row[17] == rSelf:
            self.currentPlanetId = row[10]
            self.FillHeader(content)
        else:
            self.FillHeaderCredits(content)
        
        #
        # display the list of ships in the fleet
        #
        query = "SELECT dt_ships.id, gm_fleet_ships.quantity," + \
                " signature, capacity, handling, speed, weapon_turrets, weapon_dmg_em+weapon_dmg_explosive+weapon_dmg_kinetic+weapon_dmg_thermal AS weapon_power, weapon_tracking_speed, hull, shield, recycler_output, long_distance_capacity, droppods," + \
                " buildingid, internal_planet_can_build_on(" + str(row[10]) + ", dt_ships.buildingid," + str(planet_ownerid) + ")=0 AS can_build" + \
                " FROM gm_fleet_ships" + \
                "    LEFT JOIN dt_ships ON (gm_fleet_ships.shipid = dt_ships.id)" + \
                " WHERE fleetid=" + str(fleetid) + \
                " ORDER BY dt_ships.category, dt_ships.label"
        oRss = dbDictRows(query)

        shipCount = 0

        ships = []
        for row in rows:
            ship = {}
            shipCount = shipCount + 1

            ship["id"] = row["id"]
            ship["quantity"] = row["quantity"]

            # assign ship label, description + characteristics
            ship["name"] = getShipLabel(row["id"])
            ship["description"] = getShipDescription(row["id"])

            ship["ship_signature"] = row["signature"]
            ship["ship_cargo"] = row["capacity"]
            ship["ship_handling"] = row["handling"]
            ship["ship_speed"] = row["speed"]

            ship["ship_turrets"] = row["weapon_turrets"]
            ship["ship_power"] = row["weapon_power"]
            ship["ship_tracking_speed"] = row["weapon_tracking_speed"]

            ship["ship_hull"] = row["hull"]
            ship["ship_shield"] = row["shield"]

            ship["ship_recycler_output"] = row["recycler_output"]
            ship["ship_long_distance_capacity"] = row["long_distance_capacity"]
            ship["ship_droppods"] = row["droppods"]

            if row["buildingid"]:
                if self.can_install_building and row["can_build"]:
                    ship["install"] = True
                else:
                    ship["cant_install"] = True

            ships.append(ship)
            
        content.AssignValue("shiplist", ships)

        content.Parse("display")

        if self.userId==1009: content.Parse("dev")

        return self.display(content)

    def InstallBuilding(self, fleetid, shipid):
        
        row = dbRow("SELECT user_fleet_deploy(" + str(self.fleet_owner_id) + "," + str(fleetid) + "," + str(shipid) + ")")

        if row == None: return

        if row[0] >= 0:
            # set as the new planet in == it has been colonized, the player expects to see its new planet after colonization
            self.currentPlanetId = row[0]

            # invalidate planet list to reload it in == a planet has been colonized
            
        elif row[0] == -7:
            self.action_result = "error_max_planets_reached"
        elif row[0] == -8:
            self.action_result = "error_deploy_enemy_ships"
        elif row[0] == -11:
            self.action_result = "error_deploy_too_many_safe_planets"

    def MoveFleet(self, fleetid):

        g = ToInt(self.request.POST.get("g"),-1)
        s = ToInt(self.request.POST.get("s"),-1)
        p = ToInt(self.request.POST.get("p"),-1)

        if g==-1 or s==-1 or p==-1:
            self.move_fleet_result = "bad_destination"
            return
        
        row = dbRow("SELECT user_fleet_move(" + str(self.fleet_owner_id) + "," + str(fleetid) + "," + str(g) + "," + str(s) + "," + str(p) + ")")
        if row:
            res = row[0]

            if res == 0:
                if self.request.POST.get("movetype") == "1":
                    dbExecute("UPDATE gm_fleets SET next_waypointid = internal_profile_create_fleet_route_unload_move(planetid) WHERE ownerid=" + str(self.fleet_owner_id) + " AND id=" + str(fleetid))
                elif self.request.POST.get("movetype") == "2":
                    dbExecute("UPDATE gm_fleets SET next_waypointid = internal_profile_create_fleet_route_recycle_move(planetid) WHERE ownerid=" + str(self.fleet_owner_id) + " AND id=" + str(fleetid))

        else:
            res = 0
        
        if res == 0:
            self.move_fleet_result = "ok"
        elif res == -4: # new player or holidays protection
            self.move_fleet_result = "new_player_protection"
        elif res == -5: # long travel not possible
            self.move_fleet_result = "long_travel_impossible"
        elif res == -6: # not enough money
            self.move_fleet_result = "not_enough_credits"
        elif res == -7:
            self.move_fleet_result = "error_jump_from_require_empty_location"
        elif res == -8:
            self.move_fleet_result = "error_jump_protected_galaxy"
        elif res == -9:
            self.move_fleet_result = "error_jump_to_require_empty_location"
        elif res == -10:
            self.move_fleet_result = "error_jump_to_same_point_limit_reached"

    def Invade(self, fleetid, droppods, take):
        row = dbRow("SELECT user_fleet_invade(" + str(self.fleet_owner_id) + "," + str(fleetid) + ","+ str(droppods) +"," + str(ToBool(take, False)) +")")

        res = row[0]
        
        if res == -1:
            self.action_result = "error_soldiers"
        elif res == -2:
            self.action_result = "error_fleet"
        elif res == -3:
            self.action_result = "error_planet"
        elif res == -5:
            self.action_result = "error_invade_enemy_ships"

        if res > 0:
            
            return HttpResponseRedirect("/game/invasion/?id=" + str(res) + "+fleetid=" + str(fleetid))

    def ExecuteOrder(self, fleetid):

        if self.request.POST.get("action") == "invade":
            droppods = ToInt(self.request.POST.get("droppods"), 0)
            self.Invade(fleetid, droppods, self.request.POST.get("take") != "")
        elif self.request.POST.get("action") == "rename":
            fleetname = self.request.POST.get("newname").strip()
            if isValidObjectName(fleetname):
                dbExecute("UPDATE gm_fleets SET name="+sqlStr(fleetname)+" WHERE action=0 AND not engaged AND ownerid=" + str(self.userId) + " AND id=" + str(fleetid))
            
        elif self.request.POST.get("action") == "assigncommander":
            # assign new commander
            if ToInt(self.request.POST.get("commander"), 0) != 0:
                commanderid = sqlStr(self.request.POST.get("commander"))
                dbRow("SELECT user_commander_assign(" + str(self.fleet_owner_id) + "," + str(commanderid) + ",NULL," + str(fleetid) + ")")
            else:
                # unassign current fleet commander
                dbExecute("UPDATE gm_fleets SET commanderid=null WHERE ownerid=" + str(self.fleet_owner_id) + " AND id=" + str(fleetid))

            dbRow("SELECT internal_fleet_update_bonuses(" + str(fleetid) + ")")
        elif self.request.POST.get("action") == "move":
            self.MoveFleet(fleetid)

        if self.request.GET.get("action") == "share":
            dbExecute("UPDATE gm_fleets SET shared=not shared WHERE ownerid=" + str(self.fleet_owner_id) + " AND id=" + str(fleetid))
        elif self.request.GET.get("action") == "abandon":
            dbRow("SELECT sp_abandon_fleet(" + str(self.userId) + "," + str(fleetid) + ")")
        elif self.request.GET.get("action") == "attack":
            dbExecute("UPDATE gm_fleets SET attackonsight=firepower > 0 WHERE ownerid=" + str(self.fleet_owner_id) + " AND id=" + str(fleetid))
        elif self.request.GET.get("action") == "defend":
            dbExecute("UPDATE gm_fleets SET attackonsight=False WHERE ownerid=" + str(self.fleet_owner_id) + " AND id=" + str(fleetid))
        elif self.request.GET.get("action") == "recycle":
            row = dbRow("SELECT user_fleet_start_recycling(" + str(self.fleet_owner_id) + "," + str(fleetid) + ")")
            if row[0] == -2:
                self.action_result = "error_recycling"
            
        elif self.request.GET.get("action") == "stoprecycling":
            dbRow("SELECT user_fleet_cancel_recycling(" + str(self.fleet_owner_id) + "," + str(fleetid) + ")")
        elif self.request.GET.get("action") == "stopwaiting":
            dbRow("SELECT user_fleet_cancel_waiting(" + str(self.fleet_owner_id) + "," + str(fleetid) + ")")
        elif self.request.GET.get("action") == "merge":
            destfleetid = ToInt(self.request.GET.get("with"), 0)
            dbRow("SELECT user_fleet_merge(" + str(self.userId) + "," + str(fleetid) + ","+ str(destfleetid) +")")
        elif self.request.GET.get("action") == "return":
            dbRow("SELECT user_fleet_cancel_moving(" + str(self.fleet_owner_id) + "," + str(fleetid) + ")")
        elif self.request.GET.get("action") == "install":
            shipid = ToInt(self.request.GET.get("s"), 0)
            self.InstallBuilding(fleetid, shipid)
        elif self.request.GET.get("action") == "warp":
            dbRow("SELECT user_fleet_warp(" + str(self.fleet_owner_id) + "," + str(fleetid) + ")")