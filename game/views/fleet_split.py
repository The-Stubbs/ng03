# -*- coding: utf-8 -*-

from game.views._base import *

#-------------------------------------------------------------------------------
class View(BaseView):

    def dispatch(self, request, *args, **kwargs):

        response = super().pre_dispatch(request, *args, **kwargs)
        if response: return response

        self.selected_menu = "gm_fleets"

        self.fleet_split_error = 0
        self.e_no_error = 0

        self.e_bad_name = 1
        self.e_already_exists = 2
        self.e_occupied = 3
        self.e_limit_reached = 4

        fleetid = ToInt(request.GET.get("id"), 0)

        if fleetid == 0:
            return HttpResponseRedirect("/game/gm_fleets/")

        response = self.ExecuteOrder(fleetid)
        if response: return response
        
        return self.DisplayExchangeForm(fleetid)

    # display fleet info
    def DisplayExchangeForm(self, fleetid):

        if self.request.session.get(sPrivilege) > 100:
            content = self.loadTemplate("fleet-split")
        else:
            content = self.loadTemplate("fleet-split-old")

        # retrieve fleet name, size, position, destination
        query = "SELECT id, name, attackonsight, engaged, size, signature, speed, remaining_time, commanderid, commandername," + \
                " planetid, planet_name, planet_galaxy, planet_sector, planet_planet, planet_ownerid, planet_owner_name, planet_owner_relation," + \
                " cargo_capacity, cargo_ore, cargo_hydro, cargo_scientists, cargo_soldiers, cargo_workers," + \
                " action " + \
                " FROM vw_gm_fleets" + \
                " WHERE ownerid="+str(self.userId)+" AND id="+str(fleetid)

        row = dbRow(query)

        # if fleet doesn't exist, redirect to the list of gm_fleets
        if row == None:
            return HttpResponseRedirect("/game/gm_fleets/")

        # if fleet is moving or engaged, go back to the gm_fleets
        if row[24] != 0:
            return HttpResponseRedirect("/game/fleet/?id=" + str(fleetid))

        content.AssignValue("fleetid", fleetid)
        content.AssignValue("fleetname", row[1])
        content.AssignValue("size", row[4])
        content.AssignValue("speed", row[6])

        content.AssignValue("fleet_capacity", row[18])
        content.AssignValue("available_ore", row[19])
        content.AssignValue("available_hydro", row[20])
        content.AssignValue("available_scientists", row[21])
        content.AssignValue("available_soldiers", row[22])
        content.AssignValue("available_workers", row[23])

        content.AssignValue("fleet_load", row[19] + row[20] + row[21] + row[22] + row[23])

        shipCount = 0
        # retrieve the list of ships in the fleet
        query = "SELECT dt_ships.id, dt_ships.label, dt_ships.capacity, dt_ships.signature," + \
                    "COALESCE((SELECT quantity FROM gm_fleet_ships WHERE fleetid=" + str(fleetid) + " AND shipid = dt_ships.id), 0)" + \
                " FROM gm_fleet_ships" + \
                "    INNER JOIN dt_ships ON (dt_ships.id=gm_fleet_ships.shipid)" + \
                " WHERE fleetid=" + str(fleetid) + \
                " ORDER BY dt_ships.category, dt_ships.label"

        rows = dbRows(query)

        list = []
        content.AssignValue("ships", list)
        for row in rows:
            item = {}
            list.append(item)
            
            shipCount = shipCount + 1
            item["id"] = row[0]
            item["name"] = row[1]
            item["cargo_capacity"] = row[2]
            item["signature"] = row[3]
            item["quantity"] = row[4]

            if self.fleet_split_error != self.e_no_error:
                item["transfer"] = self.request.POST.get("transfership"+str(row[0]))

        if self.fleet_split_error != self.e_no_error:
            content.Parse("error"+str(self.fleet_split_error))
            item["t_ore"] = self.request.POST.get("load_ore")
            item["t_hydro"] = self.request.POST.get("load_hydro")
            item["t_scientists"] = self.request.POST.get("load_scientists")
            item["t_workers"] = self.request.POST.get("load_workers")
            item["t_soldiers"] = self.request.POST.get("load_soldiers")

        return self.display(content)

    # split current fleet into 2 gm_fleets
    def SplitFleet(self, fleetid):

        newfleetname = self.request.POST.get("newname")

        if not isValidObjectName(newfleetname):
            self.fleet_split_error = self.e_bad_name
            return

        #
        # retrieve the planet where the current fleet is patrolling
        #
        query = "SELECT planetid FROM vw_gm_fleets WHERE ownerid="+str(self.userId)+" AND id="+str(fleetid)
        row = dbRow(query)
        if row == None: return

        fleetplanetid = int(row[0])

        #
        # retrieve 'source' fleet cargo and action
        #
        query = " SELECT id, action, cargo_ore, cargo_hydro, " + \
                " cargo_scientists, cargo_soldiers, cargo_workers" + \
                " FROM vw_gm_fleets" + \
                " WHERE ownerid="+str(self.userId)+" AND id="+str(fleetid)
        row = dbRow(query)

        if row == None or (row[1] != 0):
            self.fleet_split_error = self.e_occupied
            return

        ore = min( ToInt(self.request.POST.get("load_ore"), 0), row[2] )
        hydro = min( ToInt(self.request.POST.get("load_hydro"), 0), row[3] )
        scientists = min( ToInt(self.request.POST.get("load_scientists"), 0), row[4] )
        soldiers = min( ToInt(self.request.POST.get("load_soldiers"), 0), row[5] )
        workers = min( ToInt(self.request.POST.get("load_workers"), 0), row[6] )

        #
        # begin transaction
        #
        #
        # 1/ create a new fleet at the current fleet planet with the given name
        #
        row = dbRow("SELECT user_fleet_create(" + str(self.userId) + "," + str(fleetplanetid) + "," + sqlStr(newfleetname) + ")")
        if row == None:
            return

        newfleetid = int(row[0])

        if newfleetid < 0:
            if newfleetid == -1:
                self.fleet_split_error = self.e_already_exists

            if newfleetid == -2:
                self.fleet_split_error = self.e_already_exists

            if newfleetid == -3:
                self.fleet_split_error = self.e_limit_reached

            return

        #
        # 2/ add the ships to the new fleet
        #

        # retrieve ships belonging to current fleet
        query = "SELECT dt_ships.id, " + \
                    "COALESCE((SELECT quantity FROM gm_fleet_ships WHERE fleetid=" + str(fleetid) + " AND shipid = dt_ships.id), 0)" + \
                " FROM dt_ships" + \
                " ORDER BY dt_ships.category, dt_ships.label"
        availableArray = dbRows(query)

        # for each available ship id, check if the player wants to add ships of this kind
        for i in availableArray:
            shipid = i[0]

            quantity = min( ToInt(self.request.POST.get("transfership" + str(shipid)), 0), i[1] )

            if quantity > 0:
                # add the ships to the new fleet
                query = " INSERT INTO gm_fleet_ships (fleetid, shipid, quantity)" + \
                        " VALUES (" + str(newfleetid) +","+ str(shipid) +","+ str(quantity) + ")"
                dbExecute(query)

        # reset gm_fleets idleness, partly to prevent cheating and being able to do multiple gm_invasions with only a fleet
        dbExecute("UPDATE gm_fleets SET idle_since=now()" + \
                        " WHERE ownerid =" + str(self.userId) + " AND (id="+str(newfleetid)+" OR id="+str(fleetid)+")")

        #
        # 3/ Move the resources to the new fleet
        #   a/ Add resources to the new fleet
        #   b/ Remove resource from the 'source# fleet
        #

        # retrieve new fleet's cargo capacity
        row = dbRow("SELECT cargo_capacity FROM vw_gm_fleets WHERE ownerid="+str(self.userId)+" AND id="+str(newfleetid))
        if row == None:
                return

        newload = row[0]

        ore = min( ore, newload)
        newload = newload - ore

        hydro = min( hydro, newload)
        newload = newload - hydro

        scientists = min( scientists, newload)
        newload = newload - scientists

        soldiers = min( soldiers, newload)
        newload = newload - soldiers

        workers = min( workers, newload)
        newload = newload - workers

        if ore != 0 or hydro != 0 or scientists != 0 or soldiers != 0 or workers != 0:
            # a/ put the resources to the new fleet
            dbExecute("UPDATE gm_fleets SET" + \
                        " cargo_ore="+str(ore)+", cargo_hydro="+str(hydro)+"," + \
                        " cargo_scientists="+str(scientists)+", cargo_soldiers="+str(soldiers)+"," + \
                        " cargo_workers="+str(workers) + \
                        " WHERE id =" + str(newfleetid) + " AND ownerid =" + str(self.userId))

            # b/ remove the resources from the 'source# fleet
            dbExecute("UPDATE gm_fleets SET" + \
                        " cargo_ore=cargo_ore-"+str(ore)+", cargo_hydro=cargo_hydro-"+str(hydro)+"," + \
                        " cargo_scientists=cargo_scientists-"+str(scientists)+"," + \
                        " cargo_soldiers=cargo_soldiers-"+str(soldiers)+"," + \
                        " cargo_workers=cargo_workers-"+str(workers) + \
                        " WHERE id =" + str(fleetid) + " AND ownerid =" + str(self.userId))

        #
        # 4/ Remove the ships from the 'source# fleet
        #
        for i in availableArray:
            shipid = i[0]

            quantity = min( ToInt(self.request.POST.get("transfership" + str(shipid)), 0), i[1] )

            if quantity > 0:
                # remove the ships from the 'source# fleet
                query = " UPDATE gm_fleet_ships SET" + \
                        " quantity=quantity-" + str(quantity) + \
                        " WHERE fleetid=" + str(fleetid) + " AND shipid=" + str(shipid)
                dbExecute(query)

        query = "DELETE FROM gm_fleets WHERE ownerid=" + str(self.userId) + " AND size=0"
        dbExecute(query)

        return HttpResponseRedirect("/game/fleet/?id="+str(newfleetid))

    def ExecuteOrder(self, fleetid):
        if self.request.POST.get("split") == "1":
            return self.SplitFleet(fleetid)
