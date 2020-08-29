# -*- coding: utf-8 -*-

from web_game.game._global import *

class View(GlobalView):

    def dispatch(self, request, *args, **kwargs):

        response = super().pre_dispatch(request, *args, **kwargs)
        if response: return response

        self.selected_menu = "fleets"

        const e_no_error = 0
        const e_bad_destination = 1

        fleet_error = e_no_error
        fleet_planet = 0

        fleetid = request.GET.get("id", "")

        if fleetid == None or fleetid == "":
            return HttpResponseRedirect("/game/fleets/")

        fleetid = int(fleetid)

        ExecuteOrder(fleetid)

        DisplayFleet(fleetid)

    # display fleet info
    def DisplayFleet(self, fleetid):

        content = GetTemplate(self.request, "fleet-ships")

        # retrieve fleet name, size, position, destination
        query = "SELECT id, name, attackonsight, engaged, size, signature, speed, remaining_time, commanderid, commandername," + \
                " planetid, planet_name, planet_galaxy, planet_sector, planet_planet, planet_ownerid, planet_owner_name, planet_owner_relation," + \
                " cargo_capacity, cargo_ore, cargo_hydrocarbon, cargo_scientists, cargo_soldiers, cargo_workers" + \
                " FROM vw_fleets WHERE ownerid="+str(self.UserId)+" AND id="+str(fleetid)

        oRs = oConnExecute(query)

        # if fleet doesn't exist, redirect to the list of fleets
        if oRs == None:
            return HttpResponseRedirect("/game/fleets/")

        # if fleet is moving or engaged, go back to the fleets
        if oRs[7] or oRs[3]:
            return HttpResponseRedirect("/game/fleet/?id=" + str(fleetid))

        content.AssignValue("fleetid", fleetid
        content.AssignValue("fleetname", oRs[1]
        content.AssignValue("size", oRs[4]
        content.AssignValue("speed", oRs[6]

        content.AssignValue("fleet_capacity", oRs[18]
        content.AssignValue("fleet_load", oRs[19] + oRs[20] + oRs[21] + oRs[22] + oRs[23]

        shipCount = 0

        if oRs[17] = rSelf:
            # retrieve the list of ships in the fleet
            query = "SELECT db_ships.id, db_ships.capacity," + \
                    "COALESCE((SELECT quantity FROM fleets_ships WHERE fleetid=" + str(fleetid) + " AND shipid = db_ships.id), 0)," + \
                    "COALESCE((SELECT quantity FROM planet_ships WHERE planetid=(SELECT planetid FROM fleets WHERE id=" + str(fleetid) + ") AND shipid = db_ships.id), 0)" + \
                    " FROM db_ships" + \
                    " ORDER BY db_ships.category, db_ships.label"

            oRss = oConnExecuteAll(query)

            list = []
            for oRs in oRss:
                if oRs[2] > 0 or oRs[3] > 0:
                    item = {}
                    list.append(item)
            
                    shipCount = shipCount + 1

                    item["id", oRs[0]
                    item["name", getShipLabel(oRs[0])
                    item["cargo_capacity", oRs[1]
                    item["quantity", oRs[2]
                    item["available", oRs[3]

                    content.Parse("ship"

            content.Parse("shiplist.can_manage"

        content.Parse("shiplist"

        return self.Display(content)

    # Transfer ships between the planet and the fleet
    def TransferShips(self, fleetid):

        ShipsRemoved = 0

        # if units are removed, the fleet may be destroyed so retrieve the planetid where the fleet is
        if fleet_planet == 0:
            oRs = oConnExecute("SELECT planetid FROM fleets WHERE id=" + str(fleetid))

            if oRs == None:
                fleet_planet = -1
            else:
                fleet_planet = oRs[0]

        # retrieve the list of all existing ships
        oRs = oConnExecute("SELECT id FROM db_ships")

        if oRs == None:
            shipsCount = -1
        else:
            shipsArray = oRs.GetRows()
            shipsCount = UBound(shipsArray, 2)

        # for each ship id, check if the player wants to add ships of this kind
        for i = 0 to shipsCount
            shipid = shipsArray(0,i)

            quantity = ToInt(request.POST.get("addship" + shipid), 0)

            if quantity > 0:
                oConnExecute("SELECT sp_transfer_ships_to_fleet(" + str(self.UserId) + "," + str(fleetid) + "," + shipid + "," + quantity + ")")

        # for each ship id, check if the player wants to remove ships of this kind
        for i = 0 to shipsCount
            shipid = shipsArray(0,i)

            quantity = ToInt(request.POST.get("removeship" + shipid), 0)
            if quantity > 0:
                ShipsRemoved = ShipsRemoved + quantity
                oConnExecute("SELECT sp_transfer_ships_to_planet(" + str(self.UserId) + "," + str(fleetid) + "," + shipid + "," + quantity + ")")

        if ShipsRemoved > 0:
            oRs = oConnExecute("SELECT id FROM fleets WHERE id=" + str(fleetid))

            if oRs == None:
                if fleet_planet > 0:
                    return HttpResponseRedirect("/game/orbit/?planet=" + str(fleet_planet))
                else:
                    return HttpResponseRedirect("/game/fleets/")

    def ExecuteOrder(self, fleetid):
        if request.POST.get("transfer_ships") == 1:
            self.TransferShips(fleetid)
