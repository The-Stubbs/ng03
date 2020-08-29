# -*- coding: utf-8 -*-

from web_game.game._global import *

class View(GlobalView):

    def dispatch(self, request, *args, **kwargs):

        response = super().pre_dispatch(request, *args, **kwargs)
        if response: return response

        self.selected_menu = "help"

        retrieveShipsReqCache

        cat = request.GET.get("cat")

        if cat = "" or cat != "buildings" and cat != "research" and cat != "ships" and cat != "tags":
            cat = "general"

        return self.display_help(cat)

    def display_help(self, cat):

        content = GetTemplate(self.request, "help")

        if cat = "buildings":# display help on buildings
                query = "SELECT id, category," + \
                        "cost_ore, cost_hydrocarbon, workers, floor, space, production_ore, production_hydrocarbon, energy_production, workers*maintenance_factor/100.0, upkeep, energy_consumption," + \
                        "storage_ore, storage_hydrocarbon, storage_energy" + \
                        " FROM sp_list_available_buildings(" + str(self.UserId) + ") WHERE not is_planet_element"

                oRss = oConnExecuteAll(query)

                if oRs:
                    category = oRs[1]
                    lastCategory = category

                list = []
                for oRs in oRss:
                    item = {}
                    list.append(item)
                    
                    category = oRs[1]

                    if category != lastCategory:
                        content.Parse cat + ".category.category" + lastcategory
                        content.Parse cat + ".category"
                        lastCategory = category

                    item["id", oRs[0]
                    item["category", oRs[1]
                    item["name", getBuildingLabel(oRs[0])
                    item["description", getBuildingDescription(oRs[0])

                    item["ore", oRs[2]
                    item["hydrocarbon", oRs[3]
                    item["workers", oRs[4]

                    item["floor", oRs[5]
                    item["space", oRs[6]

                    # production
                    item["ore_production", oRs[7]
                    if oRs[7] > 0: content.Parse cat + ".category.building.produce_ore"

                    item["hydrocarbon_production", oRs[8]
                    if oRs[8] > 0: content.Parse cat + ".category.building.produce_hydrocarbon"

                    item["energy_production", oRs[9]
                    if oRs[9] > 0: content.Parse cat + ".category.building.produce_energy"

                    # storage
                    item["ore_storage", oRs[13]
                    if oRs[13] > 0: content.Parse cat + ".category.building.storage_ore"

                    item["hydrocarbon_storage", oRs[14]
                    if oRs[14] > 0: content.Parse cat + ".category.building.storage_hydrocarbon"

                    item["energy_storage", oRs[15]
                    if oRs[15] > 0: content.Parse cat + ".category.building.storage_energy"

                    item["upkeep_workers", oRs[10]
                    item["upkeep_credits", 0'oRs[11]
                    item["upkeep_energy", oRs[12]

                    content.Parse cat + ".category.building"

                    oRs.movenext

                content.Parse cat + ".category.category" + category
                content.Parse cat + ".category"

        elif cat = "research":# display help on researches
                query = "SELECT researchid, category, total_cost, level, levels" + \
                        " FROM sp_list_researches(" + str(self.UserId) + ") WHERE level > 0 OR (researchable AND planet_elements_requirements_met)" + \
                        " ORDER BY category, researchid"

                oRss = oConnExecuteAll(query)

                if oRs:
                    category = oRs[1]
                    lastCategory = category

                list = []
                for oRs in oRss:
                    item = {}
                    list.append(item)
                    
                    category = oRs[1]

                    if category != lastCategory:
                        content.Parse cat + ".category.category" + lastcategory
                        content.Parse cat + ".category"
                        lastCategory = category

                    item["id", oRs[0]
                    item["name", getResearchLabel(oRs[0])
                    item["description", getResearchDescription(oRs[0])

                    if oRs[3] < oRs[4]:
                        item["cost_credits", oRs[2]
                    else:
                        item["cost_credits", ""

                    content.Parse cat + ".category.research_subject"

                    oRs.movenext

                content.Parse cat+".category.category" + category
                content.Parse cat+".category"

        elif cat = "ships":# display help on ships
                query = "SELECT id, category, cost_ore, cost_hydrocarbon, crew," + \
                        " signature, capacity, handling, speed, weapon_turrets, weapon_dmg_em + weapon_dmg_explosive + weapon_dmg_kinetic + weapon_dmg_thermal AS weapon_power, " + \
                        " weapon_tracking_speed, hull, shield, recycler_output, long_distance_capacity, droppods, cost_energy, upkeep, required_vortex_strength, leadership" + \
                        " FROM sp_list_available_ships(" + str(self.UserId) + ") WHERE new_shipid IS None"
                oRss = oConnExecuteAll(query)

                if oRs:
                    category = oRs[1]
                    lastCategory = category

                list = []
                for oRs in oRss:
                    item = {}
                    list.append(item)

                    category = oRs[1]

                    if category != lastCategory:
                        content.Parse cat+".category.category" + lastcategory
                        content.Parse cat+".category"
                        lastCategory = category

                    ShipId = oRs[0]

                    item["id", ShipId
                    item["category", oRs[1]
                    item["name", getShipLabel(oRs[0])
                    item["description", getShipDescription(oRs[0])

                    item["ore", oRs[2]
                    item["hydrocarbon", oRs[3]
                    item["crew", oRs[4]
                    item["energy", oRs["cost_energy")

                    item["ship_signature", oRs["signature")
                    item["ship_cargo", oRs["capacity")
                    item["ship_handling", oRs["handling")
                    item["ship_speed", oRs["speed")

                    item["ship_upkeep", oRs["upkeep")

                    if oRs["weapon_power") > 0:
                        item["ship_turrets", oRs["weapon_turrets")
                        item["ship_power", oRs["weapon_power")
                        item["ship_tracking_speed", oRs["weapon_tracking_speed")
                        content.Parse cat+".category.ship.attack"

                    item["ship_hull", oRs["hull")

                    if oRs["shield") > 0:
                        item["ship_shield", oRs["shield")
                        content.Parse cat+".category.ship.shield"

                    if oRs["recycler_output") > 0:
                        item["ship_recycler_output", oRs["recycler_output")
                        content.Parse cat+".category.ship.recycler_output"

                    if oRs["long_distance_capacity") > 0:
                        item["ship_long_distance_capacity", oRs["long_distance_capacity")
                        content.Parse cat+".category.ship.long_distance_capacity"

                    if oRs["droppods") > 0:
                        item["ship_droppods", oRs["droppods")
                        content.Parse cat+".category.ship.droppods"

                    item["ship_required_vortex_strength", oRs["required_vortex_strength")
                    item["ship_leadership", oRs["leadership")

                    for i = 0 to dbShipsReqCount
                        if dbShipsReqArray(0, i) = ShipId:
                            item["building", getBuildingLabel(dbShipsReqArray(1, i))
                            content.Parse cat+".category.ship.buildingsrequired"

                    content.Parse cat+".category.ship"

                    oRs.movenext

                content.Parse cat+".category.category" + category
                content.Parse cat+".category"

        content.Parse cat
        content.Parse("tabnav."+cat
        content.Parse("tabnav"

        return self.Display(content)

