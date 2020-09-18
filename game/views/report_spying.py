# -*- coding: utf-8 -*-

from game.views._base import *

#-------------------------------------------------------------------------------
class View(BaseView):

    def dispatch(self, request, *args, **kwargs):

        response = super().pre_dispatch(request, *args, **kwargs)
        if response: return response

        self.selected_menu = "intelligence"

        self.id = request.GET.get("id", "")
        if self.id == "":
            return HttpResponseRedirect("/game/gm_profile_reports/")

        self.id = int(self.id)

        key = request.GET.get("key", "")
        if key == "":
            return HttpResponseRedirect("/game/gm_profile_reports/")

        #
        # retrieve report id and info
        #

        query = "SELECT id, key, userid, type, level, date, credits, spotted, target_name" + \
                " FROM gm_spyings" + \
                " WHERE id="+str(self.id)+" AND key="+sqlStr(key)

        row = dbRow(query)

        # check if report exists and if given key is correct otherwise redirect to the gm_profile_reports
        if row == None:
            return HttpResponseRedirect("/game/gm_profile_reports/")

        else:
            #user = row[2]
            typ = row[3]
            self.level = row[4]
            self.spydate = row[5]

            if row[6]: self.credits = row[6]
            self.spotted = row[7]
            if row[8]: self.target = row[8]

        if typ == 1:
            return self.DisplayNation()
        elif typ == 3:
            return self.DisplayPlanet()
        else:
            return HttpResponseRedirect("/game/gm_profile_reports/")

    #
    # display the gm_spyings report of a nation
    #
    def DisplayNation(self):

        # load template
        content = self.loadTemplate("gm_spyings-report")

        #
        # list spied planets
        #
        query = " SELECT spy_id, planet_id, planet_name, gm_spying_planets.floor, gm_spying_planets.space, ground, galaxy, sector, planet, gm_spying_planets.pct_ore, gm_spying_planets.pct_hydrocarbon " + \
                " FROM gm_spying_planets " + \
                " LEFT JOIN gm_planets " + \
                    " ON ( gm_spying_planets.planet_id=gm_planets.id) " + \
                " WHERE spy_id=" + str(self.id)

        oRss = dbRows(query)

        nbplanet = 0

        list = []
        content.AssignValue("planets", list)
        for row in oRss:
            item = {}
            list.append(item)
            
            if row[2]:
                item["planet"] = row[2]
            else:
                item["planet"] = target

            item["g"] = row[6]
            item["s"] = row[7]
            item["p"] = row[8]

            item["floor"] = row[3]
            item["space"] = row[4]
            item["ground"] = row[5]

            item["pct_ore"] = row[9]
            item["pct_hydrocarbon"] = row[10]

            nbplanet = nbplanet + 1

        #
        # list spied technologies
        #
        query = " SELECT category, dt_researches.id, research_level, levels " + \
                " FROM gm_spying_researches " + \
                " LEFT JOIN dt_researches " + \
                    " ON ( gm_spying_researches.research_id=dt_researches.id) " + \
                " WHERE spy_id=" + str(self.id)  + \
                " ORDER BY category, dt_researches.id "

        oRss = dbRows(query)

        nbresearch = 0

        lastCategory = -1

        cats = []
        for row in oRss:

            category = row[0]

            if category != lastCategory:
                cat = { "list":[] }
                cat["id"] = category
                lastCategory = category
                itemCount = 0

            itemCount = itemCount + 1

            item = {}
            item["research"] = getResearchLabel(row[1])
            item["level"] = row[2]
            item["levels"] = row[3]

            nbresearch = nbresearch + 1

            cat["list"].append(item)

        # display spied nation credits if possible
        if credits:
            content.AssignValue("credits", credits)
            content.Parse("credits")

        if nbresearch != 0:
            content.AssignValue("nb_research", nbresearch)
            content.Parse("gm_profile_researches")

        content.AssignValue("date", self.spydate)
        content.AssignValue("nation", self.target)
        content.AssignValue("nb_planet", nbplanet)
        content.AssignValue("level", self.level)

        # spotted is True if our gm_spyings has been spotted while he was doing his job
        if self.spotted: content.Parse("spotted")

        content.Parse("spynation")

        return self.display(content)

    def DisplayPlanet(self):
        content = self.loadTemplate("gm_spyings-report")

        query = " SELECT spy_id,  planet_id,  planet_name,  s.owner_name,  s.floor,  s.space,  s.ground,  s.ore,  s.hydrocarbon,  s.ore_capacity, " + \
                " s.hydrocarbon_capacity,  s.ore_production,  s.hydrocarbon_production,  s.energy_consumption,  s.energy_production,  s.workers,  s.workers_capacity,  s.scientists, " + \
                " s.scientists_capacity,  s.soldiers,  s.soldiers_capacity,  s.radar_strength,  s.radar_jamming,  s.orbit_ore,  " + \
                " s.orbit_hydrocarbon, galaxy, sector, planet, s.pct_ore, s.pct_hydrocarbon " + \
                " FROM gm_spying_planets AS s" + \
                " LEFT JOIN gm_planets " + \
                    " ON ( s.planet_id=gm_planets.id) " + \
                " WHERE spy_id=" + str(self.id)

        row = dbRow(query)

        if row == None:
            return HttpResponseRedirect("/game/gm_profile_reports/")

        planet = row[1]

        # display basic info
        content.AssignValue("name", row[2])
        content.AssignValue("location", str(row[25]) + ":" + str(row[26]) + ":" + str(row[27]))
        content.AssignValue("floor", row[4])
        content.AssignValue("space", row[5])
        content.AssignValue("ground", row[6])

        content.AssignValue("pct_ore", row[28])
        content.AssignValue("pct_hydrocarbon", row[29])

        if row[3]:
            content.AssignValue("owner", row[3])
        else:
            content.Parse("no_owner")

        if row[7]: # display common info
            content.AssignValue("ore", row[7])
            content.AssignValue("hydrocarbon", row[8])
            content.AssignValue("ore_capacity", row[9])
            content.AssignValue("hydrocarbon_capacity", row[10])
            content.AssignValue("ore_prod", row[11])
            content.AssignValue("hydrocarbon_prod", row[12])
            content.AssignValue("energy_consumption", row[13])
            content.AssignValue("energy_prod", row[14])
            content.Parse("common")

        if row[15]: # display rare info
            content.AssignValue("workers", row[15])
            content.AssignValue("workers_cap", row[16])
            content.AssignValue("scientists", row[17])
            content.AssignValue("scientists_cap", row[18])
            content.AssignValue("soldiers", row[19])
            content.AssignValue("soldiers_cap", row[20])
            content.Parse("rare")

        if row[21]: # display uncommon info
            content.AssignValue("radar_strength", row[21])
            content.AssignValue("radar_jamming", row[22])
            content.AssignValue("orbit_ore", row[23])
            content.AssignValue("orbit_hydrocarbon", row[24])
            content.Parse("uncommon")

        # display pending buildings
        query = " SELECT s.building_id, s.quantity, label, s.endtime, category " + \
                " FROM gm_spying_buildings AS s " + \
                " LEFT JOIN dt_buildings " + \
                    " ON (s.building_id=id) " + \
                " WHERE spy_id=" + str(self.id) + " AND planet_id=" + str(planet) + " AND s.endtime IS NOT NULL " + \
                " ORDER BY category, label "

        oRss = dbRows(query)

        if oRss:
            list = []
            content.AssignValue("buildings_pendings", list)
            for row in oRss:
                item = {}
                list.append(item)
                
                item["building"] = row[2]
                item["qty"] = row[1]
                item["endtime"] = row[3]

        # display built buildings
        query = " SELECT s.building_id, s.quantity, label, s.endtime, category " + \
                " FROM gm_spying_buildings AS s " + \
                " LEFT JOIN dt_buildings " + \
                    " ON (s.building_id=id) " + \
                " WHERE spy_id=" + str(self.id) + " AND planet_id=" + str(planet) + " AND s.endtime IS NULL " + \
                " ORDER BY category, label "

        oRss = dbRows(query)

        if oRss:
            list = []
            content.AssignValue("buildings", list)
            for row in oRss:
                item = {}
                list.append(item)
                
                item["building"] = row[2]
                item["qty"] = row[1]

        content.AssignValue("date", self.spydate)
        content.AssignValue("nation", self.target)

        content.AssignValue("level", self.level)

        # spotted is True if our gm_spyings has been spotted while he was doing his job
        if self.spotted: content.Parse("spotted")

        content.Parse("spyplanet")

        return self.display(content)
