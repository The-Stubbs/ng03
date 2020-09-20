# -*- coding: utf-8 -*-

from game.views._base import *

#-------------------------------------------------------------------------------
class View(BaseView):

    success_url = "/game/empire-mercenary/"
    template_name = "empire-mercenary"
    selected_menu = "mercenary"

    #---------------------------------------------------------------------------
    def dispatch(self, request, *args, **kwargs):

        response = super().pre_dispatch(request, *args, **kwargs)
        if response: return response

        self.nation_cost_lvl_0 = 250
        self.nation_cost_lvl_1 = 500
        self.nation_cost_lvl_2 = 1000
        self.nation_cost_lvl_3 = 2000

        self.planet_cost_lvl_0 = 50
        self.planet_cost_lvl_1 = 100
        self.planet_cost_lvl_2 = 200
        self.planet_cost_lvl_3 = 400
        
        return super().dispatch(request, *args, **kwargs)

    #---------------------------------------------------------------------------
    def processAction(self, request, action):

        if action == "nation":
            
            level = ToInt(request.POST.get("level"), -1)
            nation = request.POST.get("nation_name","").strip()
            
            row = dbRow("SELECT id FROM gm_profiles WHERE (privilege=-2 OR privilege=0) AND upper(login) = upper(" + sqlStr(nation) + ")")
            if row == None:
                return -1
                
            id = row[0]
            if id == self.userId:
                return -2

            nb_planet = 0

            if level == 0:
                planet_limit = 5
                spottedChance = 0.6
                getinfoModifier = 0.10
                cost = self.nation_cost_lvl_0
                spyingTime = 25
                
            elif level == 1:
                planet_limit = 15
                spottedChance = 0.3
                getinfoModifier = 0.05
                cost = self.nation_cost_lvl_1
                spyingTime = 30
                
            elif level == 2:
                planet_limit = 0
                spottedChance = 0.15
                getinfoModifier = 0.01
                cost = self.nation_cost_lvl_2
                spyingTime = round(60 + random() * 30)
                
            elif level == 3:
                planet_limit = 0
                spottedChance = 0
                getinfoModifier = 0
                cost = self.nation_cost_lvl_3
                spyingTime = round(300 + random() * 150)

            if self.userInfo["prestige_points"] < cost:
                return -3

            row = dbRow("SELECT user_spying_create('" + str(self.userId) + "', int2(1), int2(" + str(level) + ") )")
            reportid = row[0]
            if reportid < 0:
                return -4

            dbExecute("UPDATE gm_spyings SET target_name=internal_profile_get_name(" + str(id) + ") WHERE id=" + str(reportid))

            spotted = random() < spottedChance

            query = " SELECT id, name, floor, space, pct_ore, pct_hydro," + \
                    " COALESCE((SELECT SUM(quantity*signature)" + \
                    " FROM gm_planet_ships " + \
                    "   LEFT JOIN dt_ships ON (gm_planet_ships.shipid = dt_ships.id)" + \
                    " WHERE gm_planet_ships.planetid=vw_gm_planets.id),0)" + \
                    " FROM vw_gm_planets " + \
                    " WHERE ownerid=" + str(id) + \
                    " ORDER BY random()"
            rows = dbRows(query)
            for row in rows:
                if planet_limit == 0 or nb_planet < planet_limit:
                
                    query = " INSERT INTO gm_spying_planets(spy_id,  planet_id,  planet_name,  floor,  space, pct_ore, pct_hydro,  ground)" + \
                            " VALUES(" + str(reportid) + "," + str(row[0]) + "," + sqlStr(row[1]) + "," + str(row[2]) + "," + str(row[3]) + "," + str(row[4]) + "," + str(row[5]) + "," + str(row[6]) + ")"
                    dbExecute(query)

                    nb_planet = nb_planet + 1

            if level >= 2:
            
                query = " SELECT researchid, level " + \
                        " FROM internal_profile_get_researches_status(" + str(id) + ")" + \
                        " WHERE level > 0" + \
                        " ORDER BY researchid "
                rows = dbRows(query)
                for row in rows:

                    query = " INSERT INTO gm_spying_researches(spy_id,  research_id,  research_level)" + \
                            " VALUES("+ str(reportid) + "," + str(row[0]) + "," + str(row[1]) +")"
                    dbExecute(query)

            query = " INSERT INTO gm_profile_reports(ownerid, type, subtype, datetime, spyid, description)" + \
                    " VALUES(" + str(self.userId) + ",8,10, now() + " + str(spyingTime + nb_planet) + "*interval '1 minute', " + str(reportid) + ", internal_profile_get_name(" + str(id) + "))"
            dbExecute(query)

            if spotted:

                query = " UPDATE gm_spyings " + \
                        " SET spotted=" + str(spotted) + \
                        " WHERE id=" + str(reportid) + " AND userid=" + str(self.userId)
                dbExecute(query)

                query = " INSERT INTO gm_profile_reports(ownerid, type, subtype, datetime, spyid, description)" + \
                        " VALUES(" + str(id) + ",8,1, now() + " + str(spyingTime + nb_planet) + "*interval '40 seconds', " + str(reportid) + ", internal_profile_get_name(" + str(self.userId) + "))"
                dbExecute(query)

            query = "UPDATE gm_profiles SET prestige_points=prestige_points - " + str(cost) + " WHERE id=" + str(self.userId)
            dbExecute(query)
            
            return 0

        elif action == "planet":
        
            level = ToInt(request.POST.get("level"), -1)
            g = ToInt(request.POST.get("g"), 0)
            s = ToInt(request.POST.get("s"), 0)
            p = ToInt(request.POST.get("p"), 0)

            row = dbRow("SELECT ownerid FROM gm_planets WHERE galaxy=" + str(g) + " AND sector=" + str(s) + " AND planet=" + str(p))
            if row == None:
                return -1
                
            if row[0] == self.userId:
                return -2

            if level == 0:
                spottedChance = 0.6
                getinfoModifier = 0.05
                cost = self.planet_cost_lvl_0
                spyingTime = 5
                
            elif level == 1:
                spottedChance = 0.3
                getinfoModifier = 0.025
                cost = self.planet_cost_lvl_1
                spyingTime = 10
                
            elif level == 2:
                spottedChance = 0.15
                getinfoModifier = 0
                cost = self.planet_cost_lvl_2
                spyingTime = round(20 + random() * 10)
                
            elif level == 3:
                spottedChance = 0
                getinfoModifier = 0
                cost = self.planet_cost_lvl_3
                spyingTime = round(100 + random() * 50)

            if self.userInfo["prestige_points"] < cost:
                return -3

            query = "SELECT id, name, ownerid, internal_profile_get_name(ownerid), floor, space, floor_occupied, space_occupied,  " + \
                    " COALESCE((SELECT SUM(quantity*signature)" + \
                    " FROM gm_planet_ships " + \
                    "   LEFT JOIN dt_ships ON (gm_planet_ships.shipid = dt_ships.id)" + \
                    " WHERE gm_planet_ships.planetid=vw_gm_planets.id),0), " + \
                    " ore, hydro, ore_capacity, hydro_capacity, ore_production, hydro_production, " + \
                    " energy_consumption, energy_production, " + \
                    " radar_strength, radar_jamming, colonization_datetime, orbit_ore, orbit_hydro, " + \
                    " workers, workers_capacity, scientists, scientists_capacity, soldiers, soldiers_capacity, " + \
                    " pct_ore, pct_hydro" + \
                    " FROM vw_gm_planets " + \
                    " WHERE galaxy=" + str(g) + " AND sector=" + str(s) + " AND planet=" + str(p)
            row = dbRow(query)
            if row == None:
                return -4

            row = dbRow("SELECT user_spying_create('" + str(self.userId) + "', int2(3), int2(" + str(level) + "))")
            reportid = row[0]
            if reportid < 0:
                return -5

            spotted = random() < spottedChance

            planet = row[0]

            if row[2]:

                if row[1]: planetname = sqlStr(row[1])
                else: planetname = "''"

                dbExecute("UPDATE gm_spyings SET target_name=internal_profile_get_name(" + str(row[2]) + ") WHERE id=" + str(reportid))

                query = " INSERT INTO gm_spying_planets(spy_id,  planet_id,  planet_name, owner_name, floor, space, pct_ore, pct_hydro, ground )" + \
                        " VALUES ("+ str(reportid) +"," + sqlValue(row[0]) + "," + sqlValue(planetname) +"," + sqlStr(row[3]) +"," + \
                        sqlValue(row[4]) + "," + sqlValue(row[5]) + "," + sqlValue(row[28]) + "," + sqlValue(row[29]) + "," + sqlValue(row[8]) + ")"
                dbExecute(query)

                if level >= 0:
                
                    query = " UPDATE gm_spying_planets SET" + \
                            " radar_strength=" + sqlValue(row[17]) + ", radar_jamming=" + sqlValue(row[18]) + "," + \
                            " orbit_ore=" + sqlValue(row[20]) + ", orbit_hydro=" + sqlValue(row[21]) + \
                            " WHERE spy_id=" + str(reportid) + " AND planet_id=" + sqlValue(row[0])
                    dbExecute(query)

                    query = "SELECT planetid, id, quantity, construction_maximum" + \
                            " FROM vw_gm_planet_buildings" + \
                            " WHERE planetid=" + str(row[0]) + " AND quantity != 0 AND build_status IS NULL AND destruction_time IS NULL"
                    rows = dbRows(query)
                    for row in rows:

                        qty = row[2]

                        if random() < (getinfoModifier * i) and row[3] != 1:

                            rndmax = int(row[2] * 1.5)
                            if rndmax <= row[2]: rndmax = rndmax + 1
                            rndmax = min(rndmax, row[3])
                            rndmin = int(row[2] * 0.5)
                            if rndmin < 1: rndmin = 1
                            qty = int((rndmax - rndmin + 1) * random() + rndmin)

                        query = " INSERT INTO gm_spying_buildings(spy_id, planet_id, building_id, quantity)" + \
                                " VALUES(" + str(reportid) + "," + str(row[0]) + "," + str(row[1]) + "," + str(qty) + " )"
                        dbExecute(query)
                        
                if level >= 1:
                
                    query = "UPDATE gm_spying_planets SET" + \
                            " ore=" + sqlValue(row[9]) + ", hydro=" + sqlValue(row[10]) + \
                            ", ore_capacity=" + sqlValue(row[11]) + ", hydro_capacity=" + sqlValue(row[12]) + \
                            ", ore_production=" + sqlValue(row[13]) + ", hydro_production=" + sqlValue(row[14]) + \
                            ", energy_consumption=" + sqlValue(row[15]) + ", energy_production=" + sqlValue(row[16]) + \
                            " WHERE spy_id=" + str(reportid) + " AND planet_id=" + sqlValue(row[0])
                    dbExecute(query)

                if level >= 2:

                    query = "UPDATE gm_spying_planets SET" + \
                            " workers=" + sqlValue(row[22]) + ", workers_capacity=" + sqlValue(row[23]) + "," + \
                            " scientists=" + sqlValue(row[24]) + ", scientists_capacity=" + sqlValue(row[25]) + "," + \
                            " soldiers=" + sqlValue(row[26]) + ", soldiers_capacity=" + sqlValue(row[27]) + \
                            " WHERE spy_id=" + str(reportid) + " AND planet_id=" + sqlValue(row[0])
                    dbExecute(query)

                    query = "SELECT planetid, id, build_status, quantity, construction_maximum " + \
                            " FROM vw_gm_planet_buildings AS b " + \
                            " WHERE planetid=" + str(row[0]) + " AND build_status IS NOT NULL"
                    rows = dbRows(query)
                    for row in rows:
                        
                        qty = row[3]

                        if random() < (getinfoModifier * i) and row[4] != 1:

                            rndmax = int(row[3] * 1.5)
                            if rndmax <= row[3]: rndmax = rndmax + 1
                            rndmax = min(rndmax, row[4])
                            rndmin = int(row[3] * 0.5)
                            if rndmin < 1: rndmin = 1
                            qty = int((rndmax - rndmin + 1) * random() + rndmin)

                        query = "INSERT INTO gm_spying_buildings(spy_id, planet_id, building_id, endtime, quantity)" + \
                                " VALUES (" + str(reportid) + "," + str(row[0]) + "," + str(row[1]) + ", now() + " + str(row[2]) + "* interval '1 second', " + str(qty) + ")"
                        dbExecute(query)

            else:

                query = "INSERT INTO gm_spying_planets(spy_id, planet_id, floor, space)" + \
                        " VALUES("+ str(reportid) +"," + sqlValue(row[0]) +"," + sqlValue(row[4]) +"," + sqlValue(row[5]) +")"
                dbExecute(query)
                
                return 0

            query = "INSERT INTO gm_profile_reports(ownerid, type, subtype, datetime, spyid, planetid)" + \
                    " VALUES(" + str(self.userId) + ",8,30, now()+" + str(spyingTime) + "*interval '1 minute', " + str(reportid) + "," + str(planet) + ")"
            dbExecute(query)

            if spotted:
            
                query = "UPDATE gm_spyings SET" + \
                        " spotted=" + str(spotted) + \
                        " WHERE id=" + str(reportid) + " AND userid=" + str(self.userId)
                dbExecute(query)

                query = "INSERT INTO gm_profile_reports(ownerid, type, subtype, datetime, spyid, planetid, description)" + \
                        " VALUES(" + str(id) + ",8,3, now()+" + str(spyingTime) + "*interval '40 seconds'," + str(reportid) + "," + str(planet) + ", internal_profile_get_name(" + str(self.userId) + "))"
                dbExecute(query)

            query = "UPDATE gm_profiles SET prestige_points = prestige_points - " + str(cost) + " WHERE id=" + str(self.userId)
            dbExecute(query)
            
            return 0

    #---------------------------------------------------------------------------
    def fillContent(self, request, data):

        # --- costs data
        
        data["nation_cost_lvl_0"] = self.nation_cost_lvl_0
        data["nation_cost_lvl_1"] = self.nation_cost_lvl_1
        data["nation_cost_lvl_2"] = self.nation_cost_lvl_2
        data["nation_cost_lvl_3"] = self.nation_cost_lvl_3

        data["planet_cost_lvl_0"] = self.planet_cost_lvl_0
        data["planet_cost_lvl_1"] = self.planet_cost_lvl_1
        data["planet_cost_lvl_2"] = self.planet_cost_lvl_2
        data["planet_cost_lvl_3"] = self.planet_cost_lvl_3
