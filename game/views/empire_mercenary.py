# -*- coding: utf-8 -*-

from game.views._base import *

#-------------------------------------------------------------------------------
class View(BaseView):

    def dispatch(self, request, *args, **kwargs):

        response = super().pre_dispatch(request, *args, **kwargs)
        if response: return response

        self.selected_menu = "intelligence"

        self.nation_cost_lvl_0 = 250
        self.nation_cost_lvl_1 = 500
        self.nation_cost_lvl_2 = 1000
        self.nation_cost_lvl_3 = 2000

        self.fleets_cost_lvl_0 = 1000
        self.fleets_cost_lvl_1 = 5000
        self.fleets_cost_lvl_2 = 25000
        self.fleets_cost_lvl_3 = 65000

        self.planet_cost_lvl_0 = 50
        self.planet_cost_lvl_1 = 100
        self.planet_cost_lvl_2 = 200
        self.planet_cost_lvl_3 = 400

        self.e_no_error = 0
        self.e_general_error = 1
        self.e_not_enough_money = 2
        self.e_planet_not_exists = 3
        self.e_player_not_exists = 4
        self.e_own_nation_planet = 5

        self.intell_error = self.e_no_error

        #
        # process page
        #

        self.category = 8

        spotted = False

        action = request.POST.get("gm_spyings")
        self.level = ToInt(request.POST.get("level"), -1)

        if action == "nation":
            self.SpyNation()

        elif action == "planet":
            self.SpyPlanet()

        return self.DisplayIntelligence()

    def sqlValue(self, value):
        if value == None:
            sqlValue = "None"
        else:
            sqlValue = "'"+value+"'"

    #
    # display mercenary service page
    #
    def DisplayIntelligence(self):
        content = self.loadTemplate("mercenary-intelligence")

        # Assign service costs
        content.AssignValue("nation_cost_lvl_0", self.nation_cost_lvl_0)
        content.AssignValue("fleets_cost_lvl_0", self.fleets_cost_lvl_0)
        content.AssignValue("planet_cost_lvl_0", self.planet_cost_lvl_0)

        content.AssignValue("nation_cost_lvl_1", self.nation_cost_lvl_1)
        content.AssignValue("fleets_cost_lvl_1", self.fleets_cost_lvl_1)
        content.AssignValue("planet_cost_lvl_1", self.planet_cost_lvl_1)

        content.AssignValue("nation_cost_lvl_2", self.nation_cost_lvl_2)
        content.AssignValue("fleets_cost_lvl_2", self.fleets_cost_lvl_2)
        content.AssignValue("planet_cost_lvl_2", self.planet_cost_lvl_2)

        content.AssignValue("nation_cost_lvl_3", self.nation_cost_lvl_3)
        content.AssignValue("fleets_cost_lvl_3", self.fleets_cost_lvl_3)
        content.AssignValue("planet_cost_lvl_3", self.planet_cost_lvl_3)

        # display errors
        intell_type = self.request.POST.get("gm_spyings", "")

        if self.intell_error != self.e_no_error:
            content.Parse(str(intell_type) + "_error" + str(self.intell_error))
        else:
            content.Parse(str(intell_type) + "_ok")

        return self.display(content)

    # action : type of order
    # self.level : self.level of the recruited gm_spyings, determine spottedChance and -Modifier values
    #  - spottedChance : chance that the gm_spyings has to be spotted per planet/fleet/building spied
    #  - getinfoModifier : chance that the gm_spyings retrieve common info
    #  - getmoreModifier : chance the the gm_spyings retrieve rare info
    # spotted : set to True if gm_spyings has been spotted
    # id : spied user id
    # nation : spied user name

    # self.category : intelligence self.category id for gm_profile_reports.asp
    # type : action id for gm_profile_reports.asp
    # cost : action cost ; determined by action + self.level

    #
    # Retrieve info about a nation
    #
    def SpyNation(self):
        typ = 1

        nation = self.request.POST.get("nation_name", "")
        row = dbRow("SELECT id FROM gm_profiles WHERE (privilege=-2 OR privilege=0) AND upper(login) = upper(" + sqlStr(nation) + ")")
        if row == None:
            self.intell_error = self.e_player_not_exists
            return
        else:
            id = row[0]
            if id == self.userId:
                self.intell_error = self.e_own_nation_planet
                return

        #
        # Begin transaction
        #
        row = dbRow("SELECT user_spying_create('" + str(self.userId) + "', int2(" + str(typ) + "), int2(" + str(self.level) + ") )")
        reportid = row[0]
        if reportid < 0:
            self.intell_error = self.e_general_error
            return

        dbExecute("UPDATE gm_spyings SET target_name=internal_profile_get_name(" + str(id) + ") WHERE id=" + str(reportid))

        nb_planet = 0

        if self.level == 0:
            planet_limit = 5

            spottedChance = 0.6
            getinfoModifier = 0.10
            cost = self.nation_cost_lvl_0
            spyingTime = 25
        elif self.level == 1:
            planet_limit = 15

            spottedChance = 0.3
            getinfoModifier = 0.05
            cost = self.nation_cost_lvl_1
            spyingTime = 30
        elif self.level == 2:
            planet_limit = 0 # no limit

            spottedChance = 0.15
            getinfoModifier = 0.01
            cost = self.nation_cost_lvl_2
            spyingTime = round(60 + random() * 30)
        elif self.level == 3:
            planet_limit = 0 # means no limit

            spottedChance = 0
            getinfoModifier = 0
            cost = self.nation_cost_lvl_3
            spyingTime = round(300 + random() * 150)

        if self.userInfo["prestige_points"] < cost:
            self.intell_error = self.e_not_enough_money
            return

        # test is the gm_spyings is spotted
        spotted = random() < spottedChance

        #
        # retrieve nation planet list and fill report
        #
        query = " SELECT id, name, floor, space, pct_ore, pct_hydrocarbon," + \
                    " COALESCE((SELECT SUM(quantity*signature) " + \
                    " FROM gm_planet_ships " + \
                    " LEFT JOIN dt_ships ON (gm_planet_ships.shipid = dt_ships.id) " + \
                    " WHERE gm_planet_ships.planetid=vw_gm_planets.id),0) " + \
                " FROM vw_gm_planets " + \
                " WHERE ownerid=" + str(id) + \
                " ORDER BY random() "
        oRss = dbRows(query)
        for row in oRss:
            # test if info is retrieved by the gm_spyings (failure probability increase for each new info)
            if planet_limit == 0 or nb_planet < planet_limit:
                # add planet to the gm_spyings report
                query = " INSERT INTO gm_spying_planets(spy_id,  planet_id,  planet_name,  floor,  space, pct_ore, pct_hydrocarbon,  ground) " + \
                        " VALUES("+ str(reportid) +"," + str(row[0]) +"," + sqlStr(row[1]) +"," + str(row[2]) + "," + str(row[3]) + "," + str(row[4]) + "," + str(row[5]) + "," + str(row[6]) +")"
                dbExecute(query)

                nb_planet = nb_planet + 1

        #
        # For veteran gm_spyings, collect additionnal research infos
        #
        if self.level >= 2:
            query = " SELECT researchid, level " + \
                    " FROM internal_profile_get_researches_status(" + str(id) + ") " + \
                    " WHERE level > 0" + \
                    " ORDER BY researchid "
            oRss = dbRows(query)

            for row in oRss:
                # add research info to gm_spyings report
                query = " INSERT INTO gm_spying_researches(spy_id,  research_id,  research_level) " + \
                        " VALUES("+ str(reportid) +", " + str(row[0]) +", " + str(row[1]) +") "
                dbExecute(query)

        #
        # Add gm_spyings gm_profile_reports in report list
        #
        query = " INSERT INTO gm_profile_reports(ownerid, type, subtype, datetime, spyid, description) " + \
                " VALUES(" + str(self.userId) + ", " + str(self.category) + ", " + str(typ*10) + ", now() + " + str(spyingTime + nb_planet) + "*interval '1 minute', " + str(reportid) + ", internal_profile_get_name(" + str(id) + ")) "

        dbExecute(query)

        if spotted and self.request.session.get("privilege", 0) < 100:
            # update report if gm_spyings has been spotted
            query = " UPDATE gm_spyings " + \
                    " SET spotted=" + str(spotted) + \
                    " WHERE id=" + str(reportid) + " AND userid=" + str(self.userId)
            dbExecute(query)

            # add report in spied nation's report list
            query = " INSERT INTO gm_profile_reports(ownerid, type, subtype, datetime, spyid, description) " + \
                    " VALUES(" + str(id) + ", " + str(self.category) + ", " + str(typ) + ", now() + " + str(spyingTime + nb_planet) + "*interval '40 seconds', " + str(reportid) + ", internal_profile_get_name(" + str(self.userId) + ")) "

            dbExecute(query)

        #
        # withdraw the operation cost from player's account
        #
        query = "UPDATE gm_profiles SET prestige_points=prestige_points - " + str(cost) + " WHERE id=" + str(self.userId)

        dbExecute(query)

    #
    # Retrieve info about a planet
    #
    def SpyPlanet(self):

        g = ToInt(self.request.POST.get("g"), 0)
        s = ToInt(self.request.POST.get("s"), 0)
        p = ToInt(self.request.POST.get("p"), 0)

        typ = 3

        if self.request.session.get("privilege", 0) < 100:

            row = dbRow("SELECT ownerid FROM gm_planets WHERE galaxy=" + str(g) + " AND sector=" + str(s) + " AND planet=" + str(p))
    
            if row == None:
                self.intell_error = self.e_planet_not_exists
                return
            elif row[0] == self.userId:
                self.intell_error = self.e_own_nation_planet
                return

        #
        # Begin transaction
        #
        row = dbRow("SELECT user_spying_create('" + str(self.userId) + "', int2(" + str(typ) + "), int2(" + str(self.level) + ") )")
        reportid = row[0]
        if reportid < 0:
            self.intell_error = self.e_general_error
            return

        if self.level == 0:
            spottedChance = 0.6
            getinfoModifier = 0.05
            cost = self.planet_cost_lvl_0
            spyingTime = 5
        elif self.level == 1:
            spottedChance = 0.3
            getinfoModifier = 0.025
            cost = self.planet_cost_lvl_1
            spyingTime = 10
        elif self.level == 2:
            spottedChance = 0.15
            getinfoModifier = 0
            cost = self.planet_cost_lvl_2
            spyingTime = round(20 + random() * 10)
        elif self.level == 3:
            spottedChance = 0
            getinfoModifier = 0
            cost = self.planet_cost_lvl_3
            spyingTime = round(100 + random() * 50)

        if self.userInfo["prestige_points"] < cost:
            self.intell_error = self.e_not_enough_money
            return

        # retrieve planet info list
        query = " SELECT id, name, ownerid, internal_profile_get_name(ownerid), floor, space, floor_occupied, space_occupied,  " + \
                    " COALESCE((SELECT SUM(quantity*signature) " + \
                    " FROM gm_planet_ships " + \
                    " LEFT JOIN dt_ships ON (gm_planet_ships.shipid = dt_ships.id) " + \
                    " WHERE gm_planet_ships.planetid=vw_gm_planets.id),0), " + \
                " ore, hydrocarbon, ore_capacity, hydrocarbon_capacity, ore_production, hydrocarbon_production, " + \
                " energy_consumption, energy_production, " + \
                " radar_strength, radar_jamming, colonization_datetime, orbit_ore, orbit_hydrocarbon, " + \
                " workers, workers_capacity, scientists, scientists_capacity, soldiers, soldiers_capacity, " + \
                " pct_ore, pct_hydrocarbon" + \
                " FROM vw_gm_planets " + \
                " WHERE galaxy=" + str(g) + " AND sector=" + str(s) + " AND planet=" + str(p)

        row = dbRow(query)
        if row == None:
            self.intell_error = self.e_planet_not_exists
            return

        # test is the gm_spyings is spotted
        spotted = random() < spottedChance

        if row:

            planet = row[0]

            if self.request.session.get("privilege", 0) > 100: return

            if row[2]:
            #
            # somebody owns this planet, so the gm_spyings can retrieve several info on it
            #
                # retrieve ownerid and planetname
                id = row[2]
                if row[1]:
                    planetname = sqlStr(row[1])
                else:
                    planetname = "''"

                # set the owner of the planet as the target nation
                dbExecute("UPDATE gm_spyings SET target_name=internal_profile_get_name(" + str(id) + ") WHERE id=" + str(reportid))

                # basic info retrieved by all spies
                query = " INSERT INTO gm_spying_planets(spy_id,  planet_id,  planet_name, owner_name, floor, space, pct_ore, pct_hydrocarbon, ground ) " + \
                        " VALUES ("+ str(reportid) +", " + sqlValue(row[0]) + "," + sqlValue(planetname) +"," + sqlStr(row[3]) +"," + \
                        sqlValue(row[4]) + "," + sqlValue(row[5]) + "," + sqlValue(row[28]) + "," + sqlValue(row[29]) + "," + sqlValue(row[8]) + ")"

                dbExecute(query)

                # common info retrieved by spies which self.level >= 0 (actually, all)
                if self.level >= 0:
                    query = " UPDATE gm_spying_planets SET" + \
                            " radar_strength=" + sqlValue(row[17]) + ", radar_jamming=" + sqlValue(row[18]) + ", " + \
                            " orbit_ore=" + sqlValue(row[20]) + ", orbit_hydrocarbon=" + sqlValue(row[21]) + \
                            " WHERE spy_id=" + str(reportid) + " AND planet_id=" + sqlValue(row[0])

                    dbExecute(query)

                # uncommon info retrieved by skilled spies with self.level >= 1 : ore, hydrocarbon, energy
                if self.level >= 1:
                    query = "UPDATE gm_spying_planets SET" + \
                            " ore=" + sqlValue(row[9]) + ", hydrocarbon=" + sqlValue(row[10]) + \
                            ", ore_capacity=" + sqlValue(row[11]) + ", hydrocarbon_capacity=" + sqlValue(row[12]) + \
                            ", ore_production=" + sqlValue(row[13]) + ", hydrocarbon_production=" + sqlValue(row[14]) + \
                            ", energy_consumption=" + sqlValue(row[15]) + ", energy_production=" + sqlValue(row[16]) + \
                            " WHERE spy_id=" + str(reportid) + " AND planet_id=" + sqlValue(row[0])

                    dbExecute(query)

                if self.level >= 2:
                    #
                    # rare info that can be retrieved by veteran spies only : workers, scientists, soldiers
                    #
                    query = "UPDATE gm_spying_planets SET" + \
                            " workers=" + sqlValue(row[22]) + ", workers_capacity=" + sqlValue(row[23]) + ", " + \
                            " scientists=" + sqlValue(row[24]) + ", scientists_capacity=" + sqlValue(row[25]) + ", " + \
                            " soldiers=" + sqlValue(row[26]) + ", soldiers_capacity=" + sqlValue(row[27]) + \
                            " WHERE spy_id=" + str(reportid) + " AND planet_id=" + sqlValue(row[0])

                    dbExecute(query)

                    #
                    # Add the buildings of the planet under construction
                    #
                    query = "SELECT planetid, id, build_status, quantity, construction_maximum " + \
                            " FROM vw_gm_planet_buildings AS b " + \
                            " WHERE planetid=" + str(planet) + " AND build_status IS NOT NULL"

                    oRss = dbRows(query)
                    for row in oRss:
                        
                        rand1 = random()

                        # test if info is correctly retrieved by the gm_spyings (error probability increase for each new info)
                        qty = row[3]

                        if rand1 < ( getinfoModifier * i ) and row[4] != 1:
                            # if construction_maximum = 1: error is impossible : if there is 1 city, it can't exists more or less
                            # info are always retrieved, but the gm_spyings may give a wrong number of constructions ( actually right number +/- 50% )

                            # calculate maximum and minimum possible numbers of buildings
                            rndmax = int(row[3]*1.5)
                            if rndmax <= row[3]: rndmax = rndmax + 1
                            rndmax = min(rndmax, row[4])
                            rndmin = int(row[3]*0.5)
                            if rndmin < 1: rndmin = 1
                            qty = int((rndmax-rndmin+1)*random()+rndmin)

                        query = "INSERT INTO gm_spying_buildings(spy_id, planet_id, building_id, endtime, quantity) " + \
                                " VALUES (" + str(reportid) + ", " + str(row[0]) + ", " + str(row[1]) + ", now() + " + str(row[2]) + "* interval '1 second', " + str(qty) + " )"

                        dbExecute(query)

                if self.level >= 0:

                    #
                    # Add the buildings of the planet
                    #
                    query = "SELECT planetid, id, quantity, construction_maximum" + \
                            " FROM vw_gm_planet_buildings" + \
                            " WHERE planetid=" + str(planet) + " AND quantity != 0 AND build_status IS NULL AND destruction_time IS NULL"
                    oRss = dbRows(query)
                    i = 0
                    for row in oRss:

                        rand1 = random()

                        # test if info is correctly retrieved by the gm_spyings (error probability increase for each new info)
                        qty = row[2]

                        if rand1 < ( getinfoModifier * i ) and row[3] != 1:
                            # if construction_maximum = 1: error is impossible : if there is 1 city, it can't exists more or less
                            # info are always retrieved, but the gm_spyings may give a wrong number of constructions ( actually right number +/- 50% )

                            # calculate maximum and minimum possible numbers of buildings
                            rndmax = int(row[2]*1.5)
                            if rndmax <= row[2]: rndmax = rndmax + 1
                            rndmax = min(rndmax, row[3])
                            rndmin = int(row[2]*0.5)
                            if rndmin < 1: rndmin = 1
                            qty = int((rndmax-rndmin+1)*random()+rndmin)

                        query = " INSERT INTO gm_spying_buildings(spy_id, planet_id, building_id, quantity) " + \
                                " VALUES(" + str(reportid) + ", " + str(row[0]) + ", " + str(row[1]) + ", " + str(qty) + " )"

                        dbExecute(query)
                        
                        i += 1

            else:
                #
                # nobody own this planet
                #
                query = " INSERT INTO gm_spying_planets(spy_id, planet_id, floor, space) " + \
                        " VALUES("+ str(reportid) +", " + sqlValue(row[0]) +", " + sqlValue(row[4]) +", " + sqlValue(row[5]) +") "
                dbExecute(query)
                return

        #
        # Add gm_spyings gm_profile_reports in report list
        #
        query = " INSERT INTO gm_profile_reports(ownerid, type, subtype, datetime, spyid, planetid) " + \
                " VALUES(" + str(self.userId) + ", " + str(self.category) + ", " + str(typ*10) + ", now()+" + str(spyingTime) + "*interval '1 minute', " + str(reportid) + ", " + str(planet) + ") "

        dbExecute(query)

        # update report if gm_spyings has been spotted
        if spotted and self.request.session.get("privilege", 0) < 100:
            query = "UPDATE gm_spyings SET" + \
                    " spotted=" + str(spotted) + \
                    " WHERE id=" + str(reportid) + " AND userid=" + str(self.userId)

            dbExecute(query)

            # add report in spied nation's report list
            query = " INSERT INTO gm_profile_reports(ownerid, type, subtype, datetime, spyid, planetid, description) " + \
                    " VALUES(" + str(id) + "," + str(self.category) + "," + str(typ) + ", now()+" + str(spyingTime) + "*interval '40 seconds'," + str(reportid) + "," + str(planet) + ", internal_profile_get_name(" + str(self.userId) + "))"

            dbExecute(query)

        #
        # withdraw the operation cost from player's account
        #
        query = "UPDATE gm_profiles SET prestige_points = prestige_points - " + str(cost) + " WHERE id=" + str(self.userId)

        dbExecute(query)
