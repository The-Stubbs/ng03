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

        self.showHeader = True

        # Retrieve galaxy/sector to display
        galaxy = request.GET.get("g","")
        sector = request.GET.get("s","")

        # If the player is on the map and change the current planet, find the galaxy/sector
        planet = request.GET.get("planet","")
        if planet != "":
            galaxy = self.currentGalaxy
            sector = self.currentSector
        else:
            if galaxy != "": galaxy = ToInt(galaxy,self.currentGalaxy)
            if sector != "": sector = ToInt(sector,self.currentSector)

        return self.DisplayMap(galaxy, sector)

    def GetSector(self, sector, shiftX, shiftY):

        if (sector % 10 == 0) and (shiftX > 0): shiftX = 0
        if (sector % 10 == 1) and (shiftX < 0): shiftX = 0

        if (sector < 11) and (shiftY < 0): shiftY = 0
        if (sector > 90) and (shiftY > 0): shiftY = 0

        s = sector + shiftX + shiftY*10

        if s > 99: s = 99

        return s

    def displayRadar(self, content, galaxy, sector, radarstrength):

        query = "SELECT v.id, v.name, attackonsight, engaged, size, signature, speed, remaining_time," + \
                " ownerid, owner_name, owner_relation, " + \
                " planetid, planet_name, planet_galaxy, planet_sector, planet_planet," + \
                " planet_ownerid, planet_owner_name, planet_owner_relation," + \
                " destplanetid, destplanet_name, destplanet_galaxy, destplanet_sector, destplanet_planet, " + \
                " destplanet_ownerid, destplanet_owner_name, destplanet_owner_relation, total_time," + \
                " from_radarstrength, to_radarstrength, gm_alliances.tag, radar_jamming, destplanet_radar_jamming" + \
                " FROM vw_gm_moving_fleets v" + \
                "    LEFT JOIN gm_alliances ON gm_alliances.id = owner_alliance_id" + \
                " WHERE userid="+str(self.userId)+" AND (" + \
                "    (planetid >= tool_get_first_sector_planet("+str(galaxy)+","+str(sector)+") AND planetid <= tool_get_last_sector_planet("+str(galaxy)+","+str(sector)+")) OR" + \
                "    (destplanetid >= tool_get_first_sector_planet("+str(galaxy)+","+str(sector)+") AND destplanetid <= tool_get_last_sector_planet("+str(galaxy)+","+str(sector)+")))" + \
                " ORDER BY remaining_time"
        rows = dbRows(query)

        relation = -100 # -100 = do not display the fleet
        loosing_time = 0 # seconds before our radar loses the fleet
        remaining_time = 0 # seconds before the fleet ends its travel
        movement_type = ""
        movingfleetcount = 0        # gm_fleets moving inside the sector
        enteringfleetcount = 0    # gm_fleets entering the sector
        leavingfleetcount = 0    # gm_fleets leaving the sector

        movings = []
        enterings = []
        leavings = []
        
        for row in rows:
            relation = row[10]
            remaining_time = row[7]
            loosing_time = -1

            display_from = True
            display_to = True

            # do not display NAP/enemy gm_fleets moving to/from unknown planet if fleet is not within radar range
            if relation <= rFriend:
                # compute how far our radar can detect gm_fleets
                # highest radar strength * width of a sector / speed * nbr of second in one hour
                radarSpotting = sqrt(radarstrength)*6*1000/row[6]*3600

                if row[28] == 0:
                    if row[7] < radarSpotting:
                        # incoming fleet is detected by our radar
                        display_from = False
                    else:
                        relation = -100
                    
                elif row[29] == 0:
                    if row[27]-row[7] < radarSpotting:
                        #outgoing fleet is still detected by our radar
                        loosing_time = int(radarSpotting-(row[27]-row[7]))
                        display_to = False
                    else:
                        relation = -100
                    
                else:
                    remaining_time = row[7]

            if relation > -100:
                fleet = {}

                fleet["id"] = row[8]
                fleet["name"] = row[9]

                fleet["fleetid"] = row[0]
                fleet["fleetname"] = row[1]
                fleet["signature"] = row[5]

                #
                # determine the type of movement : intrasector, intersector (entering, leaving)
                # also don't show signature of enemy gm_fleets if we don't know or can't gm_spyings on the source AND target coords
                #
                if row[13] == galaxy and row[14] == sector:
                    if row[21] == galaxy and row[22] == sector:
                        movement_type = "radar.moving"
                        movingfleetcount = movingfleetcount + 1
                        movings.append(fleet)

                        if ((row[31] >= row[28] and row[18] < rAlliance) or not display_from) and ((row[32] >= row[29] and row[26] < rAlliance) or not display_to) and row[10] < rAlliance: fleet["signature"] = 0
                    else:
                        movement_type = "radar.leaving"
                        leavingfleetcount = leavingfleetcount + 1
                        leavings.append(fleet)

                        if ((row[31] >= row[28] and row[18] < rAlliance) or not display_from) and ((row[32] >= row[29] and row[26] < rAlliance) or not display_to) and row[10] < rAlliance: fleet["signature"] = 0
                    
                else:
                    movement_type = "radar.entering"
                    enteringfleetcount = enteringfleetcount + 1
                    enterings.append(fleet)

                    if ((row[31] >= row[28] and row[18] < rAlliance) or not display_from) and ((row[32] >= row[29] and row[26] < rAlliance) or not display_to) and row[10] < rAlliance: fleet["signature"] = 0

                #
                # Assign remaining travel time
                #
                if loosing_time > -1:
                    fleet["time"] = loosing_time
                    fleet["losing"] = True
                else:
                    fleet["time"] = remaining_time
                    fleet["timeleft"] = True

                #
                # Assign From and To planets info
                #

                if display_from:
                    # Assign the name of the owner if is not an ally planet
                    fleet["f_planetname"] = self.getPlanetName(row[18], row[28], row[17], row[12])
                    fleet["f_planetid"] = row[11]
                    fleet["f_g"] = row[13]
                    fleet["f_s"] = row[14]
                    fleet["f_p"] = row[15]
                    fleet["f_relation"] = row[18]
                else:
                    fleet["f_planetname"] = ""
                    fleet["f_planetid"] = ""
                    fleet["f_g"] = ""
                    fleet["f_s"] = ""
                    fleet["f_p"] = ""
                    fleet["f_relation"] = "0"

                if display_to:
                    # Assign the planet name if possible otherwise the name of the owner
                    fleet["t_planetname"] = self.getPlanetName(row[26], row[29], row[25], row[20])
                    fleet["t_planetid"] = row[19]
                    fleet["t_g"] = row[21]
                    fleet["t_s"] = row[22]
                    fleet["t_p"] = row[23]
                    fleet["t_relation"] = row[26]
                else:
                    fleet["t_planetname"] = ""
                    fleet["t_planetid"] = ""
                    fleet["t_g"] = ""
                    fleet["t_s"] = ""
                    fleet["t_p"] = ""
                    fleet["t_relation"] = "0"

                fleet["relation"] = relation
                fleet["alliancetag"] = row[30] if row[30] else ""

        content.AssignValue("movings", movings)
        content.AssignValue("enterings", enterings)
        content.AssignValue("leavings", leavings)

        if movingfleetcount == 0: content.Parse("moving_nofleets")
        if enteringfleetcount == 0: content.Parse("entering_nofleets")
        if leavingfleetcount == 0: content.Parse("leaving_nofleets")

        content.Parse("moving")
        content.Parse("entering")
        content.Parse("leaving")

        content.Parse("radar")

    #
    # Display the map : Galaxies, sectors or a sector
    #
    def DisplayMap(self, galaxy, sector):
        #
        # Load the template
        #
        
        content = self.loadTemplate("map")

        # Assign the displayed galaxy/sector
        content.AssignValue("galaxy", galaxy)
        content.AssignValue("sector", sector)

        #
        # Verify which map will be displayed
        #
        if galaxy == "":
            #
            # Display map of galaxies with 8 galaxies per row
            #
            query = "SELECT n.id, " + \
                    " n.colonies > 0," + \
                    " False AND EXISTS(SELECT 1 FROM gm_planets WHERE galaxy=n.id AND ownerid IN (SELECT friend FROM vw_gm_friends WHERE vw_gm_friends.userid="+str(self.userId)+") LIMIT 1)," + \
                    " EXISTS(SELECT 1 FROM gm_planets WHERE galaxy=n.id AND ownerid IN (SELECT ally FROM vw_allies WHERE vw_allies.userid="+str(self.userId)+") LIMIT 1)," + \
                    " EXISTS(SELECT 1 FROM gm_planets WHERE galaxy=n.id AND ownerid = "+str(self.userId)+" LIMIT 1) AS hasplanets" + \
                    " FROM gm_galaxies AS n" + \
                    " ORDER BY n.id;"
            rows = dbRows(query)

            galaxies = []
            for row in rows:
                galaxy = {}
                galaxy["galaxyid"] = row[0]

                # check if enemy or friendly planets are in the galaxies
                if row[4]:
                    galaxy["hasplanet"] = True
                elif row[3]:
                    galaxy["hasally"] = True
                elif row[2]:
                    galaxy["hasfriend"] = True
                elif row[1]:
                    galaxy["hasnothing"] = True

                galaxies.append(galaxy)
                
            content.AssignValue("galaxies", galaxies)
            content.Parse("nav_universe")
            
            return self.display(content)

        if sector == "":
            #
            # Display map of sectors for the given galaxy
            #
            query = "SELECT internal_profile_get_galaxy_planets(" + str(galaxy) + "," + str(self.userId) + ")"
            row = dbRow(query)

            content.AssignValue("map", row[0])
            content.AssignValue("mapgalaxy", row[0])

            query = "SELECT gm_alliances.tag, round(100.0 * sum(n.score) / (SELECT sum(score) FROM gm_planets WHERE galaxy=n.galaxy))" + \
                    " FROM gm_planets AS n" + \
                    "    INNER JOIN gm_profiles ON (gm_profiles.id = n.ownerid)" + \
                    "    INNER JOIN gm_alliances ON (gm_profiles.alliance_id = gm_alliances.id)" + \
                    " WHERE galaxy=" + str(galaxy) + \
                    " GROUP BY galaxy, gm_alliances.tag" + \
                    " ORDER BY sum(n.score) DESC LIMIT 3"
            rows = dbRows(query)

            nb = 1
            for row in rows:
                content.AssignValue("sov_tag_" + str(nb), row[0])
                content.AssignValue("sov_perc_" + str(nb), row[1])

                nb = nb + 1

            query = "SELECT date_part('epoch', protected_until-now()) FROM gm_galaxies WHERE id=" + str(galaxy)
            row = dbRow(query)
            content.AssignValue("protected_until", int(row[0]))

            query = "SELECT sell_ore, sell_hydro FROM internal_profile_get_resource_price(" + str(self.userId) + "," + str(galaxy) + ", false)"
            row = dbRow(query)

            content.AssignValue("price_ore", row[0])
            content.AssignValue("price_hydro", row[1])

            content.Parse("nav_galaxy")
            content.Parse("galaxy_link")

            return self.display(content)

        #
        # Display the planets in the given sector
        #

        #
        # Assign the arrows values
        #
        content.AssignValue("sector0", self.GetSector(sector,-1,-1))
        content.AssignValue("sector1", self.GetSector(sector, 0,-1))
        content.AssignValue("sector2", self.GetSector(sector, 1,-1))
        content.AssignValue("sector3", self.GetSector(sector, 1, 0))
        content.AssignValue("sector4", self.GetSector(sector, 1, 1))
        content.AssignValue("sector5", self.GetSector(sector, 0, 1))
        content.AssignValue("sector6", self.GetSector(sector,-1, 1))
        content.AssignValue("sector7", self.GetSector(sector,-1, 0))

        #
        # Retrieve/Save gm_fleets in the sector
        #
        
        query = "SELECT f.planetid, f.id, f.name, internal_profile_get_relation(f.ownerid, "+str(self.userId)+"), f.signature," + \
                "    EXISTS(SELECT 1 FROM gm_fleets AS fl WHERE fl.planetid=f.planetid and fl.action != 1 and fl.action != -1 and fl.ownerid IN (SELECT ally FROM vw_allies WHERE userid="+str(self.userId)+") LIMIT 1)," + \
                " action=1 OR action=-1, (SELECT tag FROM gm_alliances WHERE id=gm_profiles.alliance_id), login, shared," + \
                "    EXISTS(SELECT 1 FROM gm_fleets AS fl WHERE fl.planetid=f.planetid and fl.action != 1 and fl.action != -1 and fl.ownerid ="+str(self.userId)+" LIMIT 1)" + \
                " FROM gm_fleets as f" + \
                "    INNER JOIN gm_profiles ON (f.ownerid=gm_profiles.id)" + \
                " WHERE ((action != 1 AND action != -1) OR engaged) AND" + \
                "    planetid >= tool_get_first_sector_planet("+str(galaxy)+","+str(sector)+") AND planetid <= tool_get_last_sector_planet("+str(galaxy)+","+str(sector)+")" + \
                " ORDER BY f.planetid, upper(f.name)"
        rows = dbRows(query)

        fleetsArray = None
        if rows:
            fleetsArray = oRss.copy()

        #
        # Retrieve/Save planet elements in the sector
        #

        query = "SELECT planetid, label, description" + \
                " FROM gm_planet_buildings" + \
                "    INNER JOIN dt_buildings ON dt_buildings.id=buildingid" + \
                " WHERE planetid >= tool_get_first_sector_planet("+str(galaxy)+","+str(sector)+") AND planetid <= tool_get_last_sector_planet("+str(galaxy)+","+str(sector)+") AND is_planet_element" + \
                " ORDER BY planetid, upper(label)"
        rows = dbRows(query)

        elementsArray = None
        if rows:
            elementsArray = oRss.copy()

        #
        # Retrieve biggest radar strength in the sector that the player has access to
        #
        query = "SELECT * FROM internal_profile_get_sector_radar_strength("+str(self.userId)+","+str(galaxy)+","+str(sector)+")"
        row = dbRow(query)
        radarstrength = row[0]

        if self.allianceId == None:
            aid = -1
        else:
            aid = self.allianceId
        
        #
        # Main query : retrieve planets info in the sector
        #
        query = "SELECT gm_planets.id, gm_planets.planet, gm_planets.name, gm_planets.ownerid," + \
                " gm_profiles.login, internal_profile_get_relation(gm_planets.ownerid," + str(self.userId) + "), floor, space, GREATEST(0, radar_strength), radar_jamming," + \
                " orbit_ore, orbit_hydro, gm_alliances.tag," + \
                " (SELECT SUM(quantity*signature) FROM gm_planet_ships LEFT JOIN dt_ships ON (gm_planet_ships.shipid = dt_ships.id) WHERE gm_planet_ships.planetid=gm_planets.id), " + \
                " floor_occupied, planet_floor, production_frozen, warp_to IS NOT NULL OR vortex_strength > 0," + \
                " planet_pct_ore, planet_pct_hydro, spawn_ore, spawn_hydro, vortex_strength," + \
                " COALESCE(buy_ore, 0) AS buy_ore, COALESCE(buy_hydro, 0) as buy_hydro," + \
                " internal_alliance_get_nap_location_sharing(COALESCE(" + str(aid) + ", -1), COALESCE(gm_profiles.alliance_id, -1)) AS locs_shared" + \
                " FROM gm_planets" + \
                "    LEFT JOIN gm_profiles ON (gm_profiles.id = ownerid)" + \
                "    LEFT JOIN gm_alliances ON (gm_profiles.alliance_id=gm_alliances.id)" + \
                " WHERE galaxy=" + str(galaxy) + " AND sector=" + str(sector) + \
                " ORDER BY planet"
        rows = dbRows(query)

        # in then there is no planets, redirect player to the map of the galaxies
        if oRss == None:
            return HttpResponseRedirect("/game/map/")
        
        planets = []
        for row in rows:
            planet = {}
            
            planetid = row[0]

            rel = row[5]

            if rel == rAlliance and not self.hasRight("can_use_alliance_radars"):
                rel = rWar

            if rel == rFriend and not row[25] and row[3] != 3:
                rel = rWar

            displayElements = False # hasElements is True if the planet has some particularities like magnetic cloud or sun radiation ..
            displayPlanetInfo = False
            displayResources = False # displayResources is True if there is some ore/hydro on planet orbit
            hasPlanetInfo = True

            #
            # list all the gm_fleets around the current planet
            #
            allyfleetcount = 0
            friendfleetcount = 0
            enemyfleetcount = 0
            
            planet['gm_fleets'] = []
            fleetcount = 0
            if fleetsArray:
                for i in fleetsArray:
                    if i[0] == planetid:
    
                        # display gm_fleets on : 
                        #    alliance and own planets 
                        #    planets where we got a fleet or (a fleet of an alliance member and can_use_alliance_radars)
                        #    planets that our radar can detect
                        if (self.hasRight("can_use_alliance_radars") and ( (rel >= rAlliance) or i[5] )) or radarstrength > row[9] or i[10]:
    
                            fleet = {}
                            fleetcount = fleetcount + 1
    
                            fleet["fleetid"] = 0
    
                            fleet["fleetname"] = i[2]
                            fleet["relation"] = i[3]
                            fleet["fleetowner"] = i[8]
    
                            if (row[5] > rFriend) or (i[3] > rFriend) or (radarstrength > row[9]) or (i[5] and row[9] == 0):
                                fleet["signature"] = i[4]
                            else:
                                fleet["signature"] = -1
    
                            if i[6]: fleet["fleeing"] = True
    
                            if i[7] == None:
                                fleet["alliancetag"] = ""
                            else:
                                fleet["alliancetag"] = i[7]
    
                            if i[3] == rSelf:
                                fleet["fleetid"] = i[1]
    
                                allyfleetcount = allyfleetcount + 1
                                friendfleetcount = friendfleetcount + 1
                            elif i[3] == rAlliance:
                                allyfleetcount = allyfleetcount + 1
                                friendfleetcount = friendfleetcount + 1
    
                                if self.hasRight("can_order_other_fleets") and i[9]:
                                    fleet["fleetid"] = i[1]
    
                            elif i[3] == rFriend:
                                friendfleetcount = friendfleetcount + 1
                            else:
                                # if planet is owned by the player: increase enemy fleet
                                enemyfleetcount = enemyfleetcount + 1
    
                            planet['gm_fleets'].append(fleet)
    
            planet["planetid"] = planetid
            planet["planet"] = row[1]
            planet["relation"] = row[5]
            if row[12]: planet["alliancetag"] = row[12]
            else: planet["alliancetag"] = ""

            planet["buy_ore"] = row[23]
            planet["buy_hydro"] = row[24]

            #
            # assign the planet representation
            #
            if row[6] == 0 and row[7] == 0:
                # if floor and space are null: it is either an asteroid field, empty square or a vortex
                planet["planet_img"] = ""
                if row[17]:
                    planet["vortex"] = True
                elif row[20] > 0:
                    planet["asteroids"] = True
                elif row[21] > 0:
                    planet["clouds"] = True
                else:
                    planet["empty"] = True

                hasPlanetInfo = False
            else:
                hasPlanetInfo = True

                p_img = 1+(row[15] + row[0]) % 21
                if p_img < 10: p_img = "0" + str(p_img)
                else: p_img = str(p_img)

                planet["planet_img"] = p_img
                planet["colony"] = True

            #
            # retrieve planets non assigned ships and display their signature if we/an ally own the planet or we have a radar,
            # which is more powerfull than jammer, or if we/an ally have a fleet on this planet
            #
            ShowGround = False        

            planet["parked"] = 0
            
            if row[13] and ( radarstrength > row[9] or rel >= rAlliance or allyfleetcount > 0 ):
                ground = int(row[13])
                if ground != 0:
                    ShowGround = True

                    planet["parked"] = ground

            if fleetcount > 0 or ShowGround:
                planet["orbit"] = True

            if row[3] == None:
                # if there is no owner

                displayPlanetInfo = radarstrength > 0 or allyfleetcount > 0
                displayElements = displayPlanetInfo
                displayResources = displayPlanetInfo

                planet["ownerid"] = ""
                planet["ownername"] = ""
                planet["planetname"] = ""

                if hasPlanetInfo: planet["uninhabited"] = True
                planet["noradar"] = True
            else:
                planet["ownerid"] = row[3]
                planet["ownername"] = row[4]

                # display planet info
                if rel == rSelf:
                    planet["planetname"] = row[2]

                    displayElements = True
                    displayPlanetInfo = True
                    displayResources = True
                elif rel == rAlliance:
                    if self.displayAlliancePlanetName:
                        planet["planetname"] = row[2]
                    else:
                        planet["planetname"] = ""

                    displayElements = True
                    displayPlanetInfo = True
                    displayResources = True
                elif rel == rFriend:
                    planet["planetname"] = ""

                    displayElements = radarstrength > row[9] or allyfleetcount > 0
                    displayPlanetInfo = displayElements
                    displayResources = radarstrength > 0 or allyfleetcount > 0
                else:
                    if radarstrength > 0 or allyfleetcount > 0:
                        planet["planetname"] = row[4]

                        displayElements = radarstrength > row[9] or allyfleetcount > 0
                        displayPlanetInfo = displayElements
                        displayResources = radarstrength > 0 or allyfleetcount > 0
                    else:
                        planet["relation"] = -1

                        planet["alliancetag"] = ""
                        planet["ownerid"] = ""
                        planet["ownername"] = ""
                        planet["planetname"] = ""
                        displayElements = False
                        displayPlanetInfo = False
                        displayResources = False

            if rel >= rAlliance:
                planet["radarstrength"] = row[8]
                planet["radarjamming"] = row[9]
            else:
                if radarstrength == 0:
                    planet["radarstrength"] = -1
                    planet["radarjamming"] = 0
                elif row[9] > 0:
                    if row[9] >= radarstrength:    # check if radar is jammed
                        planet["radarstrength"] = 1
                        planet["radarjamming"] = -1
                    elif radarstrength > row[9]:
                        planet["radarstrength"] = row[8]
                        planet["radarjamming"] = row[9]
                    
                elif row[8] == 0:
                    planet["radarstrength"] = 0
                    planet["radarjamming"] = 0
                else:
                    planet["radarstrength"] = row[8]
                    planet["radarjamming"] = row[9]

            if hasPlanetInfo and displayPlanetInfo:
                planet["floor"] = row[6]
                planet["space"] = row[7]
                planet["a_ore"] = row[18]
                planet["a_hydro"] = row[19]
                planet["vortex_strength"] = row[23]
                planet["info"] = True
            else:
                planet["floor"] = ""
                planet["space"] = ""
                planet["vortex_strength"] = row[23]
                planet["noinfo"] = ""

            if displayResources and (row[10] > 0 or row[11] > 0):
                planet["ore"] = row[10]
                planet["hydro"] = row[11]
                planet["resources"] = True
            else:
                planet["ore"] = 0
                planet["hydro"] = 0
                planet["noresources"] = True

            #
            # list all the planet elements
            #
            if displayElements and elementsArray:

                count = 0
                planet['elements'] = []
                for i in elementsArray:
                    if i[0] == planetid:
                        element = {}
                        count = count + 1
                        element["element"] = i[1]

                        planet['elements'].append(element)
                    
                displayElements = count > 0

            if not displayElements:
                planet["noelements"] = True

            if row[16]:
                planet["frozen"] = True
            else:
                planet["active"] = True

            #
            # display planet
            #
            planets.append(planet)
        
        content.AssignValue("locations", planets)
        
        content.Parse("nav_sector")
        content.Parse("galaxy_link")
        
        #
        # Display gm_fleets movements according to player radar strength
        #

        if radarstrength > 0: self.displayRadar(content, galaxy, sector, radarstrength)

        return self.display(content)
