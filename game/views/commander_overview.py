# -*- coding: utf-8 -*-

from game.views._base import *

#-------------------------------------------------------------------------------
class View(BaseView):

    def dispatch(self, request, *args, **kwargs):

        response = super().pre_dispatch(request, *args, **kwargs)
        if response: return response

        self.max_ore = 2.0
        self.max_hydrocarbon = 2.0
        self.max_energy = 2.0
        self.max_workers = 2.0

        self.max_speed = 1.3
        self.max_shield = 1.4
        self.max_handling = 1.75
        self.max_targeting = 1.75
        self.max_damages = 1.3
        self.max_signature = 1.2

        self.max_recycling = 1.1

        self.max_build = 3
        self.max_ship = 3

        self.selected_menu = "gm_commanders"

        CommanderId = ToInt(request.GET.get("id"), 0)
        NewName = request.GET.get("name")

        if request.GET.get("a") == "rename":
            return self.RenameCommander(CommanderId, NewName)
        elif request.GET.get("a") == "edit":
            return self.EditCommander(CommanderId)
        elif request.GET.get("a") == "fire":
            return self.FireCommander(CommanderId)
        elif request.GET.get("a") == "engage":
            return self.EngageCommander(CommanderId)
        elif request.GET.get("a") == "skills":
            return self.DisplayCommanderEdition(CommanderId)
        elif request.GET.get("a") == "train":
            return self.TrainCommander(CommanderId)
        else:
            return self.ListCommanders()

    def DisplayBonus(self, item, bonus, value):
        if value > 0:
            bonus["bonus"] = "+" + str(value)
            bonus["positive"] = True
        elif value < 0:
            bonus["bonus"] = value
            bonus["negative"] = True
        else:
            bonus["bonus"] = value

        item["bonuses"].append(bonus)

    # List the gm_commanders owned by the player
    def ListCommanders(self):
        content = self.loadTemplate("gm_commanders")

        content.AssignValue("planetid", self.currentPlanetId)

        # generate new gm_commanders if needed for the player
        dbRow("SELECT internal_profile_check_for_new_commanders(" + str(self.userId) + ")")

        # retrieve how many gm_commanders are controled by the player
        row = dbRow("SELECT int4(count(1)) FROM gm_commanders WHERE recruited <= now() AND ownerid=" + str(self.userId))
        can_engage_commander = row[0] < self.userInfo["mod_commanders"]

        # Retrieve all the gm_commanders belonging to the player
        query = "SELECT c.id, c.name, c.recruited, points, added, salary, can_be_fired, " + \
                " p.id, p.galaxy, p.sector, p.planet, p.name, " + \
                " f.id, f.name, " + \
                " c.mod_production_ore, c.mod_production_hydrocarbon, c.mod_production_energy, " + \
                " c.mod_production_workers, c.mod_fleet_speed, c.mod_fleet_shield, " + \
                " c.mod_fleet_handling, c.mod_fleet_tracking_speed, c.mod_fleet_damage, c.mod_fleet_signature, "  + \
                " c.mod_construction_speed_buildings, c.mod_construction_speed_ships, last_training < now()-interval '1 day', internal_commander_get_prestige_cost_to_train(c.ownerid, c.id), salary_increases < 20" + \
                " FROM gm_commanders AS c" + \
                "    LEFT JOIN gm_fleets AS f ON (c.id=f.commanderid)" + \
                "    LEFT JOIN gm_planets AS p ON (c.id=p.commanderid)" + \
                " WHERE c.ownerid=" + str(self.userId) + \
                " ORDER BY upper(c.name)"
        oRss = dbRows(query)

        available_commanders_count = 0
        commanders_count = 0

        gm_commanders = []
        content.AssignValue("commander_list", gm_commanders)
        available_commanders = []
        content.AssignValue("available_commanders", available_commanders)
        for row in oRss:
            item = {}
            
            item["id"] = row[0]
            item["name"] = row[1]
            item["recruited"] = row[2]
            item["added"] = row[4]
            item["salary"] = row[5]

            if row[2] == None:
                available_commanders.append(item)
                section = "available_commanders"
                available_commanders_count = available_commanders_count + 1

                if can_engage_commander:
                    item["can_engage"] = True
                else:
                    item["cant_engage"] = True

            else:
                gm_commanders.append(item)
                section = "gm_commanders"
                commanders_count = commanders_count + 1

                if row[6]:
                    item["can_fire"] = True
                else:
                    item["cant_fire"] = True

            if row[7] == None: # commander is not assigned to a planet
                if row[12] == None: # nor to a fleet
                    item["not_assigned"] = True
                else:
                    item["fleetid"] = row[12]
                    item["commandment"] = row[13]
                    item["fleet_command"] = True

            else:
                item["planetid"] = row[7]
                item["g"] = row[8]
                item["s"] = row[9]
                item["p"] = row[10]
                item["commandment"] = row[11]
                item["planet_command"] = True

            #
            # browse the possible bonus
            #
            item["bonuses"] = []
            for i in range(14, 26):
                if row[i] != 1.0:
                    bonus = {}
                    bonus["description" + str(i)] = True
                    self.DisplayBonus(item, bonus, round((row[i]-1.0)*100))

            if row[26] and row[28]:
                item["prestige"] = row[27]
                item["train"] = True
            else:
                if row[28]:
                    item["cant_train"] = True
                else:
                    item["cant_train_anymore"] = True

            if row[3] > 0:
                item["points"] = row[3]
                item["levelup"] = True

        content.AssignValue("max_commanders", int(self.userInfo["mod_commanders"]))

        if available_commanders_count == 0: content.Parse("available_commanders_nocommander")
        if commanders_count == 0: content.Parse("commanders_nocommander")

        self.FillHeaderCredits(content)

        return self.display(content)

    def DisplayCommanderEdition(self, CommanderId):

        content = self.loadTemplate("gm_commanders")

        content.AssignValue("commanderid", CommanderId)

        if CommanderId != 0:

            query = "SELECT mod_production_ore, mod_production_hydrocarbon, mod_production_energy," + \
                    " mod_production_workers, mod_fleet_speed, mod_fleet_shield, mod_fleet_handling," + \
                    " mod_fleet_tracking_speed, mod_fleet_damage, mod_fleet_signature," + \
                    " mod_construction_speed_buildings, mod_construction_speed_ships," + \
                    " points, name" + \
                    " FROM gm_commanders WHERE id=" + str(CommanderId) + " AND ownerid=" + str(self.userId)
            row = dbRow(query)

            if row == None:
                # commander not found !
               return HttpResponseRedirect("/game/gm_commanders/")

            content.AssignValue("name", row[13])
            content.AssignValue("maxpoints", row[12])

            content.AssignValue("ore", str(row[0]).replace(",", "."))
            content.AssignValue("hydrocarbon", str(row[1]).replace(",", "."))
            content.AssignValue("energy", str(row[2]).replace(",", "."))
            content.AssignValue("workers", str(row[3]).replace(",", "."))

            content.AssignValue("speed", str(row[4]).replace(",", "."))
            content.AssignValue("shield", str(row[5]).replace(",", "."))
            content.AssignValue("handling", str(row[6]).replace(",", "."))
            content.AssignValue("targeting", str(row[7]).replace(",", "."))
            content.AssignValue("damages", str(row[8]).replace(",", "."))
            content.AssignValue("signature", str(row[9]).replace(",", "."))

            content.AssignValue("build", str(row[10]).replace(",", "."))
            content.AssignValue("ship", str(row[11]).replace(",", "."))

            content.AssignValue("max_ore", str(self.max_ore).replace(",", "."))
            content.AssignValue("max_hydrocarbon", str(self.max_hydrocarbon).replace(",", "."))
            content.AssignValue("max_energy", str(self.max_energy).replace(",", "."))
            content.AssignValue("max_workers", str(self.max_workers).replace(",", "."))

            content.AssignValue("max_speed", str(self.max_speed).replace(",", "."))
            content.AssignValue("max_shield", str(self.max_shield).replace(",", "."))
            content.AssignValue("max_handling", str(self.max_handling).replace(",", "."))
            content.AssignValue("max_targeting", str(self.max_targeting).replace(",", "."))
            content.AssignValue("max_damages", str(self.max_damages).replace(",", "."))
            content.AssignValue("max_signature", str(self.max_signature).replace(",", "."))

            content.AssignValue("max_build", str(self.max_build).replace(",", "."))
            content.AssignValue("max_ship", str(self.max_ship).replace(",", "."))

            content.AssignValue("max_recycling", str(self.max_recycling).replace(",", "."))

        content.Parse("editcommander")

        return self.display(content)

    def Max(self, a,b):
        if a<b:
            Max=b
        else:
            Max=a

    def EditCommander(self, CommanderId):

        ore = max(0, ToInt(self.request.POST.get("ore"), 0))
        hydrocarbon = max(0, ToInt(self.request.POST.get("hydrocarbon"), 0))
        energy = max(0, ToInt(self.request.POST.get("energy"), 0))
        workers = max(0, ToInt(self.request.POST.get("workers"), 0))

        fleetspeed = max(0, ToInt(self.request.POST.get("fleet_speed"), 0))
        fleetshield = max(0, ToInt(self.request.POST.get("fleet_shield"), 0))
        fleethandling = max(0, ToInt(self.request.POST.get("fleet_handling"), 0))
        fleettargeting = max(0, ToInt(self.request.POST.get("fleet_targeting"), 0))
        fleetdamages = max(0, ToInt(self.request.POST.get("fleet_damages"), 0))
        fleetsignature = max(0, ToInt(self.request.POST.get("fleet_signature"), 0))

        build = max(0, ToInt(self.request.POST.get("buildindspeed"), 0))
        ship = max(0, ToInt(self.request.POST.get("shipconstructionspeed"), 0))

        total = ore + hydrocarbon + energy + workers + fleetspeed + fleetshield + fleethandling + fleettargeting + fleetdamages + fleetsignature + build + ship

        query = "UPDATE gm_commanders SET" + \
                "    mod_production_ore=mod_production_ore + 0.01*" + str(ore) + \
                "    ,mod_production_hydrocarbon=mod_production_hydrocarbon + 0.01*" + str(hydrocarbon) + \
                "    ,mod_production_energy=mod_production_energy + 0.1*" + str(energy) + \
                "    ,mod_production_workers=mod_production_workers + 0.1*" + str(workers) + \
                "    ,mod_fleet_speed=mod_fleet_speed + 0.02*" + str(fleetspeed) + \
                "    ,mod_fleet_shield=mod_fleet_shield + 0.02*" + str(fleetshield) + \
                "    ,mod_fleet_handling=mod_fleet_handling + 0.05*" + str(fleethandling) + \
                "    ,mod_fleet_tracking_speed=mod_fleet_tracking_speed + 0.05*" + str(fleettargeting) + \
                "    ,mod_fleet_damage=mod_fleet_damage + 0.02*" + str(fleetdamages) + \
                "    ,mod_fleet_signature=mod_fleet_signature + 0.02*" + str(fleetsignature) + \
                "    ,mod_construction_speed_buildings=mod_construction_speed_buildings + 0.05*" + str(build) + \
                "    ,mod_construction_speed_ships=mod_construction_speed_ships + 0.05*" + str(ship) + \
                "    ,points=points-" + str(total) + \
                " WHERE ownerid=" + str(self.userId) + " AND id=" + str(CommanderId) + " AND points >= " + str(total)

        dbExecute(query)

        query = "SELECT mod_production_ore, mod_production_hydrocarbon, mod_production_energy," + \
                    " mod_production_workers, mod_fleet_speed, mod_fleet_shield, mod_fleet_handling," + \
                    " mod_fleet_tracking_speed, mod_fleet_damage, mod_fleet_signature," + \
                    " mod_construction_speed_buildings, mod_construction_speed_ships" + \
                    " FROM gm_commanders" + \
                    " WHERE id=" + str(CommanderId) + " AND ownerid=" + str(self.userId)
        row = dbRow(query)

        if row[0] <= self.max_ore+0.0001 and row[1] <= self.max_hydrocarbon+0.0001 and row[2] <= self.max_energy+0.0001 and row[3] <= self.max_workers+0.0001 and \
            row[4] <= self.max_speed+0.0001 and row[5] <= self.max_shield+0.0001 and row[6] <= self.max_handling+0.0001 and row[7] <= self.max_targeting+0.0001 and row[8] <= self.max_damages+0.0001 and row[9] <= self.max_signature+0.0001 and \
            row[10] <= self.max_build+0.0001 and row[11] <= self.max_ship+0.0001:

            query = "SELECT internal_fleet_update_bonuses(id) FROM gm_fleets WHERE commanderid=" + str(CommanderId)
            dbExecute(query)

            query = "SELECT internal_planet_update_data(id) FROM gm_planets WHERE commanderid=" + str(CommanderId)
            dbExecute(query)

        return HttpResponseRedirect("/game/gm_commanders/")

    def RenameCommander(self, CommanderId, NewName):

        query = "SELECT user_commander_rename(" + str(self.userId) + "," + str(CommanderId) + "," + sqlStr(NewName) + ")"
        dbExecute(query)
        return HttpResponseRedirect("/game/gm_commanders/")

    def EngageCommander(self, CommanderId):

        query = "SELECT user_commander_engage(" + str(self.userId) + "," + str(CommanderId) + ")"
        dbExecute(query)
        return HttpResponseRedirect("/game/gm_commanders/")

    def FireCommander(self, CommanderId):

        query = "SELECT user_commander_fire(" + str(self.userId) + "," + str(CommanderId) + ")"
        dbExecute(query)
        return HttpResponseRedirect("/game/gm_commanders/")

    def TrainCommander(self, CommanderId):

        query = "SELECT user_commander_train(" + str(self.userId) + "," + str(CommanderId) + ")"
        dbExecute(query)
        return HttpResponseRedirect("/game/gm_commanders/")
