# -*- coding: utf-8 -*-

from game.views._base import *

class View(GlobalView):

    def dispatch(self, request, *args, **kwargs):

        response = super().pre_dispatch(request, *args, **kwargs)
        if response: return response
        
        action = request.GET.get("a")

        # --- assign category to fleet
        
        if action == "setcat":
            
            oldCat = ToInt(request.GET.get("old"), 0)
            newCat = ToInt(request.GET.get("new"), 0)
            fleetid = ToInt(request.GET.get("id"), 0)

            oRs = oConnExecute("SELECT user_fleet_category_assign(" + str(self.UserId) + "," + str(fleetid) + "," + str(oldCat) + "," + str(newCat) + ")")
            if oRs and oRs[0]:
                
                content = GetTemplate(self.request, "fleets-handler")

                content.AssignValue("id", fleetid)
                content.AssignValue("old", oldCat)
                content.AssignValue("new", newCat)
                
                content.Parse("fleet_category_changed")

                return render(self.request, content.template, content.data)

        # --- create new category
        
        elif action == "newcat":
            
            name = request.GET.get("name")

            content = GetTemplate(self.request, "fleets-handler")

            if self.isValidCategoryName(name):
                oRs = oConnExecute("SELECT user_fleet_category_create(" + str(self.UserId) + "," + dosql(name) + ")")

                if oRs:
                    content.AssignValue("id", oRs[0])
                    content.AssignValue("label", name)
                    content.Parse("category")

            else:
                content.Parse("category_name_invalid")

            return render(self.request, content.template, content.data)

        # --- rename category
        
        elif action == "rencat":
            
            name = request.GET.get("name")
            catid = ToInt(request.GET.get("id"), 0)

            content = GetTemplate(self.request, "fleets-handler")

            if name == "":
                oRs = oConnExecute("SELECT user_fleet_category_delete(" + str(self.UserId) + "," + str(catid) + ")")
                if oRs:
                    content.AssignValue("id", catid)
                    content.AssignValue("label", name)
                    content.Parse("category")

                    return render(self.request, content.template, content.data)

            elif self.isValidCategoryName(name):
                oRs = oConnExecute("SELECT user_fleet_category_rename(" + str(self.UserId) + "," + str(catid) + "," + dosql(name) + ")")

                if oRs:
                    content.AssignValue("id", catid)
                    content.AssignValue("label", name)
                    content.Parse("category")

                    return render(self.request, content.template, content.data)

            else:
                content.Parse("category_name_invalid")

                return render(self.request, content.template, content.data)
        
        self.selected_menu = "fleets.fleets"

        content = GetTemplate(self.request, "fleets")

        # --- fleet categories

        categories = []
        content.AssignValue("categories", categories)
        
        query = "SELECT category, label" + \
                " FROM gm_profile_fleet_categories" + \
                " WHERE userid=" + str(self.UserId) + \
                " ORDER BY upper(label)"
        oRss = oConnExecuteAll(query)
        
        if oRss:
            for oRs in oRss:

                category = {}
                categories.append(category)
                
                category["id"] = oRs[0]
                category["label"] = oRs[1]

        # --- fleets

        fleets = []
        content.AssignValue("fleets", fleets)
        
        query = "SELECT id, name, attackonsight, engaged, size, signature, speed, remaining_time, commanderid, commandername," + \
                " planetid, planet_name, planet_galaxy, planet_sector, planet_planet, planet_ownerid, planet_owner_name, planet_owner_relation," + \
                " destplanetid, destplanet_name, destplanet_galaxy, destplanet_sector, destplanet_planet, destplanet_ownerid, destplanet_owner_name, destplanet_owner_relation," + \
                " cargo_capacity, cargo_ore, cargo_hydrocarbon, cargo_scientists, cargo_soldiers, cargo_workers," + \
                " recycler_output, orbit_ore > 0 OR orbit_hydrocarbon > 0, action," + \
                "( SELECT int4(COALESCE(max(gm_planets.radar_strength), 0)) FROM gm_planets WHERE gm_planets.galaxy = f.planet_galaxy AND gm_planets.sector = f.planet_sector AND gm_planets.ownerid IS NOT NULL AND EXISTS ( SELECT 1 FROM vw_gm_friend_radars WHERE vw_gm_friend_radars.friend = gm_planets.ownerid AND vw_gm_friend_radars.userid = " + str(self.UserId) + ")) AS from_radarstrength, " + \
                "( SELECT int4(COALESCE(max(gm_planets.radar_strength), 0)) FROM gm_planets WHERE gm_planets.galaxy = f.destplanet_galaxy AND gm_planets.sector = f.destplanet_sector AND gm_planets.ownerid IS NOT NULL AND EXISTS ( SELECT 1 FROM vw_gm_friend_radars WHERE vw_gm_friend_radars.friend = gm_planets.ownerid AND vw_gm_friend_radars.userid = " + str(self.UserId) + ")) AS to_radarstrength," + \
                " categoryid" + \
                " FROM vw_gm_fleets as f WHERE ownerid=" + str(self.UserId)
        oRss = oConnExecuteAll(query)
        
        if oRss:
            for oRs in oRss:
                
                fleet = {}
                fleets.append(fleet)
                
                fleet["id"] = oRs[0]
                fleet["name"] = oRs[1]
                fleet["category"] = oRs[37]
                fleet["size"] = oRs[4]
                fleet["signature"] = oRs[5]
                fleet["cargo_load"] = oRs[27] + oRs[28] + oRs[29] + oRs[30] + oRs[31]
                fleet["cargo_capacity"] = oRs[26]
                fleet["cargo_ore"] = oRs[27]
                fleet["cargo_hydrocarbon"] = oRs[28]
                fleet["cargo_scientists"] = oRs[29]
                fleet["cargo_soldiers"] = oRs[30]
                fleet["cargo_workers"] = oRs[31]
                fleet["commander_name"] = oRs[9]
                fleet["action"] = abs(oRs[34])
                fleet["stance"] = oRs[2]
                fleet["time"] = oRs[7]
    
                if oRs[3]: fleet["action"] = "x"
    
                if oRs[10]:
                    origin = {}
                    fleet["planet"] = origin
                    
                    origin["id"] = oRs[10]
                    origin["g"] = oRs[12]
                    origin["s"] = oRs[13]
                    origin["p"] = oRs[14]
                    origin["relation"] = oRs[17]
                    origin["name"] = self.getPlanetName(oRs[17], oRs[35], oRs[16], oRs[11])
    
                if oRs[18]:
                    destination = {}
                    fleet["destination"] = destination
                    
                    destination["id"] = oRs[18]
                    destination["g"] = oRs[20]
                    destination["s"] = oRs[21]
                    destination["p"] = oRs[22]
                    destination["relation"] = oRs[25]
                    destination["name"] = self.getPlanetName(oRs[25], oRs[36], oRs[24], oRs[19])
    
                fleet["ships"] = []
                
                query = "SELECT fleetid, gm_fleet_ships.shipid, quantity" + \
                        " FROM gm_fleets" + \
                        "    INNER JOIN gm_fleet_ships ON (gm_fleets.id=gm_fleet_ships.fleetid)" + \
                        " WHERE fleetid=" + str(oRs[0]) + " AND ownerid=" + str(self.UserId) + \
                        " ORDER BY fleetid, gm_fleet_ships.shipid"
                oRss2 = oConnExecuteAll(query)
                
                if oRss2:
                    for oRs2 in oRss2:

                        ship = {}
                        fleet["ships"].append(ship)

                        ship["label"] = getShipLabel(oRs2[1])
                        ship["count"] = oRs2[2]
            
        return self.Display(content)
