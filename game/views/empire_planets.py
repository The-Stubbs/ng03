# -*- coding: utf-8 -*-

from game.views._base import *

#-------------------------------------------------------------------------------
class View(BaseView):

    success_url = ""
    template_name = ""
    selected_menu = ""

    #---------------------------------------------------------------------------
    def dispatch(self, request, *args, **kwargs):

        response = super().pre_dispatch(request, *args, **kwargs)
        if response: return response
        
        return super().dispatch(request, *args, **kwargs)

    #---------------------------------------------------------------------------
    def fillContent(self, request, data):

        # --- column sorting
        
        col = ToInt(request.GET.get("col"), 0)
        if col < 0 or col > 4: col = 0

        reversed = False
        if col == 0:
            orderby = "id"
        elif col == 1:
            orderby = "upper(name)"
        elif col == 2:
            orderby = "ore_production"
        elif col == 3:
            orderby = "hydro_production"
        elif col == 4:
            orderby = "energy_consumption/(1.0+energy_production)"
        elif col == 5:
            orderby = "mood"

        if request.GET.get("r","") != "":
            reversed = not reversed

        if reversed: orderby = orderby + " DESC"
        orderby = orderby + ", upper(name)"

        # --- planets data
        
        data["planets"] = []
        
        query = "SELECT t.id, name, galaxy, sector, planet," + \
                "ore, ore_production, ore_capacity," + \
                "hydro, hydro_production, hydro_capacity," + \
                "workers-workers_busy, workers_capacity," + \
                "energy_production - energy_consumption, energy_capacity," + \
                "floor, floor_occupied," + \
                "space, space_occupied," + \
                "commanderid, (SELECT name FROM gm_commanders WHERE id = t.commanderid) AS commandername," + \
                "mod_production_ore, mod_production_hydro, workers, t.soldiers, soldiers_capacity," + \
                "t.scientists, scientists_capacity, workers_for_maintenance, planet_floor, mood," + \
                "energy, mod_production_energy, upkeep, energy_consumption," + \
                " (SELECT int4(COALESCE(sum(scientists), 0)) FROM gm_planet_trainings WHERE planetid=t.id) AS scientists_training," + \
                " (SELECT int4(COALESCE(sum(soldiers), 0)) FROM gm_planet_trainings WHERE planetid=t.id) AS soldiers_training," + \
                " credits_production, credits_random_production, production_prestige" + \
                " FROM vw_gm_planets AS t" + \
                " WHERE planet_floor > 0 AND planet_space > 0 AND ownerid=" + str(self.userId)+ \
                " ORDER BY " + orderby
        rows = dbRows(query)        
        if rows:
            for row in rows:
            
                planet = {}
                data["planets"].append(planet)
                
                planet["id"] = row[0]
                planet["img"] = self.getPlanetImg(row[0], row[29])
                planet["name"] = row[1]

                planet["g"] = row[2]
                planet["s"] = row[3]
                planet["p"] = row[4]

                planet["ore"] = row[5]
                planet["ore_prod"] = row[6]
                planet["ore_stock"] = row[7]
                planet["ore_level"] = self.getpercent(row[5], row[7], 10)
                if row[21] >= 0 and row[23] >= row[28]: planet["normal_ore_prod"] = True

                planet["hydro"] = row[8]
                planet["hydro_prod"] = row[9]
                planet["hydro_stock"] = row[10]
                planet["hydro_level"] = self.getpercent(row[8], row[10], 10)
                if row[22] >= 0 and row[23] >= row[28]: planet["normal_hydro_prod"] = True

                planet["energy"] = row[31]
                planet["energy_prod"] = row[13]
                planet["energy_stock"] = row[14]

                planet["credits"] = row[37] + (row[38] / 2)
                planet["prestige"] = row[39]

                planet["workers"] = row[23]
                planet["workers_idle"] = row[11]
                planet["workers_stock"] = row[12]
                if row[23] < row[28]: planet["workers_low"] = True

                planet["soldiers"] = row[24]
                planet["soldiers_stock"] = row[25]
                planet["soldiers_training"] = row[36]
                if row[24] * 250 < row[23] + row[26]: planet["soldiers_low"] = True

                planet["scientists"] = row[26]
                planet["scientists_stock"] = row[27]
                planet["scientists_training"] = row[35]

                if row[30] > 100: planet["mood"] = 100
                else: planet["mood"] = row[30]

                moodlevel = round(row[30] / 10) * 10
                if moodlevel > 100: moodlevel = 100
                planet["mood_level"] = moodlevel

                mood_delta = 0
                if row[19]: mood_delta = mood_delta + 1
                if row[24] * 250 >= row[23] + row[26]: mood_delta = mood_delta + 2
                else: mood_delta = mood_delta - 1
                planet["mood_delta"] = mood_delta

                planet["floor_capacity"] = row[15]
                planet["floor_occupied"] = row[16]

                planet["space_capacity"] = row[17]
                planet["space_occupied"] = row[18]

                if row[19]:
                    planet["commander"] = []
                    planet["commander"]["id"] = row[19]
                    planet["commander"]["name"] = row[20]

                planet["upkeep_credits"] = row[33]
                planet["upkeep_workers"] = row[28]
                planet["upkeep_soldiers"] = int((row[23] + row[26]) / 250)

                if row[0] == self.currentPlanetId: planet["highlight"] = True
