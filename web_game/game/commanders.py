# -*- coding: utf-8 -*-

from web_game.game._global import *

class View(GlobalView):

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

        self.selected_menu = "commanders"

        CommanderId = ToInt(request.GET.get("id"), 0)
        NewName = request.GET.get("name")

        if request.GET.get("a") == "rename":
            return self.RenameCommander CommanderId, NewName
        elif request.GET.get("a") == "edit":
            Response.write "0"
            return self.EditCommander CommanderId
        elif request.GET.get("a") == "fire":
            return self.FireCommander CommanderId
        elif request.GET.get("a") == "engage":
            return self.EngageCommander CommanderId
        elif request.GET.get("a") == "skills":
            return self.DisplayCommanderEdition CommanderId
        elif request.GET.get("a") == "train":
            return self.TrainCommander CommanderId
        else:
            return self.ListCommanders

    def DisplayBonus(self, content, value):
        if value > 0:
            content.AssignValue("bonus", "+" + value)
            content.Parse(section + ".commander.bonus.positive")
        elif value < 0:
            content.AssignValue("bonus", value)
            content.Parse(section + ".commander.bonus.negative")
        else:
            content.AssignValue("bonus", value)

        content.Parse(section + ".commander.bonus")

    # List the commanders owned by the player
    def ListCommanders(self):
        content = GetTemplate(self.request, "commanders")

        content.AssignValue("planetid", str(self.CurrentPlanet)

        # generate new commanders if needed for the player
        oConnExecute("SELECT sp_commanders_check_new_commanders(" + str(self.UserId) + ")")

        # retrieve how many commanders are controled by the player
        oRs = oConnExecute("SELECT int4(count(1)) FROM commanders WHERE recruited <= now() AND ownerid=" + str(self.UserId))
        can_engage_commander = oRs[0] < self.oPlayerInfo["mod_commanders")

        # Retrieve all the commanders belonging to the player
        query = "SELECT c.id, c.name, c.recruited, points, added, salary, can_be_fired, " + \
                " p.id, p.galaxy, p.sector, p.planet, p.name, " + \
                " f.id, f.name, " + \
                " c.mod_production_ore, c.mod_production_hydrocarbon, c.mod_production_energy, " + \
                " c.mod_production_workers, c.mod_fleet_speed, c.mod_fleet_shield, " + \
                " c.mod_fleet_handling, c.mod_fleet_tracking_speed, c.mod_fleet_damage, c.mod_fleet_signature, "  + \
                " c.mod_construction_speed_buildings, c.mod_construction_speed_ships, last_training < now()-interval '1 day', sp_commanders_prestige_to_train(c.ownerid, c.id), salary_increases < 20" + \
                " FROM commanders AS c" + \
                "    LEFT JOIN fleets AS f ON (c.id=f.commanderid)" + \
                "    LEFT JOIN nav_planet AS p ON (c.id=p.commanderid)" + \
                " WHERE c.ownerid=" + str(self.UserId) + \
                " ORDER BY upper(c.name)"
        oRss = oConnExecuteAll(query)

        available_commanders_count = 0
        commanders_count = 0

        list = []
        for oRs in oRss:
            item = {}
            list.append(item)
            
            item["id", oRs[0]
            item["name", oRs[1]
            item["recruited", oRs[2]
            item["added", oRs[4]
            item["salary", oRs[5]

            if oRs[2] == None:
                section = "available_commanders"
                available_commanders_count = available_commanders_count + 1

                if can_engage_commander:
                    content.Parse section + ".commander.can_engage"
                else:
                    content.Parse section + ".commander.cant_engage"

            else:
                section = "commanders"
                commanders_count = commanders_count + 1

                if oRs[6]:
                    content.Parse section + ".commander.can_fire"
                else:
                    content.Parse section + ".commander.cant_fire"

            if oRs[7] == None: # commander is not assigned to a planet
                if oRs[12] == None: # nor to a fleet
                    content.Parse section + ".commander.not_assigned"
                else:
                    item["fleetid", oRs[12]
                    item["commandment", oRs[13]
                    content.Parse section + ".commander.fleet_command"

            else:
                item["planetid", oRs[7]
                item["g", oRs[8]
                item["s", oRs[9]
                item["p", oRs[10]
                item["commandment", oRs[11]
                content.Parse section + ".commander.planet_command"

            #
            # browse the possible bonus
            #
            for i = 14 to 25
                if oRs[i) != 1.0:
                    content.Parse section + ".commander.bonus.description" + i
                    DisplayBonus content, Round((oRs[i)-1.0)*100)

            if oRs[26] and oRs[28]:
                item["prestige", oRs[27]
                content.Parse section + ".commander.train"
            else:
                if oRs[28]:
                    content.Parse section + ".commander.cant_train"
                else:
                    content.Parse section + ".commander.cant_train_anymore"

            if oRs[3] > 0:
                item["points", oRs[3]
                content.Parse section + ".commander.levelup"

            content.Parse section + ".commander"

        content.AssignValue("commanders", commanders_count
        content.AssignValue("max_commanders", self.oPlayerInfo["mod_commanders")

        if available_commanders_count == 0: content.Parse("available_commanders.nocommander"
        if commanders_count == 0: content.Parse("commanders.nocommander"

        content.Parse("commanders"
        content.Parse("available_commanders"

        self.FillHeaderCredits(content)

        return self.Display(content)

    def DisplayCommanderEdition(self, CommanderId):

        content = GetTemplate(self.request, "commanders")

        content.AssignValue("commanderid", CommanderId

        if CommanderId != 0:

            query = "SELECT mod_production_ore, mod_production_hydrocarbon, mod_production_energy," + \
                    " mod_production_workers, mod_fleet_speed, mod_fleet_shield, mod_fleet_handling," + \
                    " mod_fleet_tracking_speed, mod_fleet_damage, mod_fleet_signature," + \
                    " mod_construction_speed_buildings, mod_construction_speed_ships," + \
                    " points, name" + \
                    " FROM commanders WHERE id=" + CommanderId + " AND ownerid=" + str(self.UserId)
            oRs = oConnExecute(query)

            if oRs == None:
                # commander not found !
                response.redirect "commanders.asp"

            content.AssignValue("name", oRs["name")
            content.AssignValue("maxpoints", oRs["points")

            content.AssignValue("ore", Replace(oRs[0], ",", ".")
            content.AssignValue("hydrocarbon", Replace(oRs[1], ",", ".")
            content.AssignValue("energy", Replace(oRs[2], ",", ".")
            content.AssignValue("workers", Replace(oRs[3], ",", ".")

            content.AssignValue("speed", Replace(oRs[4], ",", ".")
            content.AssignValue("shield", Replace(oRs[5], ",", ".")
            content.AssignValue("handling", Replace(oRs[6], ",", ".")
            content.AssignValue("targeting", Replace(oRs[7], ",", ".")
            content.AssignValue("damages", Replace(oRs[8], ",", ".")
            content.AssignValue("signature", Replace(oRs[9], ",", ".")

            content.AssignValue("build", Replace(oRs[10], ",", ".")
            content.AssignValue("ship", Replace(oRs[11], ",", ".")

            content.AssignValue("max_ore", Replace(max_ore, ",", ".")
            content.AssignValue("max_hydrocarbon", Replace(max_hydrocarbon, ",", ".")
            content.AssignValue("max_energy", Replace(max_energy, ",", ".")
            content.AssignValue("max_workers", Replace(max_workers, ",", ".")

            content.AssignValue("max_speed", Replace(max_speed, ",", ".")
            content.AssignValue("max_shield", Replace(max_shield, ",", ".")
            content.AssignValue("max_handling", Replace(max_handling, ",", ".")
            content.AssignValue("max_targeting", Replace(max_targeting, ",", ".")
            content.AssignValue("max_damages", Replace(max_damages, ",", ".")
            content.AssignValue("max_signature", Replace(max_signature, ",", ".")

            content.AssignValue("max_build", Replace(max_build, ",", ".")
            content.AssignValue("max_ship", Replace(max_ship, ",", ".")

            content.AssignValue("max_recycling", Replace(max_recycling, ",", ".")

        content.Parse("editcommander"

        return self.Display(content)

    def Max(self, a,b):
        if a<b:
            Max=b
        else:
            Max=a

    def EditCommander(self, CommanderId):

        ore = max(0, ToInt(request.POST.get("ore"), 0))
        hydrocarbon = max(0, ToInt(request.POST.get("hydrocarbon"), 0))
        energy = max(0, ToInt(request.POST.get("energy"), 0))
        workers = max(0, ToInt(request.POST.get("workers"), 0))

        fleetspeed = max(0, ToInt(request.POST.get("fleet_speed"), 0))
        fleetshield = max(0, ToInt(request.POST.get("fleet_shield"), 0))
        fleethandling = max(0, ToInt(request.POST.get("fleet_handling"), 0))
        fleettargeting = max(0, ToInt(request.POST.get("fleet_targeting"), 0))
        fleetdamages = max(0, ToInt(request.POST.get("fleet_damages"), 0))
        fleetsignature = max(0, ToInt(request.POST.get("fleet_signature"), 0))

        build = max(0, ToInt(request.POST.get("buildindspeed"), 0))
        ship = max(0, ToInt(request.POST.get("shipconstructionspeed"), 0))

        total = ore + hydrocarbon + energy + workers + fleetspeed + fleetshield + fleethandling + fleettargeting + fleetdamages + fleetsignature + build + ship

        query = "UPDATE commanders SET" + \
                "    mod_production_ore=mod_production_ore + 0.01*" + ore + \
                "    ,mod_production_hydrocarbon=mod_production_hydrocarbon + 0.01*" + hydrocarbon + \
                "    ,mod_production_energy=mod_production_energy + 0.1*" + energy + \
                "    ,mod_production_workers=mod_production_workers + 0.1*" + workers + \
                "    ,mod_fleet_speed=mod_fleet_speed + 0.02*" + fleetspeed + \
                "    ,mod_fleet_shield=mod_fleet_shield + 0.02*" + fleetshield + \
                "    ,mod_fleet_handling=mod_fleet_handling + 0.05*" + fleethandling + \
                "    ,mod_fleet_tracking_speed=mod_fleet_tracking_speed + 0.05*" + fleettargeting + \
                "    ,mod_fleet_damage=mod_fleet_damage + 0.02*" + fleetdamages + \
                "    ,mod_fleet_signature=mod_fleet_signature + 0.02*" + fleetsignature + \
                "    ,mod_construction_speed_buildings=mod_construction_speed_buildings + 0.05*" + build + \
                "    ,mod_construction_speed_ships=mod_construction_speed_ships + 0.05*" + ship + \
                "    ,points=points-" + total + \
                " WHERE ownerid=" + str(self.UserId) + " AND id=" + CommanderId + " AND points >= " + total
        oConn.BeginTrans

        oConnDoQuery(query)

        query = "SELECT mod_production_ore, mod_production_hydrocarbon, mod_production_energy," + \
                    " mod_production_workers, mod_fleet_speed, mod_fleet_shield, mod_fleet_handling," + \
                    " mod_fleet_tracking_speed, mod_fleet_damage, mod_fleet_signature," + \
                    " mod_construction_speed_buildings, mod_construction_speed_ships" + \
                    " FROM commanders" + \
                    " WHERE id=" + CommanderId + " AND ownerid=" + str(self.UserId)
        oRs = oConnExecute(query)

        if oRs[0] <= max_ore+0.0001 and oRs[1] <= max_hydrocarbon+0.0001 and oRs[2] <= max_energy+0.0001 and oRs[3] <= max_workers+0.0001 and _
            oRs[4] <= max_speed+0.0001 and oRs[5] <= max_shield+0.0001 and oRs[6] <= max_handling+0.0001 and oRs[7] <= max_targeting+0.0001 and oRs[8] <= max_damages+0.0001 and oRs[9] <= max_signature+0.0001 and _
            oRs[10] <= max_build+0.0001 and oRs[11] <= max_ship+0.0001:

            oConn.CommitTrans

            query = "SELECT sp_update_fleet_bonus(id) FROM fleets WHERE commanderid=" + CommanderId
            oConnDoQuery(query)

            query = "SELECT sp_update_planet(id) FROM nav_planet WHERE commanderid=" + CommanderId
            oConnDoQuery(query)
        else:
            oConn.RollbackTrans

        redirectTo "commanders.asp"

    def RenameCommander(self, CommanderId, NewName):

        query = "SELECT sp_commanders_rename(" + str(self.UserId) + "," + CommanderId + "," + dosql(NewName) + ")"
        oConnDoQuery(query)
        redirectTo "commanders.asp"

    def EngageCommander(self, CommanderId):

        query = "SELECT sp_commanders_engage(" + str(self.UserId) + "," + CommanderId + ")"
        oConnDoQuery(query)
        redirectTo "commanders.asp"

    def FireCommander(self, CommanderId):

        query = "SELECT sp_commanders_fire(" + str(self.UserId) + "," + CommanderId + ")"
        oConnDoQuery(query)
        redirectTo "commanders.asp"

    def TrainCommander(self, CommanderId):

        query = "SELECT sp_commanders_train(" + str(self.UserId) + "," + CommanderId + ")"
        oConnDoQuery(query)
        redirectTo "commanders.asp"

