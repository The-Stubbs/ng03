# -*- coding: utf-8 -*-

from game.views._base import *

#-------------------------------------------------------------------------------
class View(BaseView):

    success_url = "/game/fleet-ships/"
    template_name = "fleet-ships"
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

        if action == "transfer":
        
            id = ToInt(request.GET.get("id"), 0)

            ShipsRemoved = 0

            row = dbRow("SELECT planetid FROM gm_fleets WHERE id=" + str(id))
            if row == None: fleet_planet = -1
            else: fleet_planet = row[0]

            shipsArray = dbRows("SELECT id FROM dt_ships")
            for i in shipsArray:
            
                shipid = i[0]
                quantity = ToInt(request.POST.get("addship" + str(shipid)), 0)
                if quantity > 0:
                
                    dbRow("SELECT user_planet_transfer_ships(" + str(self.userId) + "," + str(id) + "," + str(shipid) + "," + str(quantity) + ")")

            for i in shipsArray:
            
                shipid = i[0]
                quantity = ToInt(self.request.POST.get("removeship" + str(shipid)), 0)
                if quantity > 0:
                
                    ShipsRemoved = ShipsRemoved + quantity
                    dbRow("SELECT user_fleet_transfer_ships(" + str(self.userId) + "," + str(id) + "," + str(shipid) + "," + str(quantity) + ")")

            if ShipsRemoved > 0:
            
                row = dbRow("SELECT id FROM gm_fleets WHERE id=" + str(fleetid))
                if row == None:
                
                    if fleet_planet > 0: self.success_url = "/game/orbit/?planet=" + str(self.fleet_planet)
                    else: self.success_url = "/game/gm_fleets/"
                    
            return 0

    #---------------------------------------------------------------------------
    def fillContent(self, request, data):

        # --- fleet data
        
        id = ToInt(request.GET.get("id"), 0)
        
        query = "SELECT id, name, attackonsight, engaged, size, signature, speed, remaining_time, commanderid, commandername," + \
                " planetid, planet_name, planet_galaxy, planet_sector, planet_planet, planet_ownerid, planet_owner_name, planet_owner_relation," + \
                " cargo_capacity, cargo_ore, cargo_hydro, cargo_scientists, cargo_soldiers, cargo_workers" + \
                " FROM vw_gm_fleets WHERE ownerid=" + str(self.userId) + " AND id=" + str(id)
        row = dbRow(query)

        data["id"] = id
        data["name"] = row[1]
        data["size"] = row[4]
        data["speed"] = row[6]
        data["cargo"] = row[18]
        data["load"] = row[19] + row[20] + row[21] + row[22] + row[23]

        # --- fleet & planet ships data
        
        data["ships"] = []
        
        if row[17] == rSelf:
            
            query = "SELECT dt_ships.id, dt_ships.capacity," + \
                    "COALESCE((SELECT quantity FROM gm_fleet_ships WHERE fleetid=" + str(fleetid) + " AND shipid = dt_ships.id), 0)," + \
                    "COALESCE((SELECT quantity FROM gm_planet_ships WHERE planetid=(SELECT planetid FROM gm_fleets WHERE id=" + str(fleetid) + ") AND shipid = dt_ships.id), 0)" + \
                    " FROM dt_ships" + \
                    " ORDER BY dt_ships.category, dt_ships.label"
            rows = dbRows(query)
            if rows:
                for row in rows:
                    if row[2] > 0 or row[3] > 0:
                    
                        ship = {}
                        data["ships"].append(ship)

                        ship["id"] = row[0]
                        ship["name"] = getShipLabel(row[0])
                        ship["cargo"] = row[1]
                        ship["quantity"] = row[2]
                        ship["available"] = row[3]
