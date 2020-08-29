# -*- coding: utf-8 -*-

from web_game.game._global import *

class View(GlobalView):

    def dispatch(self, request, *args, **kwargs):

        response = super().pre_dispatch(request, *args, **kwargs)
        if response: return response

        from web_game.lib.accounts import *

        self.selected_menu = "fleets"

        const e_no_error = 0

        const e_bad_name = 1
        const e_already_exists = 2
        const e_occupied = 3
        const e_limit_reached = 4

        fleetid = ToInt(request.GET.get("id"), 0)

        if fleetid == 0:
            return HttpResponseRedirect("/game/fleets/")

        ExecuteOrder(fleetid)

        return self.DisplayExchangeForm(fleetid)

    # display fleet info
    def DisplayExchangeForm(self, fleetid):

        if session(sprivilege) > 100:
        content = GetTemplate(self.request, "fleet-split")
        else:
        content = GetTemplate(self.request, "fleet-split_old")

        # retrieve fleet name, size, position, destination
        query = "SELECT id, name, attackonsight, engaged, size, signature, speed, remaining_time, commanderid, commandername," + \
                " planetid, planet_name, planet_galaxy, planet_sector, planet_planet, planet_ownerid, planet_owner_name, planet_owner_relation," + \
                " cargo_capacity, cargo_ore, cargo_hydrocarbon, cargo_scientists, cargo_soldiers, cargo_workers," + \
                " action " + \
                " FROM vw_fleets" + \
                " WHERE ownerid="+str(self.UserId)+" AND id="+str(fleetid)

        oRs = oConnExecute(query)

        # if fleet doesn't exist, redirect to the list of fleets
        if oRs == None: 'or session("privilege") <100:
            return HttpResponseRedirect("/game/fleets/")

        # if fleet is moving or engaged, go back to the fleets
        if oRs[24] != 0:
            return HttpResponseRedirect("/game/fleet/?id=" + str(fleetid))

        content.AssignValue("fleetid", fleetid
        content.AssignValue("fleetname", oRs[1]
        content.AssignValue("size", oRs[4]
        content.AssignValue("speed", oRs[6]

        content.AssignValue("fleet_capacity", oRs[18]
        content.AssignValue("available_ore", oRs[19]
        content.AssignValue("available_hydrocarbon", oRs[20]
        content.AssignValue("available_scientists", oRs[21]
        content.AssignValue("available_soldiers", oRs[22]
        content.AssignValue("available_workers", oRs[23]

        content.AssignValue("fleet_load", oRs[19] + oRs[20] + oRs[21] + oRs[22] + oRs[23]

        shipCount = 0
        # retrieve the list of ships in the fleet
        query = "SELECT db_ships.id, db_ships.label, db_ships.capacity, db_ships.signature," + \
                    "COALESCE((SELECT quantity FROM fleets_ships WHERE fleetid=" + str(fleetid) + " AND shipid = db_ships.id), 0)" + \
                " FROM fleets_ships" + \
                "    INNER JOIN db_ships ON (db_ships.id=fleets_ships.shipid)" + \
                " WHERE fleetid=" + str(fleetid) + \
                " ORDER BY db_ships.category, db_ships.label"

        oRss = oConnExecuteAll(query)

        list = []
        for oRs in oRss:
            item = {}
            list.append(item)
            
            shipCount = shipCount + 1
            item["id", oRs[0]
            item["name", oRs[1]
            item["cargo_capacity", oRs[2]
            item["signature", oRs[3]
            item["quantity", oRs[4]

            if fleet_split_error != e_no_error:
                item["transfer", request.POST.get("transfership"+oRs[0])

            content.Parse("ship"

        if fleet_split_error != e_no_error:
            content.Parse("error"+fleet_split_error
            item["t_ore", request.POST.get("load_ore")
            item["t_hydrocarbon", request.POST.get("load_hydrocarbon")
            item["t_scientists", request.POST.get("load_scientists")
            item["t_workers", request.POST.get("load_workers")
            item["t_soldiers", request.POST.get("load_soldiers")

        return self.Display(content)

    # split current fleet into 2 fleets
    def SplitFleet(self, fleetid):

        newfleetname = request.POST.get("newname")

        if not isValidObjectName(newfleetname):
            fleet_split_error = e_bad_name
            return

        #
        # retrieve the planet where the current fleet is patrolling
        #
        query = "SELECT planetid FROM vw_fleets WHERE ownerid="+str(self.UserId)+" AND id="+str(fleetid)
        oRs = oConnExecute(query)
        if oRs == None:    return

        fleetplanetid = int(oRs[0])

        oRs.Close
        oRs = Nothing

        #
        # retrieve 'source# fleet cargo and action
        #
        query = " SELECT id, action, cargo_ore, cargo_hydrocarbon, " + \
                " cargo_scientists, cargo_soldiers, cargo_workers" + \
                " FROM vw_fleets" + \
                " WHERE ownerid="+str(self.UserId)+" AND id="+str(fleetid)
        oRs = oConnExecute(query)

        if oRs.EOF or (oRs[1] != 0):
            fleet_split_error = e_occupied
            return

        ore = Min( ToInt(request.POST.get("load_ore"), 0), oRs[2] )
        hydrocarbon = Min( ToInt(request.POST.get("load_hydrocarbon"), 0), oRs[3] )
        scientists = Min( ToInt(request.POST.get("load_scientists"), 0), oRs[4] )
        soldiers = Min( ToInt(request.POST.get("load_soldiers"), 0), oRs[5] )
        workers = Min( ToInt(request.POST.get("load_workers"), 0), oRs[6] )

        oRs.Close
        oRs = Nothing

        #
        # begin transaction
        #
        oConn.BeginTrans

        On Error Resume Next
        err.clear

        #
        # 1/ create a new fleet at the current fleet planet with the given name
        #
        oRs = oConnExecute("SELECT sp_create_fleet(" + str(self.UserId) + "," + fleetplanetid + "," + dosql(newfleetname) + ")")
        if oRs == None:
            oConn.RollbackTrans
            return

        newfleetid = int(oRs[0])

        if newfleetid < 0:
            if newfleetid = -1:
                fleet_split_error = e_already_exists

            if newfleetid = -2:
                fleet_split_error = e_already_exists

            if newfleetid = -3:
                fleet_split_error = e_limit_reached

            oConn.RollbackTrans
            return

        #
        # 2/ add the ships to the new fleet
        #

        # retrieve ships belonging to current fleet
        query = "SELECT db_ships.id, " + \
                    "COALESCE((SELECT quantity FROM fleets_ships WHERE fleetid=" + str(fleetid) + " AND shipid = db_ships.id), 0)" + \
                " FROM db_ships" + \
                " ORDER BY db_ships.category, db_ships.label"
        oRs = oConnExecute(query)

        if oRs == None:
            availableCount = -1
        else:
            availableArray = oRs.GetRows()
            availableCount = UBound(availableArray, 2)

        # for each available ship id, check if the player wants to add ships of this kind
        for i = 0 to availableCount
            shipid = availableArray(0,i)

            quantity = Min( ToInt(request.POST.get("transfership" + shipid), 0), availableArray(1,i) )

            if quantity > 0:
                # add the ships to the new fleet
                query = " INSERT INTO fleets_ships (fleetid, shipid, quantity)" + \
                        " VALUES (" + newfleetid +","+ shipid +","+ quantity + ")"
                oConnDoQuery(query)

        # reset fleets idleness, partly to prevent cheating and being able to do multiple invasions with only a fleet
        oConnDoQuery("UPDATE fleets SET idle_since=now()" + \
                        " WHERE ownerid =" + str(self.UserId) + " AND (id="+newfleetid+" OR id="+str(fleetid)+")")

        #
        # 3/ Move the resources to the new fleet
        #   a/ Add resources to the new fleet
        #   b/ Remove resource from the 'source# fleet
        #

        # retrieve new fleet's cargo capacity
        oRs = oConnExecute("SELECT cargo_capacity FROM vw_fleets WHERE ownerid="+str(self.UserId)+" AND id="+newfleetid)
        if Err.Number != 0:
                oConn.RollbackTrans
                return

        newload = oRs[0]

        ore = Min( ore, newload)
        newload = newload - ore

        hydrocarbon = Min( hydrocarbon, newload)
        newload = newload - hydrocarbon

        scientists = Min( scientists, newload)
        newload = newload - scientists

        soldiers = Min( soldiers, newload)
        newload = newload - soldiers

        workers = Min( workers, newload)
        newload = newload - workers

        if ore != 0 or hydrocarbon != 0 or scientists != 0 or soldiers != 0 or workers != 0:
            # a/ put the resources to the new fleet
            oConnDoQuery("UPDATE fleets SET" + \
                        " cargo_ore="+ore+", cargo_hydrocarbon="+hydrocarbon+", " + \
                        " cargo_scientists="+scientists+", cargo_soldiers="+soldiers+", " + \
                        " cargo_workers="+workers + \
                        " WHERE id =" + newfleetid + " AND ownerid =" + str(self.UserId))
            if Err.Number != 0:
                oConn.RollbackTrans
                return

            # b/ remove the resources from the 'source# fleet
            oConnDoQuery("UPDATE fleets SET" + \
                        " cargo_ore=cargo_ore-"+ore+", cargo_hydrocarbon=cargo_hydrocarbon-"+hydrocarbon+", " + \
                        " cargo_scientists=cargo_scientists-"+scientists+", " + \
                        " cargo_soldiers=cargo_soldiers-"+soldiers+", " + \
                        " cargo_workers=cargo_workers-"+workers + \
                        " WHERE id =" + str(fleetid) + " AND ownerid =" + str(self.UserId))
            if Err.Number != 0:
                oConn.RollbackTrans
                return

        #
        # 4/ Remove the ships from the 'source# fleet
        #
        for i = 0 to availableCount
            shipid = availableArray(0,i)

            quantity = Min( ToInt(request.POST.get("transfership" + shipid), 0), availableArray(1,i) )

            if quantity > 0:
                # remove the ships from the 'source# fleet
                query = " UPDATE fleets_ships SET" + \
                        " quantity=quantity-" + quantity + \
                        " WHERE fleetid=" + str(fleetid) + " AND shipid=" + shipid
                oConnDoQuery(query)

                if Err.Number != 0:
                    oConn.RollbackTrans
                    return

        query = "DELETE FROM fleets WHERE ownerid=" + str(self.UserId) + " AND size=0"
        oConnDoQuery(query)

        oConn.CommitTrans
        return HttpResponseRedirect("/game/fleet/?id="+newfleetid)

    def ExecuteOrder(self, fleetid):
        if request.POST.get("split") == "1":
            SplitFleet fleetid
