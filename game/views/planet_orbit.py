# -*- coding: utf-8 -*-

from game.views._base import *

#-------------------------------------------------------------------------------
class View(BaseView):
    
    def dispatch(self, request, *args, **kwargs):

        response = super().pre_dispatch(request, *args, **kwargs)
        if response: return response
        
        self.selected_menu = "orbit"

        self.showHeader = True

        self.e_no_error = 0
        self.e_bad_name = 1
        self.e_already_exists = 2

        self.fleet_creation_error = ""

        if request.GET.get("a", "") == "new":
            self.NewFleet()

        return self.DisplayFleets()

    def DisplayFleets(self):
        
        content = self.loadTemplate("orbit")

        content.AssignValue("planetid", str(self.currentPlanetId))

        # list the gm_fleets near the planet
        query = "SELECT id, name, attackonsight, engaged, size, signature, speed, remaining_time, commanderid, commandername," + \
                " planetid, planet_name, planet_galaxy, planet_sector, planet_planet, planet_ownerid, planet_owner_name, planet_owner_relation," + \
                " destplanetid, destplanet_name, destplanet_galaxy, destplanet_sector, destplanet_planet, destplanet_ownerid, destplanet_owner_name, destplanet_owner_relation," + \
                " action, cargo_ore, cargo_hydrocarbon, cargo_scientists, cargo_soldiers, cargo_workers" + \
                " FROM vw_gm_fleets " + \
                " WHERE planetid="+ str(self.currentPlanetId) +" AND action != 1 AND action != -1" + \
                " ORDER BY upper(name)"
        oRss = dbRows(query)

        if not oRss:
            content.Parse("nofleets")
        else:
            gm_fleets = []
            content.AssignValue("gm_fleets", gm_fleets)
            
            for row in oRss:
                manage = False
                trade = False
                
                fleet = {}

                fleet["id"] = row[0]
                fleet["name"] = row[1]
                fleet["size"] = row[4]
                fleet["signature"] = row[5]

                fleet["ownerid"] = row[20]
                fleet["ownername"] = row[21]

                fleet["cargo"] = row[27]+row[28]+row[29]+row[30]+row[31]
                fleet["cargo_ore"] = row[27]
                fleet["cargo_hydrocarbon"] = row[28]
                fleet["cargo_scientists"] = row[29]
                fleet["cargo_soldiers"] = row[30]
                fleet["cargo_workers"] = row[31]

                if row[8]:
                    fleet["commanderid"] = row[8]
                    fleet["commandername"] = row[9]
                    fleet["commander"] = True
                else:
                    fleet["nocommander"] = True

                if row[26] == 2:
                    fleet["recycling"] = True
                elif row[3]:
                    fleet["fighting"] = True
                else:
                    fleet["patrolling"] = True

                if row[17] == rHostile or row[17] == rWar:
                    fleet["enemy"] = True
                elif row[17] == rAlliance:
                    fleet["ally"] = True
                elif row[17] == rFriend:
                    fleet["friend"] = True
                elif row[17] == rSelf:
                    if row[26] == 0:
                        fleet["owner"] = True

                if manage:
                    fleet["manage"] = True
                else:
                    fleet["cant_manage"] = True

                if trade:
                    fleet["trade"] = True
                else:
                    fleet["cant_trade"] = True
                
                gm_fleets.append(fleet)

        # list the ships on the planet to create a new fleet
        query = "SELECT shipid, quantity," + \
                " signature, capacity, handling, speed, (weapon_dmg_em + weapon_dmg_explosive + weapon_dmg_kinetic + weapon_dmg_thermal) AS weapon_power, weapon_turrets, weapon_tracking_speed, hull, shield, recycler_output, long_distance_capacity, droppods" + \
                " FROM gm_planet_ships LEFT JOIN dt_ships ON (gm_planet_ships.shipid = dt_ships.id)" + \
                " WHERE planetid=" + str(self.currentPlanetId) + \
                " ORDER BY category, label"

        oRss = dbDictRows(query)
        if not oRss:
            content.Parse("noships")
        else:
            ships = []
            content.AssignValue("ships", ships)
            
            for row in oRss:
                ship = {}
                
                ship["id"] = row["shipid"]
                ship["quantity"] = row["quantity"]

                ship["name"] = getShipLabel(row["shipid"])

                if self.fleet_creation_error != "": ship["ship_quantity"] = ToInt(self.request.POST.get("s" + str(row["shipid"]), 0), 0)

                # assign ship description
                ship["description"] = getShipDescription(row["shipid"])

                ship["ship_signature"] = row["signature"]
                ship["ship_cargo"] = row["capacity"]
                ship["ship_handling"] = row["handling"]
                ship["ship_speed"] = row["speed"]

                if row["weapon_power"] > 0:
                    ship["ship_turrets"] = row["weapon_turrets"]
                    ship["ship_power"] = row["weapon_power"]
                    ship["ship_tracking_speed"] = row["weapon_tracking_speed"]
                    ship["attack"] = True

                ship["ship_hull"] = row["hull"]

                if row["shield"] > 0:
                    ship["ship_shield"] = row["shield"]
                    ship["shield"] = True

                if row["recycler_output"] > 0:
                    ship["ship_recycler_output"] = row["recycler_output"]
                    ship["recycler_output"] = True

                if row["long_distance_capacity"] > 0:
                    ship["ship_long_distance_capacity"] = row["long_distance_capacity"]
                    ship["long_distance_capacity"] = True

                if row["droppods"] > 0:
                    ship["ship_droppods"] = row["droppods"]
                    ship["droppods"] = True
                
                ships.append(ship)

            content.Parse("new")

        # Assign the fleet name passed in form body
        if self.fleet_creation_error != "":
            content.AssignValue("fleetname", self.request.POST.get("name"))

            content.Parse(self.fleet_creation_error)
            content.Parse("error")

        return self.display(content)

    #
    # Create the new fleet
    #
    def NewFleet(self):
        fleetname = self.request.POST.get("name", "").strip()

        if not isValidObjectName(fleetname):
            self.fleet_creation_error = "fleet_name_invalid"
            return

        # retrieve all ships id that exists in shipsArray
        oRss = dbRows("SELECT id FROM dt_ships")

        shipsArray = oRss
        shipsCount = len(oRss)

        # create a new fleet at the current planet with the given name
        
        row = dbRow("SELECT user_fleet_create(" + str(self.userId) + "," + str(self.currentPlanetId) + "," + sqlStr(fleetname) + ")")
        if not row:
            return
        
        fleetid = row[0]

        if fleetid < 0:
            if fleetid == -3:
                self.fleet_creation_error = "fleet_too_many"
            else:
                self.fleet_creation_error = "fleet_name_already_used"
            
            return
        
        cant_use_ship = False

        for i in shipsArray:
            shipid = i[0]
            quantity = ToInt(self.request.POST.get("s" + str(shipid)), 0)

            # add the ships type by type
            if quantity > 0:
                row = dbRow("SELECT * FROM user_planet_transfer_ships(" + str(self.userId) + ", " + str(fleetid) + ", " + str(shipid) + ", " + str(quantity) + ")")
                cant_use_ship = cant_use_ship or row[0] == 3

        # delete the fleet if there is no ships in it
        dbExecute("DELETE FROM gm_fleets WHERE size=0 AND id=" + str(fleetid) + " AND ownerid=" + str(self.userId))

        if cant_use_ship and self.fleet_creation_error == "": self.fleet_creation_error = "ship_cant_be_used"
