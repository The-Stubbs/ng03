# -*- coding: utf-8 -*-

from web_game.game._global import *

class View(GlobalView):

    def dispatch(self, request, *args, **kwargs):

        response = super().pre_dispatch(request, *args, **kwargs)
        if response: return response

        self.selected_menu = "intelligence"

        const nation_cost_lvl_0 = 250
        const nation_cost_lvl_1 = 500
        const nation_cost_lvl_2 = 1000
        const nation_cost_lvl_3 = 2000

        const fleets_cost_lvl_0 = 1000
        const fleets_cost_lvl_1 = 5000
        const fleets_cost_lvl_2 = 25000
        const fleets_cost_lvl_3 = 65000

        const planet_cost_lvl_0 = 50
        const planet_cost_lvl_1 = 100
        const planet_cost_lvl_2 = 200
        const planet_cost_lvl_3 = 400

        const e_no_error = 0
        const e_general_error = 1
        const e_not_enough_money = 2
        const e_planet_not_exists = 3
        const e_player_not_exists = 4
        const e_own_nation_planet = 5

        intell_error = e_no_error

        #
        # process page
        #

        if SecurityLevel < 3:
            Response.redirect "/"

        Randomize

        category = 8

        spotted = False

        action = request.POST.get("spy")
        level = ToInt(request.POST.get("level"), 0)

        if action == "nation":
            SpyNation()

        elif action == "fleets":
            SpyFleets()

        elif action == "planet":
            SpyPlanet()

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
        content = GetTemplate(self.request, "mercenary-intelligence")

        # Assign service costs
        content.AssignValue("nation_cost_lvl_0", nation_cost_lvl_0
        content.AssignValue("fleets_cost_lvl_0", fleets_cost_lvl_0
        content.AssignValue("planet_cost_lvl_0", planet_cost_lvl_0

        content.AssignValue("nation_cost_lvl_1", nation_cost_lvl_1
        content.AssignValue("fleets_cost_lvl_1", fleets_cost_lvl_1
        content.AssignValue("planet_cost_lvl_1", planet_cost_lvl_1

        content.AssignValue("nation_cost_lvl_2", nation_cost_lvl_2
        content.AssignValue("fleets_cost_lvl_2", fleets_cost_lvl_2
        content.AssignValue("planet_cost_lvl_2", planet_cost_lvl_2

        content.AssignValue("nation_cost_lvl_3", nation_cost_lvl_3
        content.AssignValue("fleets_cost_lvl_3", fleets_cost_lvl_3
        content.AssignValue("planet_cost_lvl_3", planet_cost_lvl_3

        # display errors
        intell_type = request.POST.get("spy")

        if intell_error != e_no_error:
            content.Parse intell_type + "_error" + intell_error
        else:
            content.Parse intell_type + "_ok"

        return self.Display(content)

    # action : type of order
    # level : level of the recruited spy, determine spottedChance and -Modifier values
    #  - spottedChance : chance that the spy has to be spotted per planet/fleet/building spied
    #  - getinfoModifier : chance that the spy retrieve common info
    #  - getmoreModifier : chance the the spy retrieve rare info
    # spotted : set to True if spy has been spotted
    # id : spied user id
    # nation : spied user name

    # category : intelligence category id for reports.asp
    # type : action id for reports.asp
    # cost : action cost ; determined by action + level

    #
    # Retrieve info about a nation
    #
    def SpyNation(self):

        On Error Resume Next
        err.clear

        typ = 1

        nation = request.POST.get("nation_name")
        oRs = oConnExecute("SELECT id FROM users WHERE (privilege=-2 OR privilege=0) AND upper(login) = upper(" + dosql(nation) + ")")
        if oRs == None:
            intell_error = e_player_not_exists
            return
        else:
            id = oRs[0]
            if id = self.UserId:
                intell_error = e_own_nation_planet
                return

        #
        # Begin transaction
        #
        oConn.BeginTrans

        oRs = oConnExecute("SELECT sp_create_spy('" + str(self.UserId) + "', int2(" + typ + "), int2(" + level + ") )")
        reportid = oRs[0]
        if reportid < 0:
            intell_error = e_general_error
            oConn.RollbackTrans
            return

        oConnDoQuery("UPDATE spy SET target_name=sp_get_user(" + id + ") WHERE id=" + reportid,, AdExecuteNoRecords
        if err.Number != 0:
            intell_error = e_general_error
            oConn.RollbackTrans
            return

        nb_planet = 0

        if level == 0:
            planet_limit = 5

            spottedChance = 0.6
            getinfoModifier = 0.10
            cost = nation_cost_lvl_0
            spyingTime = 25
        elif level == 1:
            planet_limit = 15

            spottedChance = 0.3
            getinfoModifier = 0.05
            cost = nation_cost_lvl_1
            spyingTime = 30
        elif level == 2:
            planet_limit = 0 # no limit

            spottedChance = 0.15
            getinfoModifier = 0.01
            cost = nation_cost_lvl_2
            spyingTime = round(60 + Rnd * 30)
        elif level == 3:
            planet_limit = 0 # means no limit

            spottedChance = 0
            getinfoModifier = 0
            cost = nation_cost_lvl_3
            spyingTime = round(300 + Rnd * 150)

        if self.oPlayerInfo["prestige_points") < cost:
            intell_error = e_not_enough_money
            oConn.RollbackTrans
            return

        # test is the spy is spotted
        spotted = Rnd < spottedChance

        #
        # retrieve nation planet list and fill report
        #
        query = " SELECT id, name, floor, space, pct_ore, pct_hydrocarbon," + \
                    " COALESCE((SELECT SUM(quantity*signature) " + \
                    " FROM planet_ships " + \
                    " LEFT JOIN db_ships ON (planet_ships.shipid = db_ships.id) " + \
                    " WHERE planet_ships.planetid=vw_planets.id),0) " + \
                " FROM vw_planets " + \
                " WHERE ownerid=" + id + \
                " ORDER BY random() "

        oRss = oConnExecuteAll(query)

        i = 0
        list = []
        for oRs in oRss:
            item = {}
            list.append(item)
            
            # test if info is retrieved by the spy (failure probability increase for each new info)
            if planet_limit=0 or nb_planet < planet_limit:
                # add planet to the spy report
                query = " INSERT INTO spy_planet(spy_id,  planet_id,  planet_name,  floor,  space, pct_ore, pct_hydrocarbon,  ground) " + \
                        " VALUES("+ reportid +"," + oRs[0] +"," + dosql(oRs[1]) +"," + oRs[2] + "," + oRs[3] + "," + oRs[4] + "," + oRs[5] + "," + oRs[6] +")"
                oConnExecute query )
                if err.Number != 0:
                    intell_error = e_general_error
                    oConn.RollbackTrans
                    return

                nb_planet = nb_planet + 1

            i = i + 1

        #
        # For veteran spy, collect additionnal research infos
        #
        if level >= 2:
            query = " SELECT researchid, level " + \
                    " FROM sp_list_researches(" + id + ") " + \
                    " WHERE level > 0" + \
                    " ORDER BY researchid "
            oRss = oConnExecuteAll(query)

            list = []
            for oRs in oRss:
                item = {}
                list.append(item)
                
                # add research info to spy report
                query = " INSERT INTO spy_research(spy_id,  research_id,  research_level) " + \
                        " VALUES("+ reportid +", " + oRs[0] +", " + oRs[1] +") "
                oConnExecute query )
                if err.Number != 0:
                    intell_error = e_general_error
                    oConn.RollbackTrans
                    return

                i = i + 1

        #
        # Add spy reports in report list
        #
        query = " INSERT INTO reports(ownerid, type, subtype, datetime, spyid, description) " + \
                " VALUES(" + str(self.UserId) + ", " + category + ", " + typ*10 + ", now() + " + spyingTime + nb_planet + "*interval '1 minute', " + reportid + ", sp_get_user(" + id + ")) "

        oConnExecute query )
        if err.Number != 0:
            intell_error = e_general_error
            oConn.RollbackTrans
            return

        if spotted and self.request.session.get("privilege") < 100:
            # update report if spy has been spotted
            query = " UPDATE spy " + \
                    " SET spotted=" + spotted + \
                    " WHERE id=" + reportid + " AND userid=" + str(self.UserId)

            oConnExecute query )
            if err.Number != 0:
                intell_error = e_general_error
                oConn.RollbackTrans
                return

            # add report in spied nation's report list
            query = " INSERT INTO reports(ownerid, type, subtype, datetime, spyid, description) " + \
                    " VALUES(" + id + ", " + category + ", " + typ + ", now() + " + spyingTime + nb_planet + "*interval '40 seconds', " + reportid + ", sp_get_user(" + str(self.UserId) + ")) "

            oConnExecute query )
            if err.Number != 0:
                intell_error = e_general_error
                oConn.RollbackTrans
                return

        #
        # withdraw the operation cost from player's account
        #
        query = "UPDATE users SET prestige_points=prestige_points - " + cost + " WHERE id=" + str(self.UserId)

        oConnExecute query )
        if err.Number != 0:
            intell_error = e_not_enough_money
            oConn.RollbackTrans
            return

        #
        # Commit transaction
        #
        oConn.CommitTrans

    #
    # Retrieve info about a nation's fleets
    #
    def SpyFleets(self):

        On Error Resume Next
        err.clear

        typ = 2

        nation = request.POST.get("nation_name")
        oRs = oConnExecute("SELECT id FROM users WHERE upper(login)=upper(" + dosql(nation) + ")")
        if oRs == None:
            intell_error = e_player_not_exists
            oConn.RollbackTrans
            return
        else:
            id = oRs[0]

            if id = self.UserId:
                intell_error = e_own_nation_planet
                return

        #
        # Begin transaction
        #
        oConn.BeginTrans

        oRs = oConnExecute("SELECT sp_create_spy('" + str(self.UserId) + "', '" + typ + "', '" + level + "# )")
        reportid = oRs[0]
        if reportid < 0:
            intell_error = e_general_error
            oConn.RollbackTrans
            return

        oConnDoQuery("UPDATE spy SET target_name=sp_get_user(" + id + ") WHERE id=" + reportid,, AdExecuteNoRecords
        if err.Number != 0:
            intell_error = e_general_error
            oConn.RollbackTrans
            return

        if level == 0:
            spottedChance = 0.1
            getinfoModifier = 0.10
            cost = fleets_cost_lvl_0
            spyingTime = 15
        elif level == 1:
            spottedChance = 0.04
            getinfoModifier = 0.05
            cost = fleets_cost_lvl_1
            spyingTime = 30
        elif level == 2:
            spottedChance = 0.01
            getinfoModifier = 0.01
            cost = fleets_cost_lvl_2
            spyingTime = 45
        elif level == 3:
            spottedChance = 0.05
            getinfoModifier = 0
            cost = fleets_cost_lvl_3
            spyingTime = 75

        if self.oPlayerInfo["prestige_points") < cost:
            intell_error = e_not_enough_money
            oConn.RollbackTrans
            return

        sig = 0
        if level == 0:
            sig_limit = 10000
        elif level == 1:
            sig_limit = 30000
        elif level == 2:
            sig_limit = 100000
        elif level == 3:
            sig_limit = 0 # means no limit

        #
        # retrieve nation fleets list and fill report
        #
        query = " SELECT id, name, planet_galaxy, planet_sector, planet_planet, size, signature, " + \
                " destplanet_galaxy, destplanet_sector, destplanet_planet " + \
                " FROM vw_fleets " + \
                " WHERE ownerid=" + id + \
                " ORDER BY random() "

        oRss = oConnExecuteAll(query)

        spotted = Rnd < spottedChance

        i = 0
        list = []
        for oRs in oRss:
            item = {}
            list.append(item)
            
            rand1 = Rnd

            # For veteran spy, collect additionnal destination info for moving fleets
            if level > 1 and oRs[7]:
                query = " INSERT INTO spy_fleet(spy_id, fleet_id, fleet_name, galaxy, sector, planet, size, signature, dest_galaxy, dest_sector, dest_planet) " + \
                        " VALUES ("+ reportid +", " + oRs[0] +", '" + oRs[1] +"', " + oRs[2] +", " + oRs[3] +", " + oRs[4] +", " + oRs[5] +", " + oRs[6] +", " + oRs[7] +", " + oRs[8] +", " + oRs[9] +") "
            else:
                query = " INSERT INTO spy_fleet(spy_id, fleet_id, fleet_name, galaxy, sector, planet, signature) " + \
                        " VALUES ("+ reportid +", " + oRs[0] +", '" + oRs[1] +"', " + oRs[2] +", " + oRs[3] +", " + oRs[4] +", " + oRs[6] +") "

            # test if info is retrieved by the spy (failure probability increase for each new info)
            if rand1 < ( 1 - ( getinfoModifier * i ) ) and (sig_limit=0 or sig < sig_limit):
                # add fleet to the spy report
                oConnDoQuery(query)
                if err.Number != 0:
                    intell_error = e_general_error
                    oConn.RollbackTrans
                    return

                sig = sig + oRs[6]

            i = i + 1

        #
        # Add spy reports in report list
        #
        query = " INSERT INTO reports(ownerid, type, subtype, datetime, spyid, description) " + \
                " VALUES (" + str(self.UserId) + ", " + category + ", " + typ*10 + ", now()+" + round(Spyingtime+log(sig)/log(5)) + "*interval '1 minute', " + reportid + ", sp_get_user(" + id + ")) "

        oConnExecute query )
        if err.Number != 0:
            intell_error = e_general_error
            oConn.RollbackTrans
            return

        # update report if spy has been spotted
        if spotted and self.request.session.get("privilege") < 100:
            query = " UPDATE spy SET spotted=" + spotted + \
                    " WHERE id=" + reportid + " AND userid=" + str(self.UserId)

            oConnExecute query )
            if err.Number != 0:
                intell_error = e_general_error
                oConn.RollbackTrans
                return

            # add report in spied nation's report list
            query = " INSERT INTO reports(ownerid, type, subtype, datetime, spyid, description) " + \
                    " VALUES (" + id + ", " + category + ", " + typ + ", now()+" + round(Spyingtime+log(sig)/log(5)) + "*interval '30 seconds', " + reportid + ", sp_get_user(" + str(self.UserId) + ")) "

            oConnExecute query )
            if err.Number != 0:
                intell_error = e_general_error
                oConn.RollbackTrans
                return

        #
        # withdraw the operation cost from player's account
        #
        query = "UPDATE users SET prestige_points = prestige_points - " + cost + " WHERE id=" + str(self.UserId)

        oConnExecute query )
        if err.Number != 0:
            intell_error = e_not_enough_money
            oConn.RollbackTrans
            return

        #
        # Commit transaction
        #
        oConn.CommitTrans

    #
    # Retrieve info about a planet
    #
    def SpyPlanet(self):

        g = ToInt(request.POST.get("g"), 0)
        s = ToInt(request.POST.get("s"), 0)
        p = ToInt(request.POST.get("p"), 0)

        On Error Resume Next
        err.clear

        typ = 3

    #    if self.request.session.get("privilege") > 100: response.write "1"

        if self.request.session.get("privilege") < 100:

        oRs = oConnExecute("SELECT ownerid FROM nav_planet WHERE galaxy=" + g + " AND sector=" + s + " AND planet=" + p)

        if oRs == None:
            intell_error = e_planet_not_exists
            return
        elif oRs[0] = self.UserId:
            intell_error = e_own_nation_planet
            return

        #
        # Begin transaction
        #
        oConn.BeginTrans

        oRs = oConnExecute("SELECT sp_create_spy('" + str(self.UserId) + "', int2(" + typ + "), int2(" + level + ") )")
        reportid = oRs[0]
        if reportid < 0:
            intell_error = e_general_error
            oConn.RollbackTrans
            return

        if level == 0:
            spottedChance = 0.6
            getinfoModifier = 0.05
            cost = planet_cost_lvl_0
            spyingTime = 5
        elif level == 1:
            spottedChance = 0.3
            getinfoModifier = 0.025
            cost = planet_cost_lvl_1
            spyingTime = 10
        elif level == 2:
            spottedChance = 0.15
            getinfoModifier = 0
            cost = planet_cost_lvl_2
            spyingTime = round(20 + Rnd * 10)
        elif level == 3:
            spottedChance = 0
            getinfoModifier = 0
            cost = planet_cost_lvl_3
            spyingTime = round(100 + Rnd * 50)

        if self.oPlayerInfo["prestige_points") < cost:
            intell_error = e_not_enough_money
            oConn.RollbackTrans
            return

        # retrieve planet info list
        query = " SELECT id, name, ownerid, sp_get_user(ownerid), floor, space, floor_occupied, space_occupied,  " + \
                    " COALESCE((SELECT SUM(quantity*signature) " + \
                    " FROM planet_ships " + \
                    " LEFT JOIN db_ships ON (planet_ships.shipid = db_ships.id) " + \
                    " WHERE planet_ships.planetid=vw_planets.id),0), " + \
                " ore, hydrocarbon, ore_capacity, hydrocarbon_capacity, ore_production, hydrocarbon_production, " + \
                " energy_consumption, energy_production, " + \
                " radar_strength, radar_jamming, colonization_datetime, orbit_ore, orbit_hydrocarbon, " + \
                " workers, workers_capacity, scientists, scientists_capacity, soldiers, soldiers_capacity, " + \
                " pct_ore, pct_hydrocarbon" + \
                " FROM vw_planets " + \
                " WHERE galaxy=" + g + " AND sector=" + s + " AND planet=" + p

        oRs = oConnExecute(query)
        if oRs == None:
            intell_error = e_planet_not_exists
            oConn.RollbackTrans
            return

        # test is the spy is spotted
        spotted = Rnd < spottedChance

        if oRs:

            planet = oRs[0]

            if self.request.session.get("privilege") > 100: response.write "4"

            if oRs[2]:
            #
            # somebody owns this planet, so the spy can retrieve several info on it
            #
                # retrieve ownerid and planetname
                id = oRs[2]
                if oRs[1]:
                    planetname = dosql(oRs[1])
                else:
                    planetname = "''"

                # set the owner of the planet as the target nation
                oConnDoQuery("UPDATE spy SET target_name=sp_get_user(" + id + ") WHERE id=" + reportid,, AdExecuteNoRecords
                if err.Number != 0:
                    intell_error = e_general_error
                    oConn.RollbackTrans
                    return

                # basic info retrieved by all spies
                query = " INSERT INTO spy_planet(spy_id,  planet_id,  planet_name, owner_name, floor, space, pct_ore, pct_hydrocarbon, ground ) " + \
                        " VALUES ("+ reportid +", " + sqlValue(oRs[0]) + "," + planetname +"," + sqlValue(oRs[3]) +"," + \
                        sqlValue(oRs[4]) + "," + sqlValue(oRs[5]) + "," + sqlValue(oRs[28]) + "," + sqlValue(oRs[29]) + "," + sqlValue(oRs[8]) + ")"

                oConnDoQuery(query)
                if err.Number != 0:
                    intell_error = e_general_error
                    oConn.RollbackTrans
                    return

                # common info retrieved by spies which level >= 0 (actually, all)
                if level >= 0:
                    query = " UPDATE spy_planet SET"+ \
                            " radar_strength=" + sqlValue(oRs[17]) + ", radar_jamming=" + sqlValue(oRs[18]) + ", " + \
                            " orbit_ore=" + sqlValue(oRs[20]) + ", orbit_hydrocarbon=" + sqlValue(oRs[21]) + \
                            " WHERE spy_id=" + reportid + " AND planet_id=" + sqlValue(oRs[0])

                    oConnExecute query,, adExecuteNoRecords
                    if err.Number != 0:
                        intell_error = e_general_error
                        oConn.RollbackTrans
                        return

                # uncommon info retrieved by skilled spies with level >= 1 : ore, hydrocarbon, energy
                if level >= 1:
                    query = "UPDATE spy_planet SET"+ \
                            " ore=" + sqlValue(oRs[9]) + ", hydrocarbon=" + sqlValue(oRs[10]) + \
                            ", ore_capacity=" + sqlValue(oRs[11]) + ", hydrocarbon_capacity=" + sqlValue(oRs[12]) + \
                            ", ore_production=" + sqlValue(oRs[13]) + ", hydrocarbon_production=" + sqlValue(oRs[14]) + \
                            ", energy_consumption=" + sqlValue(oRs[15]) + ", energy_production=" + sqlValue(oRs[16]) + \
                            " WHERE spy_id=" + reportid + " AND planet_id=" + sqlValue(oRs[0])

                    oConnExecute query,, adExecuteNoRecords
                    if err.Number != 0:
                        intell_error = e_general_error
                        oConn.RollbackTrans
                        return

                if level >= 2:
                    #
                    # rare info that can be retrieved by veteran spies only : workers, scientists, soldiers
                    #
                    query = "UPDATE spy_planet SET"+ \
                            " workers=" + sqlValue(oRs[22]) + ", workers_capacity=" + sqlValue(oRs[23]) + ", " + \
                            " scientists=" + sqlValue(oRs[24]) + ", scientists_capacity=" + sqlValue(oRs[25]) + ", " + \
                            " soldiers=" + sqlValue(oRs[26]) + ", soldiers_capacity=" + sqlValue(oRs[27]) + \
                            " WHERE spy_id=" + reportid + " AND planet_id=" + sqlValue(oRs[0])

                    oConnExecute query,, adExecuteNoRecords
                    if err.Number != 0:
                        intell_error = e_general_error
                        oConn.RollbackTrans
                        return

                    #
                    # Add the buildings of the planet under construction
                    #
                    query = "SELECT planetid, id, build_status, quantity, construction_maximum " + \
                            " FROM vw_buildings AS b " + \
                            " WHERE planetid=" + planet + " AND build_status IS NOT None"

                    oRss = oConnExecuteAll(query)
                    if err.Number != 0:
                        intell_error = e_general_error
                        oConn.RollbackTrans
                        return

                    i=0
                    list = []
                    for oRs in oRss:
                        item = {}
                        list.append(item)
                        
                        rand1 = Rnd

                        # test if info is correctly retrieved by the spy (error probability increase for each new info)
                        qty = oRs[3]

                        if rand1 < ( getinfoModifier * i ) and oRs[4] != 1:
                            # if construction_maximum = 1: error is impossible : if there is 1 city, it can't exists more or less
                            # info are always retrieved, but the spy may give a wrong number of constructions ( actually right number +/- 50% )

                            # calculate maximum and minimum possible numbers of buildings
                            rndmax = int(oRs[3]*1.5)
                            if rndmax <= oRs[3]: rndmax = rndmax + 1
                            rndmax = Min(rndmax, oRs[4])
                            rndmin = int(oRs[3]*0.5)
                            if rndmin < 1: rndmin = 1
                            qty = Int((rndmax-rndmin+1)*Rnd+rndmin)

                        query = "INSERT INTO spy_building(spy_id, planet_id, building_id, endtime, quantity) " + \
                                " VALUES (" + reportid + ", " + oRs[0] + ", " + oRs[1] + ", now() + " + oRs[2] + "* interval '1 second', " + qty + " )"

                        oConnDoQuery(query)
                        if err.Number != 0:
                            intell_error = e_general_error
                            oConn.RollbackTrans
                            return

                        i = i + 1

                if level >= 0:

                    #
                    # Add the buildings of the planet
                    #
                    query = "SELECT planetid, id, quantity, construction_maximum" + \
                            " FROM vw_buildings" + \
                            " WHERE planetid=" + planet + " AND quantity != 0 AND build_status IS None AND destruction_time IS None"
                    oRss = oConnExecuteAll(query)
                    if err.Number != 0:
                        intell_error = e_general_error
                        oConn.RollbackTrans
                        return

                    list = []
                    for oRs in oRss:
                        item = {}
                        list.append(item)
                        
                        rand1 = Rnd

                        # test if info is correctly retrieved by the spy (error probability increase for each new info)
                        qty = oRs[2]

                        if rand1 < ( getinfoModifier * i ) and oRs[3] != 1:
                            # if construction_maximum = 1: error is impossible : if there is 1 city, it can't exists more or less
                            # info are always retrieved, but the spy may give a wrong number of constructions ( actually right number +/- 50% )

                            # calculate maximum and minimum possible numbers of buildings
                            rndmax = int(oRs[2]*1.5)
                            if rndmax <= oRs[2]: rndmax = rndmax + 1
                            rndmax = Min(rndmax, oRs[3])
                            rndmin = int(oRs[2]*0.5)
                            if rndmin < 1: rndmin = 1
                            qty = Int((rndmax-rndmin+1)*Rnd+rndmin)

                        query = " INSERT INTO spy_building(spy_id, planet_id, building_id, quantity) " + \
                                " VALUES(" + reportid + ", " + oRs[0] + ", " + oRs[1] + ", " + qty + " )"

                        oConnDoQuery(query)
                        if err.Number != 0:
                            intell_error = e_general_error
                            oConn.RollbackTrans
                            return

                        i = i + 1

            else:
                #
                # nobody own this planet
                #
                query = " INSERT INTO spy_planet(spy_id, planet_id, floor, space) " + \
                        " VALUES("+ reportid +", " + sqlValue(oRs[0]) +", " + sqlValue(oRs[4]) +", " + sqlValue(oRs[5]) +") "
                oConnExecute query ,, adExecuteNoRecords
                if err.Number != 0:
                    intell_error = e_general_error
                    oConn.RollbackTrans
                    return

        #
        # Add spy reports in report list
        #
        query = " INSERT INTO reports(ownerid, type, subtype, datetime, spyid, planetid) " + \
                " VALUES(" + str(self.UserId) + ", " + category + ", " + typ*10 + ", now()+" + spyingTime + "*interval '1 minute', " + reportid + ", " + planet + ") "

        oConnExecute query )
        if err.Number != 0:
            intell_error = e_general_error
            oConn.RollbackTrans
            return

        # update report if spy has been spotted
        if spotted and self.request.session.get("privilege") < 100:
            query = "UPDATE spy SET" + \
                    " spotted=" + spotted + \
                    " WHERE id=" + reportid + " AND userid=" + str(self.UserId)

            oConnDoQuery(query)
            if err.Number != 0:
                intell_error = e_general_error
                oConn.RollbackTrans
                return

            # add report in spied nation's report list
            query = " INSERT INTO reports(ownerid, type, subtype, datetime, spyid, planetid, description) " + \
                    " VALUES(" + id + "," + category + "," + typ + ", now()+" + spyingTime + "*interval '40 seconds'," + reportid + "," + planet + ", sp_get_user(" + str(self.UserId) + "))"

            oConnExecute query )
            if err.Number != 0:
                intell_error = e_general_error
                oConn.RollbackTrans
                return

        #
        # withdraw the operation cost from player's account
        #
        query = "UPDATE users SET prestige_points = prestige_points - " + cost + " WHERE id=" + str(self.UserId)

        oConnExecute query )
        if err.Number != 0:
            intell_error = e_not_enough_money
            oConn.RollbackTrans
            return

        #
        # Commit transaction
        #
        oConn.CommitTrans

