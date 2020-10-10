# -*- coding: utf-8 -*-

from web_game.game._global import *



class View(GlobalView):

    def dispatch(self, request, *args, **kwargs):

        response = super().pre_dispatch(request, *args, **kwargs)
        if response: return response
        
        return super().dispatch(request, *args, **kwargs)



    def get(self, request, *args, **kwargs):
        
        action = request.GET.get("a", "")

        # --- assign catgeory to fleet

        if action == "setcat":
            
            oldCat = ToInt(request.GET.get("old"), 0)
            newCat = ToInt(request.GET.get("new"), 0)
            fleetid = ToInt(request.GET.get("id"), 0)

            oRs = oConnExecute("SELECT sp_fleets_set_category(" + str(self.UserId) + "," + str(fleetid) + "," + str(oldCat) + "," + str(newCat) + ")")
            if oRs and oRs[0]:
                
                content = GetTemplate(self.request, "fleets_rest")

                content.AssignValue("id", fleetid)
                content.AssignValue("old", oldCat)
                content.AssignValue("new", newCat)
                
                content.Parse("fleet_category_changed")

                return render(self.request, content.template, content.data)

        # --- create a new category

        elif action == "newcat":
            
            name = request.GET.get("name", "")

            content = GetTemplate(self.request, "fleets_rest")

            if self.isValidCategoryName(name):
                
                oRs = oConnExecute("SELECT sp_fleets_categories_add(" + str(self.UserId) + "," + dosql(name) + ")")
                if oRs:
                    
                    content.AssignValue("id", oRs[0])
                    content.AssignValue("label", name)
                    
                    content.Parse("category")

            else: content.Parse("category_name_invalid")

            return render(self.request, content.template, content.data)

        # --- rename a category

        elif action == "rencat":
            
            name = request.GET.get("name", "")
            catid = ToInt(request.GET.get("id"), 0)

            content = GetTemplate(self.request, "fleets_rest")

            if name == "":
                
                oRs = oConnExecute("SELECT sp_fleets_categories_delete(" + str(self.UserId) + "," + str(catid) + ")")
                if oRs:
                    
                    content.AssignValue("id", catid)
                    content.AssignValue("label", name)
                    
                    content.Parse("category")

            elif self.isValidCategoryName(name):
                
                oRs = oConnExecute("SELECT sp_fleets_categories_rename(" + str(self.UserId) + "," + str(catid) + "," + dosql(name) + ")")
                if oRs:
                    
                    content.AssignValue("id", catid)
                    content.AssignValue("label", name)
                    
                    content.Parse("category")

            else: content.Parse("category_name_invalid")

            return render(self.request, content.template, content.data)

        # --- retrieve fleets of category

        elif action == "list":
            
            content = GetTemplate(self.request, "fleets_rest")
    
            query = " SELECT fleetid, fleets_ships.shipid, quantity, db_ships.label" + \
                    " FROM fleets" + \
                    "    INNER JOIN fleets_ships ON (fleets.id = fleets_ships.fleetid)" + \
                    "    INNER JOIN db_ships ON (db_ships.id = fleets_ships.shipid)" + \
                    " WHERE ownerid=" + str(self.UserId) + \
                    " ORDER BY fleetid, fleets_ships.shipid"
            ShipListArray = oConnExecuteAll(query)
            
            list = []
            content.AssignValue("fleets", list)
    
            query = " SELECT id, name, attackonsight, engaged, size, signature, speed, remaining_time, commanderid, commandername," + \
                    " planetid, planet_name, planet_galaxy, planet_sector, planet_planet, planet_ownerid, planet_owner_name, planet_owner_relation," + \
                    " destplanetid, destplanet_name, destplanet_galaxy, destplanet_sector, destplanet_planet, destplanet_ownerid, destplanet_owner_name, destplanet_owner_relation," + \
                    " cargo_capacity, cargo_ore, cargo_hydrocarbon, cargo_scientists, cargo_soldiers, cargo_workers," + \
                    " recycler_output, orbit_ore > 0 OR orbit_hydrocarbon > 0, action," + \
                    " (SELECT int4(COALESCE(max(nav_planet.radar_strength), 0)) FROM nav_planet WHERE nav_planet.galaxy = f.planet_galaxy AND nav_planet.sector = f.planet_sector AND nav_planet.ownerid IS NOT NULL AND EXISTS ( SELECT 1 FROM vw_friends_radars WHERE vw_friends_radars.friend = nav_planet.ownerid AND vw_friends_radars.userid = " + str(self.UserId) + ")) AS from_radarstrength, " + \
                    " (SELECT int4(COALESCE(max(nav_planet.radar_strength), 0)) FROM nav_planet WHERE nav_planet.galaxy = f.destplanet_galaxy AND nav_planet.sector = f.destplanet_sector AND nav_planet.ownerid IS NOT NULL AND EXISTS ( SELECT 1 FROM vw_friends_radars WHERE vw_friends_radars.friend = nav_planet.ownerid AND vw_friends_radars.userid = " + str(self.UserId) + ")) AS to_radarstrength," + \
                    " categoryid" + \
                    " FROM vw_fleets as f" + \
                    " WHERE ownerid=" + str(self.UserId)
            oRss = oConnExecuteAll(query)
            for oRs in oRss:
                
                item = {}
                list.append(item)
                
                item["id"] = oRs[0]
                item["name"] = oRs[1]
                item["category"] = oRs[37]
                item["size"] = oRs[4]
                item["signature"] = oRs[5]
                item["cargo_load"] = oRs[27] + oRs[28] + oRs[29] + oRs[30] + oRs[31]
                item["cargo_capacity"] = oRs[26]
                item["cargo_ore"] = oRs[27]
                item["cargo_hydrocarbon"] = oRs[28]
                item["cargo_scientists"] = oRs[29]
                item["cargo_soldiers"] = oRs[30]
                item["cargo_workers"] = oRs[31]
                item["commander_name"] = oRs[9] if oRs[9] else ""
                item["stance"] = 1 if oRs[2] else 0
                item["time"] = oRs[7] if oRs[7] else 0
                
                item["action"] = abs(oRs[34])
                if oRs[3]: item["action"] = "x"
                
                item["planet"] = { "id":0, "g":0, "s":0, "p":0, "relation":0, "name":"" }
                if oRs[10]:

                    item["planet"]["id"] = oRs[10]
                    item["planet"]["g"] = oRs[12]
                    item["planet"]["s"] = oRs[13]
                    item["planet"]["p"] = oRs[14]
                    item["planet"]["relation"] = oRs[17]
                    item["planet"]["name"] = self.getPlanetName(oRs[17], oRs[35], oRs[16], oRs[11])
    
                item["dest"] = { "id":0, "g":0, "s":0, "p":0, "relation":0, "name":"" }
                if oRs[18]:

                    item["dest"]["id"] = oRs[18]
                    item["dest"]["g"] = oRs[20]
                    item["dest"]["s"] = oRs[21]
                    item["dest"]["p"] = oRs[22]
                    item["dest"]["relation"] = oRs[25]
                    item["dest"]["name"] = self.getPlanetName(oRs[25], oRs[36], oRs[24], oRs[19])
    
                item['ships'] = []
                for ship in ShipListArray:
                    if ship[0] == oRs[0]:
                        
                        s = {}
                        item['ships'].append(s)
                        
                        s["label"] = ship[3]
                        s["quantity"] = ship[2]
                        
                item['resources'] = []
                
                res1 = {}
                res1["id"] = 1
                res1["quantity"] = oRs[27]
                item['resources'].append(res1)
    
                res2 = {}
                res2["id"] = 2
                res2["quantity"] = oRs[28]
                item['resources'].append(res2)
    
                res3 = {}
                res3["id"] = 3
                res3["quantity"] = oRs[29]
                item['resources'].append(res3)
    
                res4 = {}
                res4["id"] = 4
                res4["quantity"] = oRs[30]
                item['resources'].append(res4)
    
                res5 = {}
                res5["id"] = 5
                res5["quantity"] = oRs[31]
                item['resources'].append(res5)
    
            return render(request, content.template, content.data)



    def isValidCategoryName(self, name):
        
        name = name.strip()

        if name == "" or len(name) < 2 or len(name) > 32:
            return False
        else:
            p = re.compile("^[a-zA-Z0-9\- ]+$")
            return p.match(name)
