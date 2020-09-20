# -*- coding: utf-8 -*-

from game.views._base import *

#-------------------------------------------------------------------------------
class View(BaseView):

    def dispatch(self, request, *args, **kwargs):

        response = super().pre_dispatch(request, *args, **kwargs)
        if response: return response

        self.selected_menu = "production"

        self.showHeader = True

        return self.displayPage(True)

    # Display bonus given by a commander (typ=0), building (typ=1) or a research (typ=2)
    def DisplayBonus(self, oRss, typ):
        for row in rows:
            item = {}
            self.bonuses.append(item)
            
            item["id"] = row[0]
            item["name"] = row[1]

            item["mod_production_ore"] = round(row[2]*100)
            if row[2] > 0:
                item["mod_production_ore"] = "+" + str(round(row[2]*100))
                item["ore_positive"] = True
            elif row[2] < 0:
                item["ore_negative"] = True

            item["mod_production_hydro"] = round(row[3]*100)
            if row[3] > 0:
                item["mod_production_hydro"] = "+" + str(round(row[3]*100))
                item["hydro_positive"] = True
            elif row[3] < 0:
                item["hydro_negative"] = True

            item["mod_production_energy"] = round(row[4]*100)
            if row[4] > 0:
                item["mod_production_energy"] = "+" + str(round(row[4]*100))
                item["energy_positive"] = True
            elif row[4] < 0:
                item["energy_negative"] = True

            if typ == 0:
                item["commander"] = True
            elif typ == 1:
                item["name"] = getBuildingLabel(row[0])
                item["description"] = getBuildingDescription(row[0])
                item["building"] = True
            else:
                item["name"] = getResearchLabel(row[0])
                item["description"] = getResearchDescription(row[0])
                item["level"] = row[5]
                item["research"] = True

            self.BonusCount = self.BonusCount + 1

    def displayOverview(self, RecomputeIfNeeded):
        self.BonusCount = 0

        # Assign total production variables
        query = "SELECT workers, workers_for_maintenance, int4(workers/GREATEST(1.0, workers_for_maintenance)*100), int4(previous_buildings_dilapidation / 100.0)," + \
                " int4(production_percent*100)," + \
                " pct_ore, pct_hydro" + \
                " FROM vw_gm_planets WHERE id=" + str(self.currentPlanetId)
        row = dbRow(query)

        self.content.AssignValue("workers", row[0])
        self.content.AssignValue("workers_required", row[1])
        self.content.AssignValue("production_percent", row[2])

        if row[3] <= 1:
            self.content.Parse("condition_excellent")
        elif row[3] < 20:
            self.content.Parse("condition_good")
        elif row[3] < 45:
            self.content.Parse("condition_fair")
        elif row[3] < 80:
            self.content.Parse("condition_bad")
        else:
            self.content.Parse("condition_catastrophic")

        if row[0] >= row[1]:
            self.content.Parse("repairing")
        else:
            self.content.Parse("decaying")

        self.content.AssignValue("final_production", row[4])

        if RecomputeIfNeeded and row[4] > row[2]:
            dbRow("SELECT internal_planet_update_data(" + str(self.currentPlanetId) + ")")
            return self.displayPage(False)

        self.content.AssignValue("a_ore", row[5])
        self.content.AssignValue("a_hydro", row[6])

        # List buildings that produce a resource : ore, hydro or energy
        query = "SELECT id, production_ore*working_quantity, production_hydro*working_quantity, energy_production*working_quantity, working_quantity" + \
                " FROM vw_gm_planet_buildings" + \
                " WHERE planetid="+str(self.currentPlanetId)+" AND (production_ore > 0 OR production_hydro > 0 OR energy_production > 0) AND working_quantity > 0;"
        rows = dbRows(query)

        totalOre = 0
        totalhydro = 0
        totalEnergy = 0
        buildingCount = 0

        list = []
        self.content.AssignValue("buildings", list)
        for row in rows:
            item = {}
            list.append(item)
            
            item["id"] = row[0]
            item["name"] = getBuildingLabel(row[0])
            item["description"] = getBuildingDescription(row[0])
            item["production_ore"] = int(row[1])
            item["production_hydro"] = int(row[2])
            item["production_energy"] = int(row[3])
            item["quantity"] = row[4]

            totalOre = totalOre + row[1]
            totalhydro = totalhydro + row[2]
            totalEnergy = totalEnergy + row[3]

            buildingCount = buildingCount + 1

        self.bonuses = []
        self.content.AssignValue("bonuses", self.bonuses)

        # Retrieve commander assigned to the planet if any
        query = "SELECT gm_commanders.id, gm_commanders.name," + \
                "gm_commanders.mod_production_ore-1, gm_commanders.mod_production_hydro-1, gm_commanders.mod_production_energy-1" + \
                " FROM gm_commanders INNER JOIN gm_planets ON (gm_commanders.id = gm_planets.commanderid)" + \
                " WHERE gm_planets.id=" + str(self.currentPlanetId)

        row = dbRows(query)

        self.DisplayBonus(row, 0)

        # List production bonus given by buildings
        query = "SELECT buildingid, '', mod_production_ore*quantity, mod_production_hydro*quantity, mod_production_energy*quantity" + \
                " FROM gm_planet_buildings" + \
                "    INNER JOIN dt_buildings ON (dt_buildings.id = gm_planet_buildings.buildingid)" + \
                " WHERE planetid="+str(self.currentPlanetId)+" AND (mod_production_ore != 0 OR mod_production_hydro != 0 OR mod_production_energy != 0)"

        row = dbRows(query)

        self.DisplayBonus(row, 1)

        # List gm_profile_researches that gives production bonus
        query = "SELECT researchid, '', level*mod_production_ore, level*mod_production_hydro, level*mod_production_energy, level" + \
                " FROM gm_profile_researches INNER JOIN dt_researches ON gm_profile_researches.researchid=dt_researches.id" + \
                " WHERE userid=" + str(self.userId) +" AND ((mod_production_ore > 0) OR (mod_production_hydro > 0) OR (mod_production_energy > 0)) AND (level > 0);"

        row = dbRows(query)

        self.DisplayBonus(row, 2)

        # Display buildings def total if there are bonus and more than 1 building that produces resources
        if (self.BonusCount > 0) and (buildingCount > 1):
                self.content.AssignValue("production_ore", int(totalOre))
                self.content.AssignValue("production_hydro", int(totalhydro))
                self.content.AssignValue("production_energy", int(totalEnergy))
                self.content.Parse("subtotal")

        # Retrieve energy received from antennas
        query = "SELECT int4(COALESCE(sum(effective_energy), 0)) FROM gm_planet_energy_transfers WHERE target_planetid=" + str(self.currentPlanetId)
        row = dbRow(query)
        EnergyReceived = row[0]

        # Assign total production variables
        query = "SELECT ore_production, hydro_production, energy_production-"+str(EnergyReceived)+" FROM gm_planets WHERE id=" + str(self.currentPlanetId)
        row = dbRow(query)

        if row:
            # display bonus sub-total
            if self.BonusCount > 0:

                if RecomputeIfNeeded and (row[0]-totalOre < 0 or row[1]-totalhydro < 0 or row[2]-totalEnergy < 0):
                    dbRow("SELECT internal_planet_update_data(" + str(self.currentPlanetId) + ")")
                    return self.displayPage(False)

                self.content.AssignValue("bonus_production_ore", int(row[0]-totalOre))
                self.content.AssignValue("bonus_production_hydro", int(row[1]-totalhydro))
                self.content.AssignValue("bonus_production_energy", int(row[2]-totalEnergy))
                self.content.Parse("bonus")

            self.content.AssignValue("total_production_ore", int(row[0]))
            self.content.AssignValue("total_production_hydro", int(row[1]))
            self.content.AssignValue("total_production_energy", int(row[2]))

        self.content.Parse("overview")
