# -*- coding: utf-8 -*-

from game.views._base import *

#-------------------------------------------------------------------------------
class View(BaseView):
    
    def dispatch(self, request, *args, **kwargs):

        response = super().pre_dispatch(request, *args, **kwargs)
        if response: return response
        
        self.selected_menu = "shipyard_all"

        self.showHeader = True

        Action = request.GET.get("a","").lower()

        # retrieve which page to display
        self.ShipFilter = ToInt(request.GET.get("f", -1), -1)

        if self.ShipFilter == -1:
            self.ShipFilter = ToInt(request.session.get("shipyardfilter", 0), 0)

        if self.ShipFilter < 0 or self.ShipFilter > 3: self.ShipFilter = 0

        request.session["shipyardfilter"] = self.ShipFilter

        if Action == "build" or Action == "bui1d":
            return self.BuildShips()

        if Action == "recycle": return self.RecycleShips()

        if Action == "cancel":
            QueueId = ToInt(request.GET.get("q"),0)

            if QueueId != 0: return self.CancelQueue(QueueId)

        self.RetrieveData()

        if request.GET.get("recycle","") != "":
            return self.ListRecycleShips()
        else:
            return self.ListShips()

    # retrieve planet and player information
    def RetrieveData(self):
        
        # Retrieve recordset of current planet
        query = "SELECT ore_capacity, hydro_capacity, energy_capacity, workers_capacity" + \
                " FROM vw_gm_planets WHERE id="+str(self.currentPlanetId)
        self.oPlanet = dbRow(query)

    def displayQueue(self, content, planetid):
        # list queued ships and ships under construction

        query = "SELECT id, shipid, remaining_time, quantity, end_time, recycle, required_shipid, int4(cost_ore*internal_profile_get_ore_recycling_coeff(ownerid)), int4(cost_hydro*internal_profile_get_hydro_recycling_coeff(ownerid)), cost_ore, cost_hydro, cost_energy, crew" + \
                " FROM vw_gm_planet_ship_pendings" + \
                " WHERE planetid=" + str(planetid) + \
                " ORDER BY start_time, shipid"

        rows = dbRows(query)

        buildingcount = 0
        queuecount = 0
        
        queues = []
        underconstructions = []

        if rows:
            for row in rows:
                item = {}
            
                item["queueid"] = row[0]
                item["id"] = row[1]
                item["name"] = getShipLabel(row[1])
    
                if int(row[2]) > 0:
                    item["remainingtime"] = row[2]
                else:
                    item["remainingtime"] = 0
    
                item["quantity"] = row[3]
    
                if row[5]:
                    item["ore"] = row[3]*row[7]
                    item["hydro"] = row[3]*row[8]
                    item["energy"] = 0
                    item["crew"] = 0
                else:
                    item["ore"] = row[3]*row[9]
                    item["hydro"] = row[3]*row[10]
                    item["energy"] = row[3]*row[11]
                    item["crew"] = row[3]*row[12]
    
                if row[6]: item["required_ship_name"] = getShipLabel(row[6])
    
                if row[4]:
                    if row[5]:
                        item["recycle"] = True
                    else:
                        item["cancel"] = True
    
                    if row[6]: item["required_ship"] = True
    
                    item["ship"] = True
                    underconstructions.append(item)
                else:
                    if row[5]: item["recycle"] = True
                    if row[6]: item["required_ship"] = True
    
                    item["cancel"] = True
                    item["ship"] = True
                    queues.append(item)
                
        content.AssignValue("queues", queues)
        content.AssignValue("underconstructions", underconstructions)

    # List all the available ships for construction
    def ListShips(self):

        # list ships that can be built on the planet
        query = "SELECT id, category, name, cost_ore, cost_hydro, cost_energy, workers, crew, capacity," + \
                " construction_time, hull, shield, weapon_power, weapon_ammo, weapon_tracking_speed, weapon_turrets, signature, speed," + \
                " handling, buildingid, recycler_output, droppods, long_distance_capacity, quantity, buildings_requirements_met, research_requirements_met," + \
                " required_shipid, required_ship_count, COALESCE(new_shipid, id) AS shipid, cost_prestige, upkeep, required_vortex_strength, mod_leadership" + \
                " FROM vw_gm_planet_ships WHERE planetid=" + str(self.currentPlanetId)

        if self.ShipFilter == 1:
            self.selected_menu = "shipyard_military"
            query = query + " AND weapon_power > 0 AND required_shipid IS NULL" # military ships only
        elif self.ShipFilter == 2:
            self.selected_menu = "shipyard_unarmed"
            query = query + " AND weapon_power = 0 AND required_shipid IS NULL" # non-military ships
        elif self.ShipFilter == 3:
            self.selected_menu = "shipyard_upgrade"
            query = query + " AND required_shipid IS NOT NULL" # upgrade ships only
        query = query + " ORDER BY category, id"
        
        oRss = dbDictRows(query)

        content = self.loadTemplate("shipyard")

        content.AssignValue("planetid", self.currentPlanetId)
        content.AssignValue("filter", self.ShipFilter)

        # number of items in category
        itemCount = 0

        # number of ships types that can be built
        buildable = 0

        lastCategory = -1 

        categories = []

        count = 0
        for row in rows:
            if (row["quantity"] > 0) or row["research_requirements_met"]:
                CatId = row["category"]

                if CatId != lastCategory:
                    category = {'id':CatId, 'ships':[]}
                    categories.append(category)
                    
                    lastCategory = CatId

                ship = {}
                category['ships'].append(ship)
                count += 1

                ShipId = row["shipid"]

                ship["id"] = row["id"]
                ship["name"] = getShipLabel(ShipId)

                if row["required_shipid"]:
                    ship["required_ship_name"] = getShipLabel(row["required_shipid"])
                    ship["required_ship_available"] = row["required_ship_count"]
                    if row["required_ship_count"] == 0: ship["required_ship_none_available"] = True
                    ship["required_ship"] = True

                if row["cost_prestige"] > 0:
                    ship["required_pp"] = row["cost_prestige"]
                    ship["pp"] = self.userInfo["prestige_points"]
                    if row["cost_prestige"] > self.userInfo["prestige_points"]: ship["required_pp_not_enough"] = True

                ship["ore"] = row["cost_ore"]
                ship["hydro"] = row["cost_hydro"]
                ship["energy"] = row["cost_energy"]
                ship["workers"] = row["workers"]
                ship["crew"] = row["crew"]
                ship["upkeep"] = row["upkeep"]

                ship["quantity"] = row["quantity"]

                ship["time"] = row["construction_time"]

                # assign ship description
                ship["description"] = getShipDescription(row["shipid"])

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
                ship["ship_required_vortex_strength"] = row["required_vortex_strength"]

                ship["ship_leadership"] = row["mod_leadership"]

                if row["research_requirements_met"]:
                    ship["construction_time"] = True

                    notenoughresources = False

                    if row["cost_ore"] > self.oPlanet[0]:
                        ship["not_enough_ore"] = True
                        notenoughresources = True
                    
                    if row["cost_hydro"] > self.oPlanet[1]:
                        ship["not_enough_hydro"] = True
                        notenoughresources = True
                    
                    if row["cost_energy"] > self.oPlanet[2]:
                        ship["not_enough_energy"] = True
                        notenoughresources = True
                    
                    if row["crew"] > self.oPlanet[3]:
                        ship["not_enough_crew"] = True
                        notenoughresources = True

                    can_build = True

                    if not row["buildings_requirements_met"]:
                        ship["buildings_required"] = True
                        can_build = False

                    if notenoughresources:
                        ship["notenoughresources"] = True
                        can_build = False

                    if can_build:
                        ship["build"] = True
                        buildable = buildable + 1
                    
                else:
                    ship["no_construction_time"] = True
                    ship["cant_build"] = True

                if self.request.session.get("privilege", 0) >= 100: ship["dev"] = True

                for i in dtShipBuildingReqs():
                    if i[0] == ShipId:
                        ship["building"] = getBuildingLabel(i[1])
                        ship["buildingsrequired"] = True
        
        if count == 0: content.Parse("no_shipyard")
        else: content.AssignValue("categories", categories)
        
        if buildable > 0: content.Parse("build")
        else: content.Parse("nobuild")

        self.displayQueue(content, str(self.currentPlanetId))

        return self.display(content)

    # List all the available ships for recycling
    def ListRecycleShips(self):

        self.selected_menu = "shipyard_recycle"

        # list ships that are on the planet
        query = "SELECT id, category, name, int4(cost_ore * internal_profile_get_ore_recycling_coeff(planet_ownerid)) AS cost_ore, int4(cost_hydro * internal_profile_get_hydro_recycling_coeff(planet_ownerid)) AS cost_hydro, cost_credits, workers, crew, capacity," + \
                " int4(static_planet_ship_recycling_coeff() * construction_time) as construction_time, hull, shield, weapon_power, weapon_ammo, weapon_tracking_speed, weapon_turrets, signature, speed," + \
                " handling, buildingid, recycler_output, droppods, long_distance_capacity, quantity, true, true," + \
                " NULL, 0, COALESCE(new_shipid, id) AS shipid" + \
                " FROM vw_gm_planet_ships" + \
                " WHERE quantity > 0 AND planetid=" + str(self.currentPlanetId)

        oRss = dbDictRows(query)
        
        content = self.loadTemplate("shipyard-recycle")

        content.AssignValue("planetid", str(self.currentPlanetId))
        content.AssignValue("filter", self.ShipFilter)

        # number of items in category
        itemCount = 0

        # number of ships types that can be built
        buildable = 0

        lastCategory = -1 

        categories = []

        count = 0
        for row in rows:
            CatId = row["category"]

            if CatId != lastCategory:
                category = {'id':CatId, 'ships':[]}
                categories.append(category)
                
                lastCategory = lastCategory

            ship = {}
            category['ships'].append(ship)

            itemCount = itemCount + 1

            ship["id"] = row["id"]
            ship["name"] = getShipLabel(row["shipid"])

            ship["ore"] = row["cost_ore"]
            ship["hydro"] = row["cost_hydro"]
            ship["credits"] = row["cost_credits"]
            ship["workers"] = row["workers"]
            ship["crew"] = row["crew"]

            ship["quantity"] = row["quantity"]

            ship["time"] = row["construction_time"]

            # assign ship description
            ship["description"] = getShipDescription(row["shipid"])

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

            ship["construction_time"] = True

            can_build = True

            ship["build"] = True
            buildable = buildable + 1

            if self.request.session.get("privilege", 0) >= 100: ship["dev"] = True

            count = count + 1

        if count == 0: content.Parse("no_shipyard")
        content.AssignValue("categories", categories)
        
        if buildable > 0: content.Parse("build")
        else: content.Parse("nobuild")

        self.displayQueue(content, str(self.currentPlanetId))

        return self.display(content)

    # build ships

    def StartShip(self, ShipId, quantity):
        dbExecuteRetryNoRow("SELECT user_planet_ship_start(" + str(self.currentPlanetId) + "," + str(ShipId) + "," + str(quantity) + ", false)")

    def BuildShips(self):

        for i in dtShips():
            shipid = i[0]

            quantity = ToInt(self.request.POST.get("s" + str(shipid)), 0)
            if quantity > 0: self.StartShip(shipid, quantity)
            
        return HttpResponseRedirect("/game/shipyard/?f="+str(self.ShipFilter))
        
    # recycle ships

    def RecycleShip(self, ShipId, quantity):
        dbExecuteRetryNoRow("SELECT user_planet_ship_recycle(" + str(self.currentPlanetId) + "," + str(ShipId) + "," + str(quantity) + ")")

    def RecycleShips(self):

        for i in dtShips():
            shipid = i[0]

            quantity = ToInt(self.request.POST.get("s" + str(shipid)), 0)
            if quantity > 0: self.RecycleShip(shipid, quantity)
            
        return HttpResponseRedirect("/game/shipyard/?recycle=1")

    def CancelQueue(self, QueueId):
        dbExecuteRetryNoRow("SELECT user_planet_ship_cancel(" + str(self.currentPlanetId) + "," + str(QueueId) + ")")
        
        if self.request.GET.get("recycle","") != "":
            return HttpResponseRedirect("/game/shipyard/?recycle=1")
        else:
            return HttpResponseRedirect("/game/shipyard/?f="+str(self.ShipFilter))
