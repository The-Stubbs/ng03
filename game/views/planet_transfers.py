# -*- coding: utf-8 -*-

from game.views._base import *

class View(BaseView):

    def dispatch(self, request, *args, **kwargs):

        response = super().pre_dispatch(request, *args, **kwargs)
        if response: return response

        self.selectedMenu = "production"

        self.showHeader = True

        return self.displayPage(True)

    # Display bonus given by a commander (typ=0), building (typ=1) or a research (typ=2)
    def DisplayBonus(self, oRss, typ):
        for oRs in oRss:
            item = {}
            self.bonuses.append(item)
            
            item["id"] = oRs[0]
            item["name"] = oRs[1]

            item["mod_production_ore"] = round(oRs[2]*100)
            if oRs[2] > 0:
                item["mod_production_ore"] = "+" + str(round(oRs[2]*100))
                item["ore_positive"] = True
            elif oRs[2] < 0:
                item["ore_negative"] = True

            item["mod_production_hydrocarbon"] = round(oRs[3]*100)
            if oRs[3] > 0:
                item["mod_production_hydrocarbon"] = "+" + str(round(oRs[3]*100))
                item["hydrocarbon_positive"] = True
            elif oRs[3] < 0:
                item["hydrocarbon_negative"] = True

            item["mod_production_energy"] = round(oRs[4]*100)
            if oRs[4] > 0:
                item["mod_production_energy"] = "+" + str(round(oRs[4]*100))
                item["energy_positive"] = True
            elif oRs[4] < 0:
                item["energy_negative"] = True

            if typ == 0:
                item["commander"] = True
            elif typ == 1:
                item["name"] = getBuildingLabel(oRs[0])
                item["description"] = getBuildingDescription(oRs[0])
                item["building"] = True
            else:
                item["name"] = getResearchLabel(oRs[0])
                item["description"] = getResearchDescription(oRs[0])
                item["level"] = oRs[5]
                item["research"] = True

            self.BonusCount = self.BonusCount + 1

    def displayOverview(self, RecomputeIfNeeded):
        self.BonusCount = 0

        # Assign total production variables
        query = "SELECT workers, workers_for_maintenance, int4(workers/GREATEST(1.0, workers_for_maintenance)*100), int4(previous_buildings_dilapidation / 100.0)," + \
                " int4(production_percent*100)," + \
                " pct_ore, pct_hydrocarbon" + \
                " FROM vw_gm_planets WHERE id=" + str(self.currentPlanetId)
        oRs = dbRow(query)

        self.content.AssignValue("workers", oRs[0])
        self.content.AssignValue("workers_required", oRs[1])
        self.content.AssignValue("production_percent", oRs[2])

        if oRs[3] <= 1:
            self.content.Parse("condition_excellent")
        elif oRs[3] < 20:
            self.content.Parse("condition_good")
        elif oRs[3] < 45:
            self.content.Parse("condition_fair")
        elif oRs[3] < 80:
            self.content.Parse("condition_bad")
        else:
            self.content.Parse("condition_catastrophic")

        if oRs[0] >= oRs[1]:
            self.content.Parse("repairing")
        else:
            self.content.Parse("decaying")

        self.content.AssignValue("final_production", oRs[4])

        if RecomputeIfNeeded and oRs[4] > oRs[2]:
            dbRow("SELECT internal_planet_update_data(" + str(self.currentPlanetId) + ")")
            return self.displayPage(False)

        self.content.AssignValue("a_ore", oRs[5])
        self.content.AssignValue("a_hydrocarbon", oRs[6])

        # List buildings that produce a resource : ore, hydrocarbon or energy
        query = "SELECT id, production_ore*working_quantity, production_hydrocarbon*working_quantity, energy_production*working_quantity, working_quantity"+ \
                " FROM vw_gm_planet_buildings" + \
                " WHERE planetid="+str(self.currentPlanetId)+" AND (production_ore > 0 OR production_hydrocarbon > 0 OR energy_production > 0) AND working_quantity > 0;"
        oRss = dbRows(query)

        totalOre = 0
        totalHydrocarbon = 0
        totalEnergy = 0
        buildingCount = 0

        list = []
        self.content.AssignValue("buildings", list)
        for oRs in oRss:
            item = {}
            list.append(item)
            
            item["id"] = oRs[0]
            item["name"] = getBuildingLabel(oRs[0])
            item["description"] = getBuildingDescription(oRs[0])
            item["production_ore"] = int(oRs[1])
            item["production_hydrocarbon"] = int(oRs[2])
            item["production_energy"] = int(oRs[3])
            item["quantity"] = oRs[4]

            totalOre = totalOre + oRs[1]
            totalHydrocarbon = totalHydrocarbon + oRs[2]
            totalEnergy = totalEnergy + oRs[3]

            buildingCount = buildingCount + 1

        self.bonuses = []
        self.content.AssignValue("bonuses", self.bonuses)

        # Retrieve commander assigned to the planet if any
        query = "SELECT gm_commanders.id, gm_commanders.name," + \
                "gm_commanders.mod_production_ore-1, gm_commanders.mod_production_hydrocarbon-1, gm_commanders.mod_production_energy-1" + \
                " FROM gm_commanders INNER JOIN gm_planets ON (gm_commanders.id = gm_planets.commanderid)" + \
                " WHERE gm_planets.id=" + str(self.currentPlanetId)

        oRs = dbRows(query)

        self.DisplayBonus(oRs, 0)

        # List production bonus given by buildings
        query = "SELECT buildingid, '', mod_production_ore*quantity, mod_production_hydrocarbon*quantity, mod_production_energy*quantity" + \
                " FROM gm_planet_buildings" + \
                "    INNER JOIN dt_buildings ON (dt_buildings.id = gm_planet_buildings.buildingid)" + \
                " WHERE planetid="+str(self.currentPlanetId)+" AND (mod_production_ore != 0 OR mod_production_hydrocarbon != 0 OR mod_production_energy != 0)"

        oRs = dbRows(query)

        self.DisplayBonus(oRs, 1)

        # List gm_profile_researches that gives production bonus
        query = "SELECT researchid, '', level*mod_production_ore, level*mod_production_hydrocarbon, level*mod_production_energy, level" + \
                " FROM gm_profile_researches INNER JOIN dt_researches ON gm_profile_researches.researchid=dt_researches.id" + \
                " WHERE userid=" + str(self.userId) +" AND ((mod_production_ore > 0) OR (mod_production_hydrocarbon > 0) OR (mod_production_energy > 0)) AND (level > 0);"

        oRs = dbRows(query)

        self.DisplayBonus(oRs, 2)

        # Display buildings def total if there are bonus and more than 1 building that produces resources
        if (self.BonusCount > 0) and (buildingCount > 1):
                self.content.AssignValue("production_ore", int(totalOre))
                self.content.AssignValue("production_hydrocarbon", int(totalHydrocarbon))
                self.content.AssignValue("production_energy", int(totalEnergy))
                self.content.Parse("subtotal")

        # Retrieve energy received from antennas
        query = "SELECT int4(COALESCE(sum(effective_energy), 0)) FROM gm_planet_energy_transfers WHERE target_planetid=" + str(self.currentPlanetId)
        oRs = dbRow(query)
        EnergyReceived = oRs[0]

        # Assign total production variables
        query = "SELECT ore_production, hydrocarbon_production, energy_production-"+str(EnergyReceived)+" FROM gm_planets WHERE id=" + str(self.currentPlanetId)
        oRs = dbRow(query)

        if oRs:
            # display bonus sub-total
            if self.BonusCount > 0:

                if RecomputeIfNeeded and (oRs[0]-totalOre < 0 or oRs[1]-totalHydrocarbon < 0 or oRs[2]-totalEnergy < 0):
                    dbRow("SELECT internal_planet_update_data(" + str(self.currentPlanetId) + ")")
                    return self.displayPage(False)

                self.content.AssignValue("bonus_production_ore", int(oRs[0]-totalOre))
                self.content.AssignValue("bonus_production_hydrocarbon", int(oRs[1]-totalHydrocarbon))
                self.content.AssignValue("bonus_production_energy", int(oRs[2]-totalEnergy))
                self.content.Parse("bonus")

            self.content.AssignValue("total_production_ore", int(oRs[0]))
            self.content.AssignValue("total_production_hydrocarbon", int(oRs[1]))
            self.content.AssignValue("total_production_energy", int(oRs[2]))

        self.content.Parse("overview")

    def displayManage(self):

        if self.action == "submit":
            query = "SELECT buildingid, quantity - CASE WHEN destroy_datetime IS NULL THEN 0 ELSE 1 END, disabled" + \
                    " FROM gm_planet_buildings" + \
                    "    INNER JOIN dt_buildings ON (gm_planet_buildings.buildingid=dt_buildings.id)" + \
                    " WHERE can_be_disabled AND planetid=" + str(self.currentPlanetId)
            oRss = dbRows(query)
            for oRs in oRss:

                quantity = oRs[1] - ToInt(self.request.POST.get("enabled" + str(oRs[0])), 0)

                query = "UPDATE gm_planet_buildings SET" + \
                        " disabled=LEAST(quantity - CASE WHEN destroy_datetime IS NULL THEN 0 ELSE 1 END, " + str(quantity) + ")" + \
                        "WHERE planetid=" + str(self.currentPlanetId) + " AND buildingid =" + str(oRs[0])
                dbExecute(query)

            return HttpResponseRedirect("/game/production/?cat=" + str(self.cat))

        query = "SELECT buildingid, quantity - CASE WHEN destroy_datetime IS NULL THEN 0 ELSE 1 END, disabled, energy_consumption, int4(workers*maintenance_factor/100.0), upkeep" + \
                " FROM gm_planet_buildings" + \
                "    INNER JOIN dt_buildings ON (gm_planet_buildings.buildingid=dt_buildings.id)" + \
                " WHERE can_be_disabled AND planetid=" + str(self.currentPlanetId) + \
                " ORDER BY buildingid"
        oRss = dbRows(query)

        list = []
        self.content.AssignValue("buildings", list)
        for oRs in oRss:
            if oRs[1] > 0:
                item = {}
                list.append(item)
                
                enabled = oRs[1] - oRs[2]
                quantity = oRs[1] - oRs[2]*0.95

                item["id"] = oRs[0]
                item["building"] = getBuildingLabel(oRs[0])
                item["quantity"] = oRs[1]
                item["energy"] = oRs[3]
                item["maintenance"] = oRs[4]
                item["upkeep"] = oRs[5]
                item["energy_total"] = round(quantity * oRs[3])
                item["maintenance_total"] = round(quantity * oRs[4])
                item["upkeep_total"] = round(quantity * oRs[5])

                if oRs[2] > 0: item["not_all_enabled"] = True

                item["counts"] = []
                for i in range(0, oRs[1] + 1):
                    data = {}
                    data["count"] = i
                    if i == enabled: data["selected"] = True
                    item["enable"] = True
                    item["counts"].append(data)

        self.content.Parse("manage")

    def displayReceiveSendEnergy(self):

        query = "SELECT energy_receive_antennas, energy_send_antennas FROM gm_planets WHERE id=" + str(self.currentPlanetId)
        oRs = dbRow(query)

        max_receive = oRs[0]
        max_send = oRs[1]

        update_planet = False

        if self.action == "cancel":
            energy_from = ToInt(self.request.GET.get("from"), 0)
            energy_to = ToInt(self.request.GET.get("to"), 0)

            if energy_from != 0:
                query = "DELETE FROM gm_planet_energy_transfers WHERE planetid=" + str(energy_from) + " AND target_planetid=" + str(self.currentPlanetId)
            else:
                query = "DELETE FROM gm_planet_energy_transfers WHERE planetid=" + str(self.currentPlanetId) + " AND target_planetid=" + str(energy_to)

            dbExecute(query)

            update_planet = True

            return HttpResponseRedirect("/game/production/?cat=" + str(self.cat))

        elif self.action == "submit":

            query = "SELECT target_planetid, energy, enabled" + \
                    " FROM gm_planet_energy_transfers" + \
                    " WHERE planetid=" + str(self.currentPlanetId)
            oRss = dbRows(query)
            list = []
            for oRs in oRss:
                item = {}
                list.append(item)
                
                query = ""

                I = ToInt(self.request.POST.get("energy_" + str(oRs[0])), 0)
                if I != oRs[1]:
                    query = query + "energy = " + str(I)

                I = self.request.POST.get("enabled_" + str(oRs[0]))
                if I == "1":
                    I = True
                else:
                    I = False

                if I != oRs[2]:
                    if query != "": query = query + ","
                    query = query + "enabled=" + str(I)

                if query != "":
                    query = "UPDATE gm_planet_energy_transfers SET " + query + " WHERE planetid=" + str(self.currentPlanetId) + " AND target_planetid=" + str(oRs[0])
                    dbExecute(query)

                    update_planet = True

            g = ToInt(self.request.POST.get("to_g"), 0)
            s = ToInt(self.request.POST.get("to_s"), 0)
            p = ToInt(self.request.POST.get("to_p"), 0)
            energy = ToInt(self.request.POST.get("energy"), 0)

            if g != 0 and s != 0 and p != 0 and energy > 0:
                query = "INSERT INTO gm_planet_energy_transfers(planetid, target_planetid, energy) VALUES(" + str(self.currentPlanetId) + ", tool_compute_planet_id(" + str(g) + "," + str(s) + "," + str(p) + ")," + str(energy) + ")"
                dbExecute(query)

                update_planet = True

            if update_planet:
                query = "SELECT internal_planet_update_data(" + str(self.currentPlanetId) + ")"
                dbExecute(query)

            return HttpResponseRedirect("/game/production/?cat=" + str(self.cat))

        query = "SELECT t.planetid, internal_planet_get_name(" + str(self.userId) + ", n1.id), internal_profile_get_relation(n1.ownerid," + str(self.userId) + "), n1.galaxy, n1.sector, n1.planet, " + \
                "        t.target_planetid, internal_planet_get_name(" + str(self.userId) + ", n2.id), internal_profile_get_relation(n2.ownerid," + str(self.userId) + "), n2.galaxy, n2.sector, n2.planet, " + \
                "        t.energy, t.effective_energy, enabled" + \
                " FROM gm_planet_energy_transfers t" + \
                "    INNER JOIN gm_planets n1 ON (t.planetid=n1.id)" + \
                "    INNER JOIN gm_planets n2 ON (t.target_planetid=n2.id)" + \
                " WHERE planetid=" + str(self.currentPlanetId) + " OR target_planetid=" + str(self.currentPlanetId) + \
                " ORDER BY not enabled, planetid, target_planetid"
        oRss = dbRows(query)

        receiving = 0
        sending = 0
        sending_enabled = 0

        sents = []
        self.content.AssignValue("sents", sents)
        receiveds = []
        self.content.AssignValue("receiveds", receiveds)
        for oRs in oRss:
            item = {}
            
            item["energy"] = oRs[12]
            item["effective_energy"] = oRs[13]
            item["loss"] = self.getpercent(oRs[12]-oRs[13], oRs[12], 1)

            if oRs[0] == self.currentPlanetId:
                sending = sending + 1
                if oRs[14]: sending_enabled = sending_enabled + 1
                item["planetid"] = oRs[6]
                item["name"] = oRs[7]
                item["rel"] = oRs[8]
                item["g"] = oRs[9]
                item["s"] = oRs[10]
                item["p"] = oRs[11]
                if oRs[14]: item["enabled"] = True
                sents.append(item)
            elif oRs[14]: # if receiving and enabled, display it
                receiving = receiving + 1
                item["planetid"] = oRs[0]
                item["name"] = oRs[1]
                item["rel"] = oRs[2]
                item["g"] = oRs[3]
                item["s"] = oRs[4]
                item["p"] = oRs[5]
                receiveds.append(item)

        self.content.AssignValue("planetid", "")
        self.content.AssignValue("name", "")
        self.content.AssignValue("rel", "")
        self.content.AssignValue("g", "")
        self.content.AssignValue("s", "")
        self.content.AssignValue("p", "")
        self.content.AssignValue("energy", 0)
        self.content.AssignValue("effective_energy", 0)
        self.content.AssignValue("loss", 0)

        self.content.AssignValue("antennas_receive_used", receiving)
        self.content.AssignValue("antennas_receive_total", max_receive)

        self.content.AssignValue("antennas_send_used", sending_enabled)
        self.content.AssignValue("antennas_send_total", max_send)

        if max_send == 0: self.content.Parse("send_no_antenna")
        if max_receive == 0: self.content.Parse("receive_no_antenna")

        if receiving > 0:
            self.content.Parse("cant_send_when_receiving")
            max_send = 0

        if sending_enabled > 0:
            self.content.Parse("cant_receive_when_sending")
            max_receive = 0
        elif receiving == 0 and max_receive > 0:
            self.content.Parse("receiving_none")

        if max_receive > 0: self.content.Parse("receive")
        if max_send - len(sents) > 0: self.content.Parse("send")
        if max_send > 0: self.content.Parse("submit")

        self.content.Parse("sendreceive")

    def displayPage(self, RecomputeIfNeeded):
        self.action = self.request.GET.get("a")
        self.cat = ToInt(self.request.GET.get("cat"), 1)
        if self.cat < 1 or self.cat > 3: self.cat = 1

        self.content = self.loadTemplate("production")
        self.content.AssignValue("cat", self.cat)

        if self.cat == 1:
            self.displayOverview(RecomputeIfNeeded)
            self.content.Parse("cat1_selected")
        elif self.cat == 2:
            response = self.displayManage()
            if response: return response
            self.content.Parse("cat2_selected")
        elif self.cat == 3:
            response = self.displayReceiveSendEnergy()
            if response: return response
            self.content.Parse("cat3_selected")

        self.content.Parse("cat1")
        self.content.Parse("cat2")
        self.content.Parse("cat3")
        self.content.Parse("nav")

        url_extra_params = "cat=" + str(self.cat)

        return self.display(self.content)
