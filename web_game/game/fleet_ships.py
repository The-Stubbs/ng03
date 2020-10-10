# -*- coding: utf-8 -*-

from web_game.game._global import *



class View(GlobalView):

    def dispatch(self, request, *args, **kwargs):

        response = super().pre_dispatch(request, *args, **kwargs)
        if response: return response
        
        self.fleet_id = ToInt(request.GET.get("id"), 0)
        
        if self.fleet_id == 0: return HttpResponseRedirect("/game/orbit/")
        
        query = " SELECT id" + \
                " FROM vw_fleets as f" + \
                " WHERE ownerid=" + str(self.UserId) + " AND id=" + str(self.fleet_id) + " AND engaged=false AND remaining_time IS NULL AND planet_owner_relation=0"
        oRs = oConnExecute(query)
        
        if oRs == None: return HttpResponseRedirect("/game/fleets/")
        
        return super().dispatch(request, *args, **kwargs)



    def get(self, request, *args, **kwargs):

        self.selected_menu = "fleets"
        
        content = GetTemplate(request, "fleet_ships")

        # --- fleet data
        
        fleet = {}
        content.AssignValue("fleet", fleet)
        
        query = " SELECT id, name, attackonsight, engaged, size, signature, speed, remaining_time, commanderid, commandername," + \
                " planetid, planet_name, planet_galaxy, planet_sector, planet_planet, planet_ownerid, planet_owner_name, planet_owner_relation," + \
                " cargo_capacity, cargo_ore, cargo_hydrocarbon, cargo_scientists, cargo_soldiers, cargo_workers" + \
                " FROM vw_fleets WHERE ownerid=" +str(self.UserId) + " AND id=" + str(self.fleet_id)
        oRs = oConnExecute(query)

        fleet["id"] = oRs[0]
        fleet["name"] = oRs[1]
        content.AssignValue("size", oRs[4])
        content.AssignValue("speed", oRs[6])

        content.AssignValue("fleet_capacity", oRs[18])
        content.AssignValue("fleet_load", oRs[19] + oRs[20] + oRs[21] + oRs[22] + oRs[23])

        # retrieve the list of ships in the fleet
        query = "SELECT db_ships.id, db_ships.capacity," + \
                "COALESCE((SELECT quantity FROM fleets_ships WHERE fleetid=" + str(fleetid) + " AND shipid = db_ships.id), 0)," + \
                "COALESCE((SELECT quantity FROM planet_ships WHERE planetid=(SELECT planetid FROM fleets WHERE id=" + str(fleetid) + ") AND shipid = db_ships.id), 0)" + \
                " FROM db_ships" + \
                " ORDER BY db_ships.category, db_ships.label"

        oRss = oConnExecuteAll(query)

        list = []
        content.AssignValue("shiplist", list)
        for oRs in oRss:
            if oRs[2] > 0 or oRs[3] > 0:
                item = {}
                list.append(item)
        
                shipCount = shipCount + 1

                item["id"] = oRs[0]
                item["name"] = getShipLabel(oRs[0])
                item["cargo_capacity"] = oRs[1]
                item["quantity"] = oRs[2]
                item["available"] = oRs[3]

        content.Parse("can_manage")

        return self.Display(content)

    # Transfer ships between the planet and the fleet
    def TransferShips(self, fleetid):

        ShipsRemoved = 0

        # if units are removed, the fleet may be destroyed so retrieve the planetid where the fleet is
        if self.fleet_planet == 0:
            oRs = oConnExecute("SELECT planetid FROM fleets WHERE id=" + str(fleetid))

            if oRs == None:
                self.fleet_planet = -1
            else:
                self.fleet_planet = oRs[0]

        # retrieve the list of all existing ships
        shipsArray = oConnExecute("SELECT id FROM db_ships")

        # for each ship id, check if the player wants to add ships of this kind
        for i in shipsArray:
            shipid = i[0]

            quantity = ToInt(self.request.POST.get("addship" + str(shipid)), 0)

            if quantity > 0:
                oConnExecute("SELECT sp_transfer_ships_to_fleet(" + str(self.UserId) + "," + str(fleetid) + "," + str(shipid) + "," + str(quantity) + ")")

        # for each ship id, check if the player wants to remove ships of this kind
        for i in shipsArray:
            shipid = i[0]

            quantity = ToInt(self.request.POST.get("removeship" + str(shipid)), 0)
            if quantity > 0:
                ShipsRemoved = ShipsRemoved + quantity
                oConnExecute("SELECT sp_transfer_ships_to_planet(" + str(self.UserId) + "," + str(fleetid) + "," + str(shipid) + "," + str(quantity) + ")")

        if ShipsRemoved > 0:
            oRs = oConnExecute("SELECT id FROM fleets WHERE id=" + str(fleetid))

            if oRs == None:
                if self.fleet_planet > 0:
                    return HttpResponseRedirect("/game/orbit/?planet=" + str(self.fleet_planet))
                else:
                    return HttpResponseRedirect("/game/fleets/")

    def ExecuteOrder(self, fleetid):
        if ToInt(self.request.POST.get("transfer_ships"), 0) == 1:
            return self.TransferShips(fleetid)
