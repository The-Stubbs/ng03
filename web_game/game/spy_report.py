# -*- coding: utf-8 -*-

from web_game.game._global import *

class View(GlobalView):

    def dispatch(self, request, *args, **kwargs):

        response = super().pre_dispatch(request, *args, **kwargs)
        if response: return response

        self.selected_menu = "intelligence"

        id = request.GET.get("id")
        if id = "" or not isNumeric(id):
            return HttpResponseRedirect("/game/reports/")

        id = int(id)

        key = request.GET.get("key")
        if key == "":
            return HttpResponseRedirect("/game/reports/")

        #
        # retrieve report id and info
        #

        query = "SELECT id, key, userid, type, level, date, credits, spotted, target_name" + \
                " FROM spy" + \
                " WHERE id="+id+" AND key="+dosql(key)

        oRs = oConnExecute(query)

        # check if report exists and if given key is correct otherwise redirect to the reports
        if oRs == None:
            return HttpResponseRedirect("/game/reports/")

        else:
            #user = oRs[2]
            typ = oRs[3]
            level = oRs[4]
            spydate = oRs[5]

            if oRs[6]: credits = oRs[6]
            spotted = oRs[7]
            if oRs[8]: target = oRs[8]

        if typ == 1:
            return self.DisplayNation()
        elif typ == 2:
            return self.DisplayFleets()
        elif typ == 3:
            return self.DisplayPlanet()
        else:
            return HttpResponseRedirect("/game/reports/")

    #
    # display the spy report of a nation
    #
    def DisplayNation(self):

        # load template
        content = GetTemplate(self.request, "spy-report")

        #
        # list spied planets
        #
        query = " SELECT spy_id, planet_id, planet_name, spy_planet.floor, spy_planet.space, ground, galaxy, sector, planet, spy_planet.pct_ore, spy_planet.pct_hydrocarbon " + \
                " FROM spy_planet " + \
                " LEFT JOIN nav_planet " + \
                    " ON ( spy_planet.planet_id=nav_planet.id) " + \
                " WHERE spy_id=" + id

        oRss = oConnExecuteAll(query)

        nbplanet = 0

        list = []
        for oRs in oRss:
            item = {}
            list.append(item)
            
            if oRs[2]:
                item["planet", oRs[2]
            else:
                item["planet", target

            item["g", oRs[6]
            item["s", oRs[7]
            item["p", oRs[8]

            item["floor", oRs[3]
            item["space", oRs[4]
            item["ground", oRs[5]

            item["pct_ore", oRs[9]
            item["pct_hydrocarbon", oRs[10]

            nbplanet = nbplanet + 1

            content.Parse("nation.planet"

        #
        # list spied technologies
        #
        query = " SELECT category, db_research.id, research_level, levels " + \
                " FROM spy_research " + \
                " LEFT JOIN db_research " + \
                    " ON ( spy_research.research_id=db_research.id) " + \
                " WHERE spy_id=" + id  + \
                " ORDER BY category, db_research.id "

        oRss = oConnExecuteAll(query)

        nbresearch = 0

        if oRs:
            category = oRs[0]
            lastCategory = category

        list = []
        for oRs in oRss:
            item = {}
            list.append(item)
            
            category = oRs[0]

            if category != lastCategory:
                content.Parse("nation.researches.category.category" + lastcategory
                content.Parse("nation.researches.category"
                lastCategory = category
                itemCount = 0

            itemCount = itemCount + 1

            item["research", getResearchLabel(oRs[1])
            item["level", oRs[2]
            item["levels", oRs[3]

            nbresearch = nbresearch + 1

            content.Parse("nation.researches.category.research"

        if itemCount > 0:
            content.Parse("nation.researches.category.category" + category
            content.Parse("nation.researches.category"

        # display spied nation credits if possible
        if not isEmpty(credits):
            content.AssignValue("credits", credits
            content.Parse("nation.credits"

        if nbresearch != 0:
            content.AssignValue("nb_research", nbresearch
            content.Parse("nation.researches"

        content.AssignValue("date", spydate
        content.AssignValue("nation", target
        content.AssignValue("nb_planet", nbplanet
        content.Parse("nation.spy_" + level

        # spotted is True if our spy has been spotted while he was doing his job
        if spotted: content.Parse("nation.spotted"

        content.Parse("nation"

        return self.Display(content)

    def DisplayFleets(self):
        Set content = GetTemplate(self.request, "spy-report")

        if level > 1:
            query = " SELECT fleet_name, galaxy, sector, planet, signature, size, dest_galaxy, dest_sector, dest_planet " + \
                    " FROM spy_fleet " + \
                    " WHERE spy_id=" + id + \
                    " ORDER BY galaxy, sector, planet, fleet_name"
        else:
            query = " SELECT fleet_name, galaxy, sector, planet, signature " + \
                    " FROM spy_fleet " + \
                    " WHERE spy_id=" + id + \
                    " ORDER BY galaxy, sector, planet, fleet_name"

        oRss = oConnExecuteAll(query)

        nbfleet = 0

        list = []
        for oRs in oRss:
            item = {}
            list.append(item)
            
            item["fleet", oRs[0]
            item["location", oRs[1] + "." + oRs[2] + "." + oRs[3]
            item["signature", oRs[4]

            if level > 1:
                if oRs[5]:
                    item["size", oRs[5]
                    content.Parse("fleets.fleet.size"
                else:
                    content.Parse("fleets.fleet.nosize"

                if oRs[6]:
                    item["destination", oRs[6] + "." + oRs[7] + "." + oRs[8]
                    content.Parse("fleets.fleet.dest"
                else:
                    content.Parse("fleets.fleet.nodest"

            else:
                content.Parse("fleets.fleet.nosize"
                content.Parse("fleets.fleet.nodest"

            content.Parse("fleets.fleet"

            nbfleet = nbfleet + 1

        content.AssignValue("date", spydate
        content.AssignValue("nation", target

        content.AssignValue("nb_fleet", nbfleet

        content.Parse("fleets.spy_" + level

        # spotted is True if our spy has been spotted while he was doing his job
        if spotted: content.Parse("fleets.spotted"

        content.Parse("fleets"

        return self.Display(content)

    def DisplayPlanet(self):
        content = GetTemplate(self.request, "spy-report")

        query = " SELECT spy_id,  planet_id,  planet_name,  s.owner_name,  s.floor,  s.space,  s.ground,  s.ore,  s.hydrocarbon,  s.ore_capacity, " + \
                " s.hydrocarbon_capacity,  s.ore_production,  s.hydrocarbon_production,  s.energy_consumption,  s.energy_production,  s.workers,  s.workers_capacity,  s.scientists, " + \
                " s.scientists_capacity,  s.soldiers,  s.soldiers_capacity,  s.radar_strength,  s.radar_jamming,  s.orbit_ore,  " + \
                " s.orbit_hydrocarbon, galaxy, sector, planet, s.pct_ore, s.pct_hydrocarbon " + \
                " FROM spy_planet AS s" + \
                " LEFT JOIN nav_planet " + \
                    " ON ( s.planet_id=nav_planet.id) " + \
                " WHERE spy_id=" + id

        oRs = oConnExecute(query)

        if oRs == None:
            return HttpResponseRedirect("/game/reports/")

        planet = oRs[1]

        # display basic info
        content.AssignValue("name", oRs[2]
        content.AssignValue("location", oRs[25] + ":" + oRs[26] + ":" + oRs[27]
        content.AssignValue("floor", oRs[4]
        content.AssignValue("space", oRs[5]
        content.AssignValue("ground", oRs[6]

        content.AssignValue("pct_ore", oRs[28]
        content.AssignValue("pct_hydrocarbon", oRs[29]

        if oRs[3]:
            content.AssignValue("owner", oRs[3]
            content.Parse("planet.owner"
        else:
            content.Parse("planet.no_owner"

        if oRs[7]: # display common info
            content.AssignValue("ore", oRs[7]
            content.AssignValue("hydrocarbon", oRs[8]
            content.AssignValue("ore_capacity", oRs[9]
            content.AssignValue("hydrocarbon_capacity", oRs[10]
            content.AssignValue("ore_prod", oRs[11]
            content.AssignValue("hydrocarbon_prod", oRs[12]
            content.AssignValue("energy_consumption", oRs[13]
            content.AssignValue("energy_prod", oRs[14]
            content.Parse("planet.common"

        if oRs[15]: # display rare info
            content.AssignValue("workers", oRs[15]
            content.AssignValue("workers_cap", oRs[16]
            content.AssignValue("scientists", oRs[17]
            content.AssignValue("scientists_cap", oRs[18]
            content.AssignValue("soldiers", oRs[19]
            content.AssignValue("soldiers_cap", oRs[20]
            content.Parse("planet.rare"

        if oRs[21]: # display uncommon info
            content.AssignValue("radar_strength", oRs[21]
            content.AssignValue("radar_jamming", oRs[22]
            content.AssignValue("orbit_ore", oRs[23]
            content.AssignValue("orbit_hydrocarbon", oRs[24]
            content.Parse("planet.uncommon"

        # display pending buildings
        query = " SELECT s.building_id, s.quantity, label, s.endtime, category " + \
                " FROM spy_building AS s " + \
                " LEFT JOIN db_buildings " + \
                    " ON (s.building_id=id) " + \
                " WHERE spy_id=" + id + " AND planet_id=" + planet + " AND s.endtime IS NOT None " + \
                " ORDER BY category, label "

        oRss = oConnExecuteAll(query)

        if oRss:
            list = []
            for oRs in oRss:
                item = {}
                list.append(item)
                
                item["building", oRs[2]
                item["qty", oRs[1]
                item["endtime", oRs[3]
                content.Parse("planet.buildings_pending.building"

            content.Parse("planet.buildings_pending"

        # display built buildings
        query = " SELECT s.building_id, s.quantity, label, s.endtime, category " + \
                " FROM spy_building AS s " + \
                " LEFT JOIN db_buildings " + \
                    " ON (s.building_id=id) " + \
                " WHERE spy_id=" + id + " AND planet_id=" + planet + " AND s.endtime IS None " + \
                " ORDER BY category, label "

        oRss = oConnExecuteAll(query)

        if oRss:
            list = []
            for oRs in oRss:
                item = {}
                list.append(item)
                
                item["building", oRs[2]
                item["qty", oRs[1]
                content.Parse("planet.buildings.building"

            content.Parse("planet.buildings"

        content.AssignValue("date", spydate
        content.AssignValue("nation", target

        content.Parse("planet.spy_" + level

        # spotted is True if our spy has been spotted while he was doing his job
        if spotted: content.Parse("planet.spotted"

        content.Parse("planet"

        return self.Display(content)

