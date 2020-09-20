# -*- coding: utf-8 -*-

from game.views._base import *

#-------------------------------------------------------------------------------
class View(BaseView):

    success_url = "/game/commander-overview/"
    template_name = "commander-overview"
    selected_menu = "commanders"

    #---------------------------------------------------------------------------
    def dispatch(self, request, *args, **kwargs):

        response = super().pre_dispatch(request, *args, **kwargs)
        if response: return response
        
        return super().dispatch(request, *args, **kwargs)

    #---------------------------------------------------------------------------
    def processAction(self, request, action):
    
        if action == "rename":
        
            id = ToInt(request.POST.get("id"), 0)
            name = request.POST.get("name","").strip()
            
            query = "SELECT user_commander_rename(" + str(self.userId) + "," + str(id) + "," + sqlStr(name) + ")"
            row = dbRow(query)
            return row[0]
            
        elif action == "fire":
            
            id = ToInt(request.POST.get("id"), 0)
            
            query = "SELECT user_commander_fire(" + str(self.userId) + "," + str(id) + ")"
            row = dbRow(query)
            return row[0]
            
        elif action == "engage":
        
            id = ToInt(request.POST.get("id"), 0)
            
            query = "SELECT user_commander_engage(" + str(self.userId) + "," + str(id) + ")"
            row = dbRow(query)
            return row[0]
            
        elif action == "train":

            id = ToInt(request.POST.get("id"), 0)
            
            query = "SELECT user_commander_train(" + str(self.userId) + "," + str(id) + ")"
            row = dbRow(query)
            return row[0]
            
    #---------------------------------------------------------------------------
    def fillContent(self, request, data):

        # --- new commander checking
        
        dbExecute("SELECT internal_profile_check_for_new_commanders(" + str(self.userId) + ")")
        
        # --- user info & rights
        
        data["planetid"] = self.currentPlanetId
        data["max_commanders"] = int(self.userInfo["mod_commanders"])

        row = dbRow("SELECT int4(count(1)) FROM gm_commanders WHERE recruited <= now() AND ownerid=" + str(self.userId))
        data["can_engage"] = row[0] < self.userInfo["mod_commanders"]

        # --- commanders data
        
        data["commander_list"] = []
        data["available_commanders"] = []
        
        query = "SELECT c.id, c.name, c.recruited, points, added, salary, can_be_fired, " + \
                " p.id, p.galaxy, p.sector, p.planet, p.name, " + \
                " f.id, f.name, " + \
                " c.mod_production_ore, c.mod_production_hydro, c.mod_production_energy, " + \
                " c.mod_production_workers, c.mod_fleet_speed, c.mod_fleet_shield, " + \
                " c.mod_fleet_handling, c.mod_fleet_tracking_speed, c.mod_fleet_damage, c.mod_fleet_signature, "  + \
                " c.mod_construction_speed_buildings, c.mod_construction_speed_ships, last_training < now()-interval '1 day', internal_commander_get_prestige_cost_to_train(c.ownerid, c.id), salary_increases < 20" + \
                " FROM gm_commanders AS c" + \
                "    LEFT JOIN gm_fleets AS f ON (c.id=f.commanderid)" + \
                "    LEFT JOIN gm_planets AS p ON (c.id=p.commanderid)" + \
                " WHERE c.ownerid=" + str(self.userId) + \
                " ORDER BY upper(c.name)"
        rows = dbRows(query)
        if rows:
            for row in rows:
            
                commander = {}
                
                commander["id"] = row[0]
                commander["name"] = row[1]
                commander["recruited"] = row[2]
                commander["points"] = row[3]
                commander["added"] = row[4]
                commander["salary"] = row[5]
                commander["can_fire"] = row[6]

                if row[2] == None: data["available_commanders"].append(commander)
                else: data["commander_list"].append(commander)

                if row[7]:
                    commander["planet"] = {}
                    commander["planet"]["id"] = row[7]
                    commander["planet"]["g"] = row[8]
                    commander["planet"]["s"] = row[9]
                    commander["planet"]["p"] = row[10]
                    commander["planet"]["name"] = row[11]
                    
                elif row[12]:
                    commander["fleet"] = {}
                    commander["fleet"]["id"] = row[12]
                    commander["fleet"]["name"] = row[13]

                commander["bonuses"] = []
                for i in range(14, 26):
                    if row[i] != 1.0:
                    
                        bonus = {}
                        commander["bonuses"].append(bonus)
                        
                        bonus["id"] = i
                        bonus["value"] = round((row[i] - 1.0) * 100)
                        
                if row[26] and row[28]:
                    commander["prestige"] = row[27]
                    commander["train"] = True
                else:
                    if row[28]: commander["cant_train"] = True
                    else: commander["cant_train_anymore"] = True
