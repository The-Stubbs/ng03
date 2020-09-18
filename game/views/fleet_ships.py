# -*- coding: utf-8 -*-

from game.views._base import *

#-------------------------------------------------------------------------------
class View(BaseView):

    def dispatch(self, request, *args, **kwargs):

        response = super().pre_dispatch(request, *args, **kwargs)
        if response: return response

        self.selected_menu = "gm_fleets"

        self.e_no_error = 0
        self.e_bad_destination = 1

        self.fleet_error = self.e_no_error
        self.fleet_planet = 0

        fleetid = request.GET.get("id", "")

        if fleetid == None or fleetid == "":
            return HttpResponseRedirect("/game/gm_fleets/")

        fleetid = int(fleetid)

        response = self.ExecuteOrder(fleetid)
        if response: return response

        return self.DisplayFleet(fleetid)

    # display fleet info
    def DisplayFleet(self, fleetid):

        content = self.loadTemplate("fleet-ships")

        # retrieve fleet name, size, position, destination
        query = "SELECT id, name, attackonsight, engaged, size, signature, speed, remaining_time, commanderid, commandername," + \
                " planetid, planet_name, planet_galaxy, planet_sector, planet_planet, planet_ownerid, planet_owner_name, planet_owner_relation," + \
                " cargo_capacity, cargo_ore, cargo_hydrocarbon, cargo_scientists, cargo_soldiers, cargo_workers" + \
                " FROM vw_gm_fleets WHERE ownerid="+str(self.userId)+" AND id="+str(fleetid)

        row = dbRow(query)

        # if fleet doesn't exist, redirect to the list of gm_fleets
        if row == None:
            return HttpResponseRedirect("/game/gm_fleets/")

        # if fleet is moving or engaged, go back to the gm_fleets
        if row[7] or row[3]:
            return HttpResponseRedirect("/game/fleet/?id=" + str(fleetid))

        content.AssignValue("fleetid", fleetid)
        content.AssignValue("fleetname", row[1])
        content.AssignValue("size", row[4])
        content.AssignValue("speed", row[6])

        content.AssignValue("fleet_capacity", row[18])
        content.AssignValue("fleet_load", row[19] + row[20] + row[21] + row[22] + row[23])

        shipCount = 0

        if row[17] == rSelf:
            # retrieve the list of ships in the fleet
            query = "SELECT dt_ships.id, dt_ships.capacity," + \
                    "COALESCE((SELECT quantity FROM gm_fleet_ships WHERE fleetid=" + str(fleetid) + " AND shipid = dt_ships.id), 0)," + \
                    "COALESCE((SELECT quantity FROM gm_planet_ships WHERE planetid=(SELECT planetid FROM gm_fleets WHERE id=" + str(fleetid) + ") AND shipid = dt_ships.id), 0)" + \
                    " FROM dt_ships" + \
                    " ORDER BY dt_ships.category, dt_ships.label"

            oRss = dbRows(query)

            list = []
            content.AssignValue("shiplist", list)
            for row in oRss:
                if row[2] > 0 or row[3] > 0:
                    item = {}
                    list.append(item)
            
                    shipCount = shipCount + 1

                    item["id"] = row[0]
                    item["name"] = getShipLabel(row[0])
                    item["cargo_capacity"] = row[1]
                    item["quantity"] = row[2]
                    item["available"] = row[3]

            content.Parse("can_manage")

        return self.display(content)

    # Transfer ships between the planet and the fleet
    def TransferShips(self, fleetid):

        ShipsRemoved = 0

        # if units are removed, the fleet may be destroyed so retrieve the planetid where the fleet is
        if self.fleet_planet == 0:
            row = dbRow("SELECT planetid FROM gm_fleets WHERE id=" + str(fleetid))

            if row == None:
                self.fleet_planet = -1
            else:
                self.fleet_planet = row[0]

        # retrieve the list of all existing ships
        shipsArray = dbRow("SELECT id FROM dt_ships")

        # for each ship id, check if the player wants to add ships of this kind
        for i in shipsArray:
            shipid = i[0]

            quantity = ToInt(self.request.POST.get("addship" + str(shipid)), 0)

            if quantity > 0:
                dbRow("SELECT user_planet_transfer_ships(" + str(self.userId) + "," + str(fleetid) + "," + str(shipid) + "," + str(quantity) + ")")

        # for each ship id, check if the player wants to remove ships of this kind
        for i in shipsArray:
            shipid = i[0]

            quantity = ToInt(self.request.POST.get("removeship" + str(shipid)), 0)
            if quantity > 0:
                ShipsRemoved = ShipsRemoved + quantity
                dbRow("SELECT user_fleet_transfer_ships(" + str(self.userId) + "," + str(fleetid) + "," + str(shipid) + "," + str(quantity) + ")")

        if ShipsRemoved > 0:
            row = dbRow("SELECT id FROM gm_fleets WHERE id=" + str(fleetid))

            if row == None:
                if self.fleet_planet > 0:
                    return HttpResponseRedirect("/game/orbit/?planet=" + str(self.fleet_planet))
                else:
                    return HttpResponseRedirect("/game/gm_fleets/")

    def ExecuteOrder(self, fleetid):
        if ToInt(self.request.POST.get("transfer_ships"), 0) == 1:
            return self.TransferShips(fleetid)
