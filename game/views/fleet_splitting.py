# -*- coding: utf-8 -*-

from game.views._base import *

#-------------------------------------------------------------------------------
class View(BaseView):

    success_url = "/game/fleet-splitting/"
    template_name = "fleet-splitting"
    selected_menu = "fleets"

    #---------------------------------------------------------------------------
    def dispatch(self, request, *args, **kwargs):

        response = super().pre_dispatch(request, *args, **kwargs)
        if response: return response
        
        id = ToInt(request.GET.get("id"), 0)
        query = "SELECT id, engaged, remaining_time" + \
                " FROM gm_fleets WHERE ownerid=" + str(self.userId) + " AND id=" + str(id)
        row = dbRow(query)
        if row == None: return HttpResponseRedirect("/game/fleets/")
        if row[1] or row[2]: return HttpResponseRedirect("/game/fleet/?id=" + str(id))
        
        return super().dispatch(request, *args, **kwargs)

    #---------------------------------------------------------------------------
    def processAction(self, request, action):

        if action == "split":
        
            id = ToInt(request.GET.get("id"), 0)

            name = request.POST.get("name")
            if not isValidObjectName(name): return -1

            query = "SELECT planetid FROM vw_gm_fleets WHERE ownerid=" + str(self.userId) + " AND id=" + str(id)
            row = dbRow(query)
            if row == None: return -2
            planetid = int(row[0])

            query = "SELECT id, action, cargo_ore, cargo_hydro, " + \
                    " cargo_scientists, cargo_soldiers, cargo_workers" + \
                    " FROM vw_gm_fleets" + \
                    " WHERE ownerid=" + str(self.userId) + " AND id=" + str(id)
            row = dbRow(query)

            ore = min(ToInt(request.POST.get("load_ore"), 0), row[2])
            hydro = min(ToInt(request.POST.get("load_hydro"), 0), row[3])
            scientists = min(ToInt(request.POST.get("load_scientists"), 0), row[4])
            soldiers = min(ToInt(request.POST.get("load_soldiers"), 0), row[5])
            workers = min(ToInt(request.POST.get("load_workers"), 0), row[6])

            row = dbRow("SELECT user_fleet_create(" + str(self.userId) + "," + str(planetid) + "," + sqlStr(name) + ")")
            if row == None: return -3
            newfleetid = int(row[0])
            
            if newfleetid < 0:
                if newfleetid == -1: return -4
                if newfleetid == -2: return -5
                if newfleetid == -3: return -6

            query = "SELECT dt_ships.id, " + \
                    " COALESCE((SELECT quantity FROM gm_fleet_ships WHERE fleetid=" + str(id) + " AND shipid = dt_ships.id), 0)" + \
                    " FROM dt_ships" + \
                    " ORDER BY dt_ships.category, dt_ships.label"
            rows = dbRows(query)
            for row in rows:
            
                quantity = min(ToInt(request.POST.get("transfership" + str(row[0])), 0), row[1])
                if quantity > 0:

                    query = " INSERT INTO gm_fleet_ships (fleetid, shipid, quantity)" + \
                            " VALUES (" + str(newfleetid) +","+ str(row[0]) +","+ str(quantity) + ")"
                    dbExecute(query)

            dbExecute("UPDATE gm_fleets SET idle_since=now()" + \
                      " WHERE ownerid =" + str(self.userId) + " AND (id=" + str(newfleetid) + " OR id=" + str(id)+")")

            row = dbRow("SELECT cargo_capacity FROM vw_gm_fleets WHERE ownerid=" + str(self.userId) + " AND id=" + str(newfleetid))
            if row == None: return -7

            newload = row[0]

            ore = min(ore, newload)
            newload = newload - ore

            hydro = min(hydro, newload)
            newload = newload - hydro

            scientists = min(scientists, newload)
            newload = newload - scientists

            soldiers = min(soldiers, newload)
            newload = newload - soldiers

            workers = min(workers, newload)
            newload = newload - workers

            if ore != 0 or hydro != 0 or scientists != 0 or soldiers != 0 or workers != 0:

                dbExecute("UPDATE gm_fleets SET" + \
                          " cargo_ore=" + str(ore) + ", cargo_hydro=" + str(hydro) + "," + \
                          " cargo_scientists=" + str(scientists) + ", cargo_soldiers=" + str(soldiers) + "," + \
                          " cargo_workers=" + str(workers) + \
                          " WHERE id =" + str(newfleetid) + " AND ownerid =" + str(self.userId))

                dbExecute("UPDATE gm_fleets SET" + \
                          " cargo_ore=cargo_ore-" + str(ore) + ", cargo_hydro=cargo_hydro-" + str(hydro) + "," + \
                          " cargo_scientists=cargo_scientists-" + str(scientists) + "," + \
                          " cargo_soldiers=cargo_soldiers-" + str(soldiers) + "," + \
                          " cargo_workers=cargo_workers-" + str(workers) + \
                          " WHERE id =" + str(fleetid) + " AND ownerid =" + str(self.userId))

            for row in rows:

                quantity = min(ToInt(request.POST.get("transfership" + str(row[0])), 0), row[1])
                if quantity > 0:

                    query = "UPDATE gm_fleet_ships SET" + \
                            " quantity=quantity-" + str(quantity) + \
                            " WHERE fleetid=" + str(fleetid) + " AND shipid=" + str(row[0])
                    dbExecute(query)

            query = "DELETE FROM gm_fleets WHERE ownerid=" + str(self.userId) + " AND size=0"
            dbExecute(query)

            self.success_url = "/game/fleet/?id=" + str(newfleetid)
            return 0

    #---------------------------------------------------------------------------
    def fillContent(self, request, data):

        # --- fleet data
        
        id = ToInt(request.GET.get("id"), 0)
        
        query = "SELECT id, name, attackonsight, engaged, size, signature, speed, remaining_time, commanderid, commandername," + \
                " planetid, planet_name, planet_galaxy, planet_sector, planet_planet, planet_ownerid, planet_owner_name, planet_owner_relation," + \
                " cargo_capacity, cargo_ore, cargo_hydro, cargo_scientists, cargo_soldiers, cargo_workers," + \
                " action " + \
                " FROM vw_gm_fleets" + \
                " WHERE ownerid=" + str(self.userId) + " AND id=" + str(id)
        row = dbRow(query)

        data["id"] = row[0]
        data["name"] = row[1]
        data["size"] = row[4]
        data["speed"] = row[6]
        data["cargo"] = row[18]
        data["available_ore"] = row[19]
        data["available_hydro"] = row[20]
        data["available_scientists"] = row[21]
        data["available_soldiers"] = row[22]
        data["available_workers"] = row[23]
        data["load"] = row[19] + row[20] + row[21] + row[22] + row[23]

        # --- fleet ships data

        data["ships"] = []
        
        query = "SELECT dt_ships.id, dt_ships.label, dt_ships.capacity, dt_ships.signature," + \
                " COALESCE((SELECT quantity FROM gm_fleet_ships WHERE fleetid=" + str(id) + " AND shipid = dt_ships.id), 0)" + \
                " FROM gm_fleet_ships" + \
                "   INNER JOIN dt_ships ON (dt_ships.id=gm_fleet_ships.shipid)" + \
                " WHERE fleetid=" + str(id) + \
                " ORDER BY dt_ships.category, dt_ships.label"
        rows = dbRows(query)
        for row in rows:
        
            item = {}
            list.append(item)
            
            shipCount = shipCount + 1
            item["id"] = row[0]
            item["name"] = row[1]
            item["cargo_capacity"] = row[2]
            item["signature"] = row[3]
            item["quantity"] = row[4]
            item["transfer"] = request.POST.get("transfership" + str(row[0]))

        # --- form data

        item["t_ore"] = request.POST.get("load_ore")
        item["t_hydro"] = request.POST.get("load_hydro")
        item["t_scientists"] = request.POST.get("load_scientists")
        item["t_workers"] = request.POST.get("load_workers")
        item["t_soldiers"] = request.POST.get("load_soldiers")
