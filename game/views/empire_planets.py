# -*- coding: utf-8 -*-

from game.views._base import *

#-------------------------------------------------------------------------------
class View(BaseView):

    def dispatch(self, request, *args, **kwargs):

        response = super().pre_dispatch(request, *args, **kwargs)
        if response: return response

        self.selected_menu = "planets"

        return self.ListPlanets()

    def ListPlanets(self):

        content = self.loadTemplate("planets")

        #
        # Setup column ordering
        #
        col = ToInt(self.request.GET.get("col"), 0)

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

        if self.request.GET.get("r","") != "":
            reversed = not reversed
        else:
            content.Parse("r" + str(col))

        if reversed: orderby = orderby + " DESC"
        orderby = orderby + ", upper(name)"

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
                " WHERE planet_floor > 0 AND planet_space > 0 AND ownerid="+str(self.userId)+ \
                " ORDER BY "+orderby

        rows = dbRows(query)
        
        list = []
        content.AssignValue("page_planets", list)
        for row in rows:
            item = {}
            list.append(item)
            
            mood_delta = 0

            item["planet_img"] = self.getPlanetImg(row[0], row[29])

            item["planet_id"] = row[0]
            item["planet_name"] = row[1]

            item["g"] = row[2]
            item["s"] = row[3]
            item["p"] = row[4]

                # ore
            item["ore"] = row[5]
            item["ore_production"] = row[6]
            item["ore_capacity"] = row[7]

            # compute ore level : ore / capacity
            ore_level = self.getpercent(row[5], row[7], 10)

            if ore_level >= 90:
                item["high_ore"] = True
            elif ore_level >= 70:
                item["medium_ore"] = True
            else:
                item["normal_ore"] = True

            # hydro
            item["hydro"] = row[8]
            item["hydro_production"] = row[9]
            item["hydro_capacity"] = row[10]

            # compute hydro level : hydro / capacity
            hydro_level = self.getpercent(row[8], row[10], 10)

            if hydro_level >= 90:
                item["high_hydro"] = True
            elif hydro_level >= 70:
                item["medium_hydro"] = True
            else:
                item["normal_hydro"] = True

            # energy
            item["energy"] = row[31]
            item["energy_production"] = row[13]
            item["energy_capacity"] = row[14]

            # compute energy level : energy / capacity
            energy_level = self.getpercent(row[31], row[14], 10)

            item["normal_energy"] = True

            credits = row[37] + (row[38] / 2)

            item["credits"] = int(credits)
            if credits < 0:
                item["credits_minus"] = True
            else:
                item["credits_plus"] = True

            item["prestige"] = row[39]

            if row[13] < 0:
                item["negative_energy_production"] = True
            elif row[32] >= 0 and row[23] >= row[28]:
                item["normal_energy_production"] = True
            else:
                item["medium_energy_production"] = True

            # workers
            item["workers"] = row[23]
            item["workers_idle"] = row[11]
            item["workers_capacity"] = row[12]

            # soldiers
            item["soldiers"] = row[24]
            item["soldiers_capacity"] = row[25]
            item["soldiers_training"] = row[36]

            # scientists
            item["scientists"] = row[26]
            item["scientists_capacity"] = row[27]
            item["scientists_training"] = row[35]

            if row[23] < row[28]: item["workers_low"] = True

            if row[24]*250 < row[23]+row[26]: item["soldiers_low"] = True

            # mood
            if row[30] > 100:
                item["mood"] = 100
            else:
                item["mood"] = row[30]

            moodlevel = round(row[30] / 10) * 10
            if moodlevel > 100: moodlevel = 100

            item["mood_level"] = moodlevel

            if (row[19]): mood_delta = mood_delta + 1

            if row[24]*250 >= row[23]+row[26]:
                mood_delta = mood_delta + 2
            else:
                mood_delta = mood_delta - 1

            item["mood_delta"] = mood_delta
            if mood_delta > 0:
                item["mood_plus"] = True
            else:
                item["mood_minus"] = True

            # planet stats
            item["floor_capacity"] = row[15]
            item["floor_occupied"] = row[16]

            item["space_capacity"] = row[17]
            item["space_occupied"] = row[18]

            if row[19]:
                item["commander_id"] = row[19]
                item["commander_name"] = row[20]
                item["commander"] = True
            else:
                item["nocommander"] = True

            if row[21] >= 0 and row[23] >= row[28]:
                item["normal_ore_production"] = True
            else:
                item["medium_ore_production"] = True

            if row[22] >= 0 and row[23] >= row[28]:
                item["normal_hydro_production"] = True
            else:
                item["medium_hydro_production"] = True

            item["upkeep_credits"] = row[33]
            item["upkeep_workers"] = row[28]
            item["upkeep_soldiers"] = int((row[23]+row[26]) / 250)

            if row[0] == self.currentPlanetId: item["highlight"] = True

        return self.display(content)
