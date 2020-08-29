# -*- coding: utf-8 -*-

from web_game.game._global import *

class View(GlobalView):

    def dispatch(self, request, *args, **kwargs):

        response = super().pre_dispatch(request, *args, **kwargs)
        if response: return response

        self.selected_menu = "planets"

        return self.ListPlanets()

    def ListPlanets(self):

        content = GetTemplate(self.request, "planets")

        #
        # Setup column ordering
        #
        col = ToInt(request.GET.get("col"), 0)

        if col < 0 or col > 4: col = 0

        if col == 0:
            orderby = "id"
        elif col == 1:
            orderby = "upper(name)"
        elif col == 2:
            orderby = "ore_production"
        elif col == 3:
            orderby = "hydrocarbon_production"
        elif col == 4:
            orderby = "energy_consumption/(1.0+energy_production)"
        elif col == 5:
            orderby = "mood"

        if request.GET.get("r") != "":
            reversed = not reversed
        else:
            content.Parse("r" + col

        if reversed: orderby = orderby + " DESC"
        orderby = orderby + ", upper(name)"

        query = "SELECT t.id, name, galaxy, sector, planet," + \
                "ore, ore_production, ore_capacity," + \
                "hydrocarbon, hydrocarbon_production, hydrocarbon_capacity," + \
                "workers-workers_busy, workers_capacity," + \
                "energy_production - energy_consumption, energy_capacity," + \
                "floor, floor_occupied," + \
                "space, space_occupied," + \
                "commanderid, (SELECT name FROM commanders WHERE id = t.commanderid) AS commandername," + \
                "mod_production_ore, mod_production_hydrocarbon, workers, t.soldiers, soldiers_capacity," + \
                "t.scientists, scientists_capacity, workers_for_maintenance, planet_floor, mood," + \
                "energy, mod_production_energy, upkeep, energy_consumption," + \
                " (SELECT int4(COALESCE(sum(scientists), 0)) FROM planet_training_pending WHERE planetid=t.id) AS scientists_training," + \
                " (SELECT int4(COALESCE(sum(soldiers), 0)) FROM planet_training_pending WHERE planetid=t.id) AS soldiers_training," + \
                " credits_production, credits_random_production, production_prestige" + \
                " FROM vw_planets AS t" + \
                " WHERE planet_floor > 0 AND planet_space > 0 AND ownerid="+str(self.UserId)+ \
                " ORDER BY "+orderby

        oRss = oConnExecuteAll(query)

        
            list = []
            for oRs in oRss:
                item = {}
                list.append(item)
                
                mood_delta = 0

            item["planet_img", planetimg(oRs[0], oRs[29])

            item["planet_id", oRs[0]
            item["planet_name", oRs[1]

            item["g", oRs[2]
            item["s", oRs[3]
            item["p", oRs[4]

                # ore
            item["ore", oRs[5]
            item["ore_production", oRs[6]
            item["ore_capacity", oRs[7]

                # compute ore level : ore / capacity
                ore_level = getpercent(oRs[5], oRs[7], 10)

                if ore_level >= 90:
                content.Parse("planet.high_ore"
                elif ore_level >= 70:
                content.Parse("planet.medium_ore"
                else:
                content.Parse("planet.normal_ore"

                # hydrocarbon
            item["hydrocarbon", oRs[8]
            item["hydrocarbon_production", oRs[9]
            item["hydrocarbon_capacity", oRs[10]

                # compute hydrocarbon level : hydrocarbon / capacity
                hydrocarbon_level = getpercent(oRs[8], oRs[10], 10)

                if hydrocarbon_level >= 90:
                content.Parse("planet.high_hydrocarbon"
                elif hydrocarbon_level >= 70:
                content.Parse("planet.medium_hydrocarbon"
                else:
                content.Parse("planet.normal_hydrocarbon"

                # energy
            item["energy", oRs[31]
            item["energy_production", oRs[13]
            item["energy_capacity", oRs[14]

                # compute energy level : energy / capacity
                energy_level = getpercent(oRs[31], oRs[14], 10)

            content.Parse("planet.normal_energy"

                credits = oRs["credits_production") + (oRs["credits_random_production") / 2)# - (oRs["upkeep") / 24)

            item["credits", credits
                if credits < 0:
                content.Parse("planet.credits_minus"
                else:
                content.Parse("planet.credits_plus"

            item["prestige", oRs["production_prestige")

                if oRs[13] < 0:
                content.Parse("planet.negative_energy_production"
                elif oRs[32] >= 0 and oRs[23] >= oRs[28]:
                content.Parse("planet.normal_energy_production"
                else:
                content.Parse("planet.medium_energy_production"

                # workers
            item["workers", oRs[23]
            item["workers_idle", oRs[11]
            item["workers_capacity", oRs[12]

                # soldiers
            item["soldiers", oRs[24]
            item["soldiers_capacity", oRs[25]
            item["soldiers_training", oRs["soldiers_training")
                if oRs["soldiers_training") > 0: .Parse "planet.soldiers_training"

                 # scientists
            item["scientists", oRs[26]
            item["scientists_capacity", oRs[27]
            item["scientists_training", oRs["scientists_training")
                if oRs["scientists_training") > 0: .Parse "planet.scientists_training"

                if oRs[23] < oRs[28]: .Parse "planet.workers_low"

                if oRs[24]*250 < oRs[23]+oRs[26]: .Parse "planet.soldiers_low"

                # mood
                if oRs[30] > 100:
                item["mood", 100
                else:
                item["mood", oRs[30]

                moodlevel = round(oRs[30] / 10) * 10
                if moodlevel > 100: moodlevel = 100

            item["mood_level", moodlevel

                if (oRs[19]): mood_delta = mood_delta + 1

                if oRs[24]*250 >= oRs[23]+oRs[26]:
                    mood_delta = mood_delta + 2
                else:
                    mood_delta = mood_delta - 1

            item["mood_delta", mood_delta
                if mood_delta > 0:
                content.Parse("planet.mood_plus"
                else:
                content.Parse("planet.mood_minus"

                # planet stats
            item["floor_capacity", oRs[15]
            item["floor_occupied", oRs[16]

            item["space_capacity", oRs[17]
            item["space_occupied", oRs[18]

                if oRs[19]:
                item["commander_id", oRs[19]
                item["commander_name", oRs[20]
                content.Parse("planet.commander"
                else:
                content.Parse("planet.nocommander"

                if oRs[21] >= 0 and oRs[23] >= oRs[28]:
                content.Parse("planet.normal_ore_production"
                else:
                content.Parse("planet.medium_ore_production"

                if oRs[22] >= 0 and oRs[23] >= oRs[28]:
                content.Parse("planet.normal_hydrocarbon_production"
                else:
                content.Parse("planet.medium_hydrocarbon_production"

            item["upkeep_credits", oRs["upkeep")
            item["upkeep_workers", oRs["workers_for_maintenance")
            item["upkeep_soldiers", fix((oRs[23]+oRs[26]) / 250)

                if oRs[0] = str(self.CurrentPlanet): .Parse "planet.highlight"

            content.Parse("planet"

        content.Parse(""
        end with

        return self.Display(content)

