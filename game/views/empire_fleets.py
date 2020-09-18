# -*- coding: utf-8 -*-

from game.views._base import *

#-------------------------------------------------------------------------------
class View(BaseView):

    def dispatch(self, request, *args, **kwargs):

        response = super().pre_dispatch(request, *args, **kwargs)
        if response: return response
        
        action = request.GET.get("a")

        # --- assign category to fleet
        
        if action == "setcat":
            
            oldCat = ToInt(request.GET.get("old"), 0)
            newCat = ToInt(request.GET.get("new"), 0)
            fleetid = ToInt(request.GET.get("id"), 0)

            row = dbRow("SELECT user_fleet_category_assign(" + str(self.userId) + "," + str(fleetid) + "," + str(oldCat) + "," + str(newCat) + ")")
            if row and row[0]:
                
                content = self.loadTemplate("fleets-handler")

                content.AssignValue("id", fleetid)
                content.AssignValue("old", oldCat)
                content.AssignValue("new", newCat)
                
                content.Parse("fleet_category_changed")

                return render(self.request, content.template, content.data)

        # --- create new category
        
        elif action == "newcat":
            
            name = request.GET.get("name")

            content = self.loadTemplate("fleets-handler")

            if self.isValidCategoryName(name):
                row = dbRow("SELECT user_fleet_category_create(" + str(self.userId) + "," + sqlStr(name) + ")")

                if row:
                    content.AssignValue("id", row[0])
                    content.AssignValue("label", name)
                    content.Parse("category")

            else:
                content.Parse("category_name_invalid")

            return render(self.request, content.template, content.data)

        # --- rename category
        
        elif action == "rencat":
            
            name = request.GET.get("name")
            catid = ToInt(request.GET.get("id"), 0)

            content = self.loadTemplate("fleets-handler")

            if name == "":
                row = dbRow("SELECT user_fleet_category_delete(" + str(self.userId) + "," + str(catid) + ")")
                if row:
                    content.AssignValue("id", catid)
                    content.AssignValue("label", name)
                    content.Parse("category")

                    return render(self.request, content.template, content.data)

            elif self.isValidCategoryName(name):
                row = dbRow("SELECT user_fleet_category_rename(" + str(self.userId) + "," + str(catid) + "," + sqlStr(name) + ")")

                if row:
                    content.AssignValue("id", catid)
                    content.AssignValue("label", name)
                    content.Parse("category")

                    return render(self.request, content.template, content.data)

            else:
                content.Parse("category_name_invalid")

                return render(self.request, content.template, content.data)
        
        self.selected_menu = "fleets.fleets"

        content = self.loadTemplate("fleets")

        # --- fleet categories

        categories = []
        content.AssignValue("categories", categories)
        
        query = "SELECT category, label" + \
                " FROM gm_profile_fleet_categories" + \
                " WHERE userid=" + str(self.userId) + \
                " ORDER BY upper(label)"
        oRss = dbRows(query)
        
        if oRss:
            for row in oRss:

                category = {}
                categories.append(category)
                
                category["id"] = row[0]
                category["label"] = row[1]

        # --- fleets

        fleets = []
        content.AssignValue("fleets", fleets)
        
        query = "SELECT id, name, attackonsight, engaged, size, signature, speed, remaining_time, commanderid, commandername," + \
                " planetid, planet_name, planet_galaxy, planet_sector, planet_planet, planet_ownerid, planet_owner_name, planet_owner_relation," + \
                " destplanetid, destplanet_name, destplanet_galaxy, destplanet_sector, destplanet_planet, destplanet_ownerid, destplanet_owner_name, destplanet_owner_relation," + \
                " cargo_capacity, cargo_ore, cargo_hydrocarbon, cargo_scientists, cargo_soldiers, cargo_workers," + \
                " recycler_output, orbit_ore > 0 OR orbit_hydrocarbon > 0, action," + \
                "( SELECT int4(COALESCE(max(gm_planets.radar_strength), 0)) FROM gm_planets WHERE gm_planets.galaxy = f.planet_galaxy AND gm_planets.sector = f.planet_sector AND gm_planets.ownerid IS NOT NULL AND EXISTS ( SELECT 1 FROM vw_gm_friend_radars WHERE vw_gm_friend_radars.friend = gm_planets.ownerid AND vw_gm_friend_radars.userid = " + str(self.userId) + ")) AS from_radarstrength, " + \
                "( SELECT int4(COALESCE(max(gm_planets.radar_strength), 0)) FROM gm_planets WHERE gm_planets.galaxy = f.destplanet_galaxy AND gm_planets.sector = f.destplanet_sector AND gm_planets.ownerid IS NOT NULL AND EXISTS ( SELECT 1 FROM vw_gm_friend_radars WHERE vw_gm_friend_radars.friend = gm_planets.ownerid AND vw_gm_friend_radars.userid = " + str(self.userId) + ")) AS to_radarstrength," + \
                " categoryid" + \
                " FROM vw_gm_fleets as f WHERE ownerid=" + str(self.userId)
        oRss = dbRows(query)
        
        if oRss:
            for row in oRss:
                
                fleet = {}
                fleets.append(fleet)
                
                fleet["id"] = row[0]
                fleet["name"] = row[1]
                fleet["category"] = row[37]
                fleet["size"] = row[4]
                fleet["signature"] = row[5]
                fleet["cargo_load"] = row[27] + row[28] + row[29] + row[30] + row[31]
                fleet["cargo_capacity"] = row[26]
                fleet["cargo_ore"] = row[27]
                fleet["cargo_hydrocarbon"] = row[28]
                fleet["cargo_scientists"] = row[29]
                fleet["cargo_soldiers"] = row[30]
                fleet["cargo_workers"] = row[31]
                fleet["commander_name"] = row[9]
                fleet["action"] = abs(row[34])
                fleet["stance"] = row[2]
                fleet["time"] = row[7]
    
                if row[3]: fleet["action"] = "x"
    
                if row[10]:
                    origin = {}
                    fleet["planet"] = origin
                    
                    origin["id"] = row[10]
                    origin["g"] = row[12]
                    origin["s"] = row[13]
                    origin["p"] = row[14]
                    origin["relation"] = row[17]
                    origin["name"] = self.getPlanetName(row[17], row[35], row[16], row[11])
    
                if row[18]:
                    destination = {}
                    fleet["destination"] = destination
                    
                    destination["id"] = row[18]
                    destination["g"] = row[20]
                    destination["s"] = row[21]
                    destination["p"] = row[22]
                    destination["relation"] = row[25]
                    destination["name"] = self.getPlanetName(row[25], row[36], row[24], row[19])
    
                fleet["ships"] = []
                
                query = "SELECT fleetid, gm_fleet_ships.shipid, quantity" + \
                        " FROM gm_fleets" + \
                        "    INNER JOIN gm_fleet_ships ON (gm_fleets.id=gm_fleet_ships.fleetid)" + \
                        " WHERE fleetid=" + str(row[0]) + " AND ownerid=" + str(self.userId) + \
                        " ORDER BY fleetid, gm_fleet_ships.shipid"
                oRss2 = dbRows(query)
                
                if oRss2:
                    for oRs2 in oRss2:

                        ship = {}
                        fleet["ships"].append(ship)

                        ship["label"] = getShipLabel(oRs2[1])
                        ship["count"] = oRs2[2]
            
        return self.display(content)
