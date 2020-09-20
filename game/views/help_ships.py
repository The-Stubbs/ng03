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
    def display_help(self, cat):

        content = self.loadTemplate("help")

        if cat == "buildings":# display help on buildings
            query = "SELECT id, category," + \
                    "cost_ore, cost_hydro, workers, floor, space, production_ore, production_hydro, energy_production, workers*maintenance_factor/100.0, upkeep, energy_consumption," + \
                    "storage_ore, storage_hydro, storage_energy" + \
                    " FROM internal_planet_get_available_buildings(" + str(self.userId) + ") WHERE not is_planet_element"

            rows = dbRows(query)

            category = -1
            lastCategory = -1

            list = []
            content.AssignValue("categories", list)
            for row in rows:
                
                category = row[1]

                if category != lastCategory:
                    categ = {'id': category, 'buildings':[]}
                    list.append(categ)
                    lastCategory = category

                item = {}
                categ['buildings'].append(item)
                
                item["id"] = row[0]
                item["category"] = row[1]
                item["name"] = getBuildingLabel(row[0])
                item["description"] = getBuildingDescription(row[0])

                item["ore"] = row[2]
                item["hydro"] = row[3]
                item["workers"] = row[4]

                item["floor"] = row[5]
                item["space"] = row[6]

                # production
                item["ore_production"] = row[7]
                if row[7] > 0: item["produce_ore"] = True

                item["hydro_production"] = row[8]
                if row[8] > 0: item["produce_hydro"] = True

                item["energy_production"] = row[9]
                if row[9] > 0: item["produce_energy"] = True

                # storage
                item["ore_storage"] = row[13]
                if row[13] > 0: item["storage_ore"] = True

                item["hydro_storage"] = row[14]
                if row[14] > 0: item["storage_hydro"] = True

                item["energy_storage"] = row[15]
                if row[15] > 0: item["storage_energy"] = True

                item["upkeep_workers"] = int(row[10])
                item["upkeep_credits"] = 0
                item["upkeep_energy"] = row[12]

        elif cat == "research":# display help on gm_profile_researches
            query = "SELECT researchid, category, total_cost, level, levels" + \
                    " FROM internal_profile_get_researches_status(" + str(self.userId) + ") WHERE level > 0 OR (researchable AND planet_elements_requirements_met)" + \
                    " ORDER BY category, researchid"

            rows = dbRows(query)

            category = -1
            lastCategory = -1

            list = []
            content.AssignValue("categories", list)
            for row in rows:

                category = row[1]

                if category != lastCategory:
                    categ = {'id': category, 'gm_profile_researches':[]}
                    list.append(categ)
                    lastCategory = category

                item = {}
                categ['gm_profile_researches'].append(item)

                item["id"] = row[0]
                item["name"] = getResearchLabel(row[0])
                item["description"] = getResearchDescription(row[0])

                if row[3] < row[4]:
                    item["cost_credits"] = row[2]
                else:
                    item["cost_credits"] = ""

        elif cat == "ships":# display help on ships
            query = "SELECT id, category, cost_ore, cost_hydro, crew," + \
                    " signature, capacity, handling, speed, weapon_turrets, weapon_dmg_em + weapon_dmg_explosive + weapon_dmg_kinetic + weapon_dmg_thermal AS weapon_power, " + \
                    " weapon_tracking_speed, hull, shield, recycler_output, long_distance_capacity, droppods, cost_energy, upkeep, required_vortex_strength, leadership" + \
                    " FROM internal_planet_get_available_ships(" + str(self.userId) + ") WHERE new_shipid IS NULL"
            oRss = dbDictRows(query)

            category = -1
            lastCategory = -1

            list = []
            content.AssignValue("categories", list)
            for row in rows:

                category = row["category"]

                if category != lastCategory:
                    categ = {'id': category, 'ships':[]}
                    list.append(categ)
                    lastCategory = category

                item = {}
                categ['ships'].append(item)

                item["id"] = row["id"]
                item["category"] = row["category"]
                item["name"] = getShipLabel(row["id"])
                item["description"] = getShipDescription(row["id"])

                item["ore"] = row["cost_ore"]
                item["hydro"] = row["cost_hydro"]
                item["crew"] = row["crew"]
                item["energy"] = row["cost_energy"]

                item["ship_signature"] = row["signature"]
                item["ship_cargo"] = row["capacity"]
                item["ship_handling"] = row["handling"]
                item["ship_speed"] = row["speed"]

                item["ship_upkeep"] = row["upkeep"]

                if row["weapon_power"] > 0:
                    item["ship_turrets"] = row["weapon_turrets"]
                    item["ship_power"] = row["weapon_power"]
                    item["ship_tracking_speed"] = row["weapon_tracking_speed"]
                    item["attack"] = True

                item["ship_hull"] = row["hull"]

                if row["shield"] > 0:
                    item["ship_shield"] = row["shield"]
                    item["shield"] = True

                if row["recycler_output"] > 0:
                    item["ship_recycler_output"] = row["recycler_output"]
                    item["recycler_output"] = True

                if row["long_distance_capacity"] > 0:
                    item["ship_long_distance_capacity"] = row["long_distance_capacity"]
                    item["long_distance_capacity"] = True

                if row["droppods"] > 0:
                    item["ship_droppods"] = row["droppods"]
                    item["droppods"] = True

                item["ship_required_vortex_strength"] = row["required_vortex_strength"]
                item["ship_leadership"] = row["leadership"]

                for i in dtShipBuildingReqs():
                    if i[0] == row["id"]:
                        item["building"] = getBuildingLabel(i[1])
                        item["buildingsrequired"] = True

        content.Parse(cat)
        content.Parse("tabnav")

        return self.display(content)
