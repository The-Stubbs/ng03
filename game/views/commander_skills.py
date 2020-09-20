# -*- coding: utf-8 -*-

from game.views._base import *

#-------------------------------------------------------------------------------
class View(BaseView):

    success_url = "/game/commander-overview/"
    template_name = "commander-skills"
    selected_menu = "commanders"

    #---------------------------------------------------------------------------
    def dispatch(self, request, *args, **kwargs):

        response = super().pre_dispatch(request, *args, **kwargs)
        if response: return response
        
        id = ToInt(request.GET.get("id"), 0)
        if id == 0: return HttpResponseRedirect("/game/commander-overview/")
        
        query = "SELECT id" + \
                " FROM gm_commanders WHERE id=" + str(id) + " AND ownerid=" + str(self.userId)
        row = dbRow(query)
        if row == None: return HttpResponseRedirect("/game/commander-overview/")
        
        self.max_ore = 2.0
        self.max_hydro = 2.0
        self.max_energy = 2.0
        self.max_workers = 2.0

        self.max_speed = 1.3
        self.max_shield = 1.4
        self.max_damages = 1.3
        self.max_handling = 1.75
        self.max_targeting = 1.75
        self.max_signature = 1.2

        self.max_build = 3
        self.max_ship = 3
        
        return super().dispatch(request, *args, **kwargs)

    #---------------------------------------------------------------------------
    def processAction(self, request, action):
    
        if action == "edit":
        
            id = ToInt(request.GET.get("id"), 0)
            
            ore = max(0, ToInt(request.POST.get("ore"), 0))
            hydro = max(0, ToInt(request.POST.get("hydro"), 0))
            energy = max(0, ToInt(request.POST.get("energy"), 0))
            workers = max(0, ToInt(request.POST.get("workers"), 0))

            fleetspeed = max(0, ToInt(request.POST.get("fleet_speed"), 0))
            fleetshield = max(0, ToInt(request.POST.get("fleet_shield"), 0))
            fleetdamages = max(0, ToInt(request.POST.get("fleet_damages"), 0))
            fleethandling = max(0, ToInt(request.POST.get("fleet_handling"), 0))
            fleettargeting = max(0, ToInt(request.POST.get("fleet_targeting"), 0))
            fleetsignature = max(0, ToInt(request.POST.get("fleet_signature"), 0))

            build = max(0, ToInt(request.POST.get("buildindspeed"), 0))
            ship = max(0, ToInt(request.POST.get("shipconstructionspeed"), 0))

            total = ore + hydro + energy + workers + fleetspeed + fleetshield + fleethandling + fleettargeting + fleetdamages + fleetsignature + build + ship

            query = "UPDATE gm_commanders SET" + \
                    " mod_production_ore=mod_production_ore + 0.01*" + str(ore) + \
                    " ,mod_production_hydro=mod_production_hydro + 0.01*" + str(hydro) + \
                    " ,mod_production_energy=mod_production_energy + 0.1*" + str(energy) + \
                    " ,mod_production_workers=mod_production_workers + 0.1*" + str(workers) + \
                    " ,mod_fleet_speed=mod_fleet_speed + 0.02*" + str(fleetspeed) + \
                    " ,mod_fleet_shield=mod_fleet_shield + 0.02*" + str(fleetshield) + \
                    " ,mod_fleet_handling=mod_fleet_handling + 0.05*" + str(fleethandling) + \
                    " ,mod_fleet_tracking_speed=mod_fleet_tracking_speed + 0.05*" + str(fleettargeting) + \
                    " ,mod_fleet_damage=mod_fleet_damage + 0.02*" + str(fleetdamages) + \
                    " ,mod_fleet_signature=mod_fleet_signature + 0.02*" + str(fleetsignature) + \
                    " ,mod_construction_speed_buildings=mod_construction_speed_buildings + 0.05*" + str(build) + \
                    " ,mod_construction_speed_ships=mod_construction_speed_ships + 0.05*" + str(ship) + \
                    " ,points=points-" + str(total) + \
                    " WHERE ownerid=" + str(self.userId) + " AND id=" + str(id) + " AND points >= " + str(total)
            dbExecute(query)

            query = "SELECT mod_production_ore, mod_production_hydro, mod_production_energy," + \
                    " mod_production_workers, mod_fleet_speed, mod_fleet_shield, mod_fleet_handling," + \
                    " mod_fleet_tracking_speed, mod_fleet_damage, mod_fleet_signature," + \
                    " mod_construction_speed_buildings, mod_construction_speed_ships" + \
                    " FROM gm_commanders" + \
                    " WHERE id=" + str(id) + " AND ownerid=" + str(self.userId)
            row = dbRow(query)
            if row[0] <= self.max_ore + 0.0001 and row[1] <= self.max_hydro + 0.0001 and row[2] <= self.max_energy + 0.0001 and row[3] <= self.max_workers + 0.0001 and \
               row[4] <= self.max_speed + 0.0001 and row[5] <= self.max_shield + 0.0001 and row[6] <= self.max_handling + 0.0001 and row[7] <= self.max_targeting + 0.0001 and row[8] <= self.max_damages + 0.0001 and row[9] <= self.max_signature + 0.0001 and \
               row[10] <= self.max_build + 0.0001 and row[11] <= self.max_ship + 0.0001:

                query = "SELECT internal_fleet_update_bonuses(id) FROM gm_fleets WHERE commanderid=" + str(id)
                dbExecute(query)

                query = "SELECT internal_planet_update_data(id) FROM gm_planets WHERE commanderid=" + str(id)
                dbExecute(query)

    #---------------------------------------------------------------------------
    def fillContent(self, request, data):
    
        id = ToInt(request.GET.get("id"), 0)
        
        # --- commander data
        
        data["commander"] = {}
        
        query = "SELECT mod_production_ore, mod_production_hydro, mod_production_energy," + \
                " mod_production_workers, mod_fleet_speed, mod_fleet_shield, mod_fleet_handling," + \
                " mod_fleet_tracking_speed, mod_fleet_damage, mod_fleet_signature," + \
                " mod_construction_speed_buildings, mod_construction_speed_ships," + \
                " points, name" + \
                " FROM gm_commanders WHERE id=" + str(id) + " AND ownerid=" + str(self.userId)
        row = dbRow(query)

        data["commander"]["commanderid"] = id
        
        data["commander"]["name"] = row[13]
        data["commander"]["maxpoints"] = row[12]

        data["commander"]["ore"] = str(row[0]).replace(",",".")
        data["commander"]["hydro"] = str(row[1]).replace(",",".")
        data["commander"]["energy"] = str(row[2]).replace(",",".")
        data["commander"]["workers"] = str(row[3]).replace(",",".")

        data["commander"]["speed"] = str(row[4]).replace(",",".")
        data["commander"]["shield"] = str(row[5]).replace(",",".")
        data["commander"]["handling"] = str(row[6]).replace(",",".")
        data["commander"]["targeting"] = str(row[7]).replace(",",".")
        data["commander"]["damages"] = str(row[8]).replace(",",".")
        data["commander"]["signature"] = str(row[9]).replace(",",".")

        data["commander"]["build"] = str(row[10]).replace(",",".")
        data["commander"]["ship"] = str(row[11]).replace(",",".")

        data["commander"]["max_ore"] = str(self.max_ore).replace(",",".")
        data["commander"]["max_hydro"] = str(self.max_hydro).replace(",",".")
        data["commander"]["max_energy"] = str(self.max_energy).replace(",",".")
        data["commander"]["max_workers"] = str(self.max_workers).replace(",",".")

        data["commander"]["max_speed"] = str(self.max_speed).replace(",",".")
        data["commander"]["max_shield"] = str(self.max_shield).replace(",",".")
        data["commander"]["max_handling"] = str(self.max_handling).replace(",",".")
        data["commander"]["max_targeting"] = str(self.max_targeting).replace(",",".")
        data["commander"]["max_damages"] = str(self.max_damages).replace(",",".")
        data["commander"]["max_signature"] = str(self.max_signature).replace(",",".")

        data["commander"]["max_build"] = str(self.max_build).replace(",",".")
        data["commander"]["max_ship"] = str(self.max_ship).replace(",",".")
        