# -*- coding: utf-8 -*-

from web_game.game._global import *



class View(GlobalView):

    def dispatch(self, request, *args, **kwargs):
        
        response = super().pre_dispatch(request, *args, **kwargs)
        if response: return response
            
        return super().dispatch(request, *args, **kwargs)
    
    
    
    def get(self, request, *args, **kwargs):
        
        self.selected_menu = "empire"
        self.selected_tab = "planets"

        content = GetTemplate(self.request, "empire_planets")

        # --- sorting
        
        orderby = ""
        reversed = False
        
        col = ToInt(request.GET.get("col"), 0)
        
        if col == 0:
            orderby = "id"
            
        elif col == 1:
            orderby = "upper(name)"
            
        elif col == 5:
            orderby = "mood"

        if request.GET.get("r", "") != "":
            reversed = not reversed
        
        if reversed: orderby = orderby + " DESC"
        orderby = orderby + ", upper(name)"
        
        content.AssignValue("col", col)
        content.AssignValue("reversed", reversed)

        # --- user planets data
        
        list = []
        content.AssignValue("page_planets", list)
        
        query = " SELECT t.id, name, galaxy, sector, planet," + \
                " ore, ore_production, ore_capacity," + \
                " hydrocarbon, hydrocarbon_production, hydrocarbon_capacity," + \
                " workers-workers_busy, workers_capacity," + \
                " energy_production - energy_consumption, energy_capacity," + \
                " floor, floor_occupied," + \
                " space, space_occupied," + \
                " commanderid, (SELECT name FROM commanders WHERE id = t.commanderid) AS commandername," + \
                " mod_production_ore, mod_production_hydrocarbon, workers, t.soldiers, soldiers_capacity," + \
                " t.scientists, scientists_capacity, workers_for_maintenance, planet_floor, mood," + \
                " energy, mod_production_energy, upkeep, energy_consumption," + \
                " (SELECT int4(COALESCE(sum(scientists), 0)) FROM planet_training_pending WHERE planetid=t.id) AS scientists_training," + \
                " (SELECT int4(COALESCE(sum(soldiers), 0)) FROM planet_training_pending WHERE planetid=t.id) AS soldiers_training," + \
                " credits_production, credits_random_production, production_prestige" + \
                " FROM vw_planets AS t" + \
                " WHERE planet_floor > 0 AND planet_space > 0 AND ownerid=" + str(self.UserId)+ \
                " ORDER BY " + orderby
        rows = oConnExecuteAll(query)
        
        for oRs in rows:
        
            item = {}
            list.append(item)
            
            item["id"] = oRs[0]
            item["img"] = self.planetimg(oRs[0], oRs[29])
            item["name"] = oRs[1]

            item["g"] = oRs[2]
            item["s"] = oRs[3]
            item["p"] = oRs[4]

            item["ore_prod"] = oRs[6]
            item["ore_count"] = oRs[5]
            item["ore_stock"] = oRs[7]
            item["ore_level"] = self.getpercent(oRs[5], oRs[7], 10)
            if oRs[21] < 0 or oRs[23] < oRs[28]: item["ore_prod_low"] = True

            item["hydro_prod"] = oRs[9]
            item["hydro_count"] = oRs[8]
            item["hydro_stock"] = oRs[10]
            item["hydro_level"] = self.getpercent(oRs[8], oRs[10], 10)
            if oRs[22] < 0 or oRs[23] < oRs[28]: item["hydro_prod_low"] = True

            item["energy_prod"] = oRs[13]
            item["energy_count"] = oRs[31]
            item["energy_stock"] = oRs[14]
            if oRs[32] < 0 or oRs[23] < oRs[28]: item["energy_prod_low"] = True

            item["credit_prod"] = int(oRs[37] + (oRs[38] / 2))
            item["prestige_prod"] = oRs[39]

            item["worker_idle"] = oRs[11]
            item["worker_count"] = oRs[23]
            item["worker_stock"] = oRs[12]
            if oRs[23] < oRs[28]: item["worker_low"] = True

            item["soldier_count"] = oRs[24]
            item["soldier_stock"] = oRs[25]
            item["soldier_training"] = oRs[36]
            if oRs[24] * 250 < oRs[23] + oRs[26]: item["soldier_low"] = True

            item["scientist_count"] = oRs[26]
            item["scientist_stock"] = oRs[27]
            item["scientist_training"] = oRs[35]

            if oRs[30] > 100: item["mood"] = 100
            else: item["mood"] = oRs[30]

            moodlevel = round(oRs[30] / 10) * 10
            if moodlevel > 100: moodlevel = 100
            item["mood_level"] = moodlevel

            mood_delta = 0
            if oRs[19]: mood_delta = mood_delta + 1
            if oRs[24] * 250 >= oRs[23] + oRs[26]: mood_delta = mood_delta + 2
            else: mood_delta = mood_delta - 1
            item["mood_delta"] = mood_delta

            item["floor_capacity"] = oRs[15]
            item["floor_occupied"] = oRs[16]

            item["space_capacity"] = oRs[17]
            item["space_occupied"] = oRs[18]

            if oRs[19]:
                
                item["commander"] = {}
                item["commander"]["id"] = oRs[19]
                item["commander"]["name"] = oRs[20]

            item["upkeep_credits"] = oRs[33]
            item["upkeep_workers"] = oRs[28]
            item["upkeep_soldiers"] = int((oRs[23] + oRs[26]) / 250)

            if oRs[0] == self.CurrentPlanet: item["highlight"] = True

        return self.Display(content)
