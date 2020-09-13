# -*- coding: utf-8 -*-

from math import sqrt

from game.views.lib._global import *

class View(GlobalView):
    
    def dispatch(self, request, *args, **kwargs):

        response = super().pre_dispatch(request, *args, **kwargs)
        if response: return response
        
        self.selected_menu = "map"

        self.showHeader = True

        # Retrieve galaxy/sector to display
        galaxy = request.GET.get("g", "")
        sector = request.GET.get("s", "")

        # If the player is on the map and change the current planet, find the galaxy/sector
        planet = request.GET.get("planet", "")
        if planet != "":
            galaxy = self.CurrentGalaxyId
            sector = self.CurrentSectorId
        else:
            if galaxy != "": galaxy = ToInt(galaxy,self.CurrentGalaxyId)
            if sector != "": sector = ToInt(sector,self.CurrentSectorId)

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
                " WHERE userid="+str(self.UserId)+" AND ("+ \
                "    (planetid >= tool_get_first_sector_planet("+str(galaxy)+","+str(sector)+") AND planetid <= tool_get_last_sector_planet("+str(galaxy)+","+str(sector)+")) OR"+ \
                "    (destplanetid >= tool_get_first_sector_planet("+str(galaxy)+","+str(sector)+") AND destplanetid <= tool_get_last_sector_planet("+str(galaxy)+","+str(sector)+")))" + \
                " ORDER BY remaining_time"
        oRss = oConnExecuteAll(query)

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
        
        for oRs in oRss:
            relation = oRs[10]
            remaining_time = oRs[7]
            loosing_time = -1

            display_from = True
            display_to = True

            # do not display NAP/enemy gm_fleets moving to/from unknown planet if fleet is not within radar range
            if relation <= rFriend:
                # compute how far our radar can detect gm_fleets
                # highest radar strength * width of a sector / speed * nbr of second in one hour
                radarSpotting = sqrt(radarstrength)*6*1000/oRs[6]*3600

                if oRs[28] == 0:
                    if oRs[7] < radarSpotting:
                        # incoming fleet is detected by our radar
                        display_from = False
                    else:
                        relation = -100
                    
                elif oRs[29] == 0:
                    if oRs[27]-oRs[7] < radarSpotting:
                        #outgoing fleet is still detected by our radar
                        loosing_time = int(radarSpotting-(oRs[27]-oRs[7]))
                        display_to = False
                    else:
                        relation = -100
                    
                else:
                    remaining_time = oRs[7]

            if relation > -100:
                fleet = {}

                fleet["id"] = oRs[8]
                fleet["name"] = oRs[9]

                fleet["fleetid"] = oRs[0]
                fleet["fleetname"] = oRs[1]
                fleet["signature"] = oRs[5]

                #
                # determine the type of movement : intrasector, intersector (entering, leaving)
                # also don't show signature of enemy gm_fleets if we don't know or can't gm_spyings on the source AND target coords
                #
                if oRs[13] == galaxy and oRs[14] == sector:
                    if oRs[21] == galaxy and oRs[22] == sector:
                        movement_type = "radar.moving"
                        movingfleetcount = movingfleetcount + 1
                        movings.append(fleet)

                        if ((oRs[31] >= oRs[28] and oRs[18] < rAlliance) or not display_from) and ((oRs[32] >= oRs[29] and oRs[26] < rAlliance) or not display_to) and oRs[10] < rAlliance: fleet["signature"] = 0
                    else:
                        movement_type = "radar.leaving"
                        leavingfleetcount = leavingfleetcount + 1
                        leavings.append(fleet)

                        if ((oRs[31] >= oRs[28] and oRs[18] < rAlliance) or not display_from) and ((oRs[32] >= oRs[29] and oRs[26] < rAlliance) or not display_to) and oRs[10] < rAlliance: fleet["signature"] = 0
                    
                else:
                    movement_type = "radar.entering"
                    enteringfleetcount = enteringfleetcount + 1
                    enterings.append(fleet)

                    if ((oRs[31] >= oRs[28] and oRs[18] < rAlliance) or not display_from) and ((oRs[32] >= oRs[29] and oRs[26] < rAlliance) or not display_to) and oRs[10] < rAlliance: fleet["signature"] = 0

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
                    fleet["f_planetname"] = self.getPlanetName(oRs[18], oRs[28], oRs[17], oRs[12])
                    fleet["f_planetid"] = oRs[11]
                    fleet["f_g"] = oRs[13]
                    fleet["f_s"] = oRs[14]
                    fleet["f_p"] = oRs[15]
                    fleet["f_relation"] = oRs[18]
                else:
                    fleet["f_planetname"] = ""
                    fleet["f_planetid"] = ""
                    fleet["f_g"] = ""
                    fleet["f_s"] = ""
                    fleet["f_p"] = ""
                    fleet["f_relation"] = "0"

                if display_to:
                    # Assign the planet name if possible otherwise the name of the owner
                    fleet["t_planetname"] = self.getPlanetName(oRs[26], oRs[29], oRs[25], oRs[20])
                    fleet["t_planetid"] = oRs[19]
                    fleet["t_g"] = oRs[21]
                    fleet["t_s"] = oRs[22]
                    fleet["t_p"] = oRs[23]
                    fleet["t_relation"] = oRs[26]
                else:
                    fleet["t_planetname"] = ""
                    fleet["t_planetid"] = ""
                    fleet["t_g"] = ""
                    fleet["t_s"] = ""
                    fleet["t_p"] = ""
                    fleet["t_relation"] = "0"

                fleet["relation"] = relation
                fleet["alliancetag"] = oRs[30] if oRs[30] else ""

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
        
        content = GetTemplate(self.request, "map")

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
            query = "SELECT n.id, "+ \
                    " n.colonies > 0,"+ \
                    " False AND EXISTS(SELECT 1 FROM gm_planets WHERE galaxy=n.id AND ownerid IN (SELECT friend FROM vw_gm_friends WHERE vw_gm_friends.userid="+str(self.UserId)+") LIMIT 1),"+ \
                    " EXISTS(SELECT 1 FROM gm_planets WHERE galaxy=n.id AND ownerid IN (SELECT ally FROM vw_allies WHERE vw_allies.userid="+str(self.UserId)+") LIMIT 1),"+ \
                    " EXISTS(SELECT 1 FROM gm_planets WHERE galaxy=n.id AND ownerid = "+str(self.UserId)+" LIMIT 1) AS hasplanets"+ \
                    " FROM gm_galaxies AS n"+ \
                    " ORDER BY n.id;"
            oRss = oConnExecuteAll(query)

            galaxies = []
            for oRs in oRss:
                galaxy = {}
                galaxy["galaxyid"] = oRs[0]

                # check if enemy or friendly planets are in the galaxies
                if oRs[4]:
                    galaxy["hasplanet"] = True
                elif oRs[3]:
                    galaxy["hasally"] = True
                elif oRs[2]:
                    galaxy["hasfriend"] = True
                elif oRs[1]:
                    galaxy["hasnothing"] = True

                galaxies.append(galaxy)
                
            content.AssignValue("galaxies", galaxies)
            content.Parse("nav_universe")
            
            return self.Display(content)

        if sector == "":
            #
            # Display map of sectors for the given galaxy
            #
            query = "SELECT internal_profile_get_galaxy_planets(" + str(galaxy) + "," + str(self.UserId) + ")"
            oRs = oConnExecute(query)

            content.AssignValue("map", oRs[0])
            content.AssignValue("mapgalaxy", oRs[0])

            query = "SELECT gm_alliances.tag, round(100.0 * sum(n.score) / (SELECT sum(score) FROM gm_planets WHERE galaxy=n.galaxy))" + \
                    " FROM gm_planets AS n" + \
                    "    INNER JOIN gm_profiles ON (gm_profiles.id = n.ownerid)" + \
                    "    INNER JOIN gm_alliances ON (gm_profiles.alliance_id = gm_alliances.id)" + \
                    " WHERE galaxy=" + str(galaxy) + \
                    " GROUP BY galaxy, gm_alliances.tag" + \
                    " ORDER BY sum(n.score) DESC LIMIT 3"
            oRss = oConnExecuteAll(query)

            nb = 1
            for oRs in oRss:
                content.AssignValue("sov_tag_" + str(nb), oRs[0])
                content.AssignValue("sov_perc_" + str(nb), oRs[1])

                nb = nb + 1

            query = "SELECT date_part('epoch', protected_until-now()) FROM gm_galaxies WHERE id=" + str(galaxy)
            oRs = oConnExecute(query)
            content.AssignValue("protected_until", int(oRs[0]))

            query = "SELECT sell_ore, sell_hydrocarbon FROM internal_profile_get_resource_price(" + str(self.UserId) + "," + str(galaxy) + ", false)"
            oRs = oConnExecute(query)

            content.AssignValue("price_ore", oRs[0])
            content.AssignValue("price_hydrocarbon", oRs[1])

            content.Parse("nav_galaxy")
            content.Parse("galaxy_link")

            return self.Display(content)

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
        
        query = "SELECT f.planetid, f.id, f.name, internal_profile_get_relation(f.ownerid, "+str(self.UserId)+"), f.signature," + \
                "    EXISTS(SELECT 1 FROM gm_fleets AS fl WHERE fl.planetid=f.planetid and fl.action != 1 and fl.action != -1 and fl.ownerid IN (SELECT ally FROM vw_allies WHERE userid="+str(self.UserId)+") LIMIT 1)," + \
                " action=1 OR action=-1, (SELECT tag FROM gm_alliances WHERE id=gm_profiles.alliance_id), login, shared," + \
                "    EXISTS(SELECT 1 FROM gm_fleets AS fl WHERE fl.planetid=f.planetid and fl.action != 1 and fl.action != -1 and fl.ownerid ="+str(self.UserId)+" LIMIT 1)" + \
                " FROM gm_fleets as f" + \
                "    INNER JOIN gm_profiles ON (f.ownerid=gm_profiles.id)" + \
                " WHERE ((action != 1 AND action != -1) OR engaged) AND" + \
                "    planetid >= tool_get_first_sector_planet("+str(galaxy)+","+str(sector)+") AND planetid <= tool_get_last_sector_planet("+str(galaxy)+","+str(sector)+")" + \
                " ORDER BY f.planetid, upper(f.name)"
        oRss = oConnExecuteAll(query)

        fleetsArray = None
        if oRss:
            fleetsArray = oRss.copy()

        #
        # Retrieve/Save planet elements in the sector
        #

        query = "SELECT planetid, label, description" + \
                " FROM gm_planet_buildings" + \
                "    INNER JOIN dt_buildings ON dt_buildings.id=buildingid" + \
                " WHERE planetid >= tool_get_first_sector_planet("+str(galaxy)+","+str(sector)+") AND planetid <= tool_get_last_sector_planet("+str(galaxy)+","+str(sector)+") AND is_planet_element" + \
                " ORDER BY planetid, upper(label)"
        oRss = oConnExecuteAll(query)

        elementsArray = None
        if oRss:
            elementsArray = oRss.copy()

        #
        # Retrieve biggest radar strength in the sector that the player has access to
        #
        query = "SELECT * FROM internal_profile_get_sector_radar_strength("+str(self.UserId)+","+str(galaxy)+","+str(sector)+")"
        oRs = oConnExecute(query)
        radarstrength = oRs[0]

        if self.AllianceId == None:
            aid = -1
        else:
            aid = self.AllianceId
        
        #
        # Main query : retrieve planets info in the sector
        #
        query = "SELECT gm_planets.id, gm_planets.planet, gm_planets.name, gm_planets.ownerid,"+ \
                " gm_profiles.login, internal_profile_get_relation(gm_planets.ownerid," + str(self.UserId) + "), floor, space, GREATEST(0, radar_strength), radar_jamming," + \
                " orbit_ore, orbit_hydrocarbon, gm_alliances.tag," + \
                " (SELECT SUM(quantity*signature) FROM gm_planet_ships LEFT JOIN dt_ships ON (gm_planet_ships.shipid = dt_ships.id) WHERE gm_planet_ships.planetid=gm_planets.id), " + \
                " floor_occupied, planet_floor, production_frozen, warp_to IS NOT NULL OR vortex_strength > 0," + \
                " planet_pct_ore, planet_pct_hydrocarbon, spawn_ore, spawn_hydrocarbon, vortex_strength," + \
                " COALESCE(buy_ore, 0) AS buy_ore, COALESCE(buy_hydrocarbon, 0) as buy_hydrocarbon," + \
                " internal_alliance_get_nap_location_sharing(COALESCE(" + str(aid) + ", -1), COALESCE(gm_profiles.alliance_id, -1)) AS locs_shared" + \
                " FROM gm_planets"+ \
                "    LEFT JOIN gm_profiles ON (gm_profiles.id = ownerid)"+ \
                "    LEFT JOIN gm_alliances ON (gm_profiles.alliance_id=gm_alliances.id)" + \
                " WHERE galaxy=" + str(galaxy) + " AND sector=" + str(sector) + \
                " ORDER BY planet"
        oRss = oConnExecuteAll(query)

        # in then there is no planets, redirect player to the map of the galaxies
        if oRss == None:
            return HttpResponseRedirect("/game/map/")
        
        planets = []
        for oRs in oRss:
            planet = {}
            
            planetid = oRs[0]

            rel = oRs[5]

            if rel == rAlliance and not self.hasRight("can_use_alliance_radars"):
                rel = rWar

            if rel == rFriend and not oRs[25] and oRs[3] != 3:
                rel = rWar

            displayElements = False # hasElements is True if the planet has some particularities like magnetic cloud or sun radiation ..
            displayPlanetInfo = False
            displayResources = False # displayResources is True if there is some ore/hydrocarbon on planet orbit
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
                        if (self.hasRight("can_use_alliance_radars") and ( (rel >= rAlliance) or i[5] )) or radarstrength > oRs[9] or i[10]:
    
                            fleet = {}
                            fleetcount = fleetcount + 1
    
                            fleet["fleetid"] = 0
    
                            fleet["fleetname"] = i[2]
                            fleet["relation"] = i[3]
                            fleet["fleetowner"] = i[8]
    
                            if (oRs[5] > rFriend) or (i[3] > rFriend) or (radarstrength > oRs[9]) or (i[5] and oRs[9] == 0):
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
            planet["planet"] = oRs[1]
            planet["relation"] = oRs[5]
            if oRs[12]: planet["alliancetag"] = oRs[12]
            else: planet["alliancetag"] = ""

            planet["buy_ore"] = oRs[23]
            planet["buy_hydrocarbon"] = oRs[24]

            #
            # assign the planet representation
            #
            if oRs[6] == 0 and oRs[7] == 0:
                # if floor and space are null: it is either an asteroid field, empty square or a vortex
                planet["planet_img"] = ""
                if oRs[17]:
                    planet["vortex"] = True
                elif oRs[20] > 0:
                    planet["asteroids"] = True
                elif oRs[21] > 0:
                    planet["clouds"] = True
                else:
                    planet["empty"] = True

                hasPlanetInfo = False
            else:
                hasPlanetInfo = True

                p_img = 1+(oRs[15] + oRs[0]) % 21
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
            
            if oRs[13] and ( radarstrength > oRs[9] or rel >= rAlliance or allyfleetcount > 0 ):
                ground = int(oRs[13])
                if ground != 0:
                    ShowGround = True

                    planet["parked"] = ground

            if fleetcount > 0 or ShowGround:
                planet["orbit"] = True

            if oRs[3] == None:
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
                planet["ownerid"] = oRs[3]
                planet["ownername"] = oRs[4]

                # display planet info
                if rel == rSelf:
                    planet["planetname"] = oRs[2]

                    displayElements = True
                    displayPlanetInfo = True
                    displayResources = True
                elif rel == rAlliance:
                    if self.displayAlliancePlanetName:
                        planet["planetname"] = oRs[2]
                    else:
                        planet["planetname"] = ""

                    displayElements = True
                    displayPlanetInfo = True
                    displayResources = True
                elif rel == rFriend:
                    planet["planetname"] = ""

                    displayElements = radarstrength > oRs[9] or allyfleetcount > 0
                    displayPlanetInfo = displayElements
                    displayResources = radarstrength > 0 or allyfleetcount > 0
                else:
                    if radarstrength > 0 or allyfleetcount > 0:
                        planet["planetname"] = oRs[4]

                        displayElements = radarstrength > oRs[9] or allyfleetcount > 0
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
                planet["radarstrength"] = oRs[8]
                planet["radarjamming"] = oRs[9]
            else:
                if radarstrength == 0:
                    planet["radarstrength"] = -1
                    planet["radarjamming"] = 0
                elif oRs[9] > 0:
                    if oRs[9] >= radarstrength:    # check if radar is jammed
                        planet["radarstrength"] = 1
                        planet["radarjamming"] = -1
                    elif radarstrength > oRs[9]:
                        planet["radarstrength"] = oRs[8]
                        planet["radarjamming"] = oRs[9]
                    
                elif oRs[8] == 0:
                    planet["radarstrength"] = 0
                    planet["radarjamming"] = 0
                else:
                    planet["radarstrength"] = oRs[8]
                    planet["radarjamming"] = oRs[9]

            if hasPlanetInfo and displayPlanetInfo:
                planet["floor"] = oRs[6]
                planet["space"] = oRs[7]
                planet["a_ore"] = oRs[18]
                planet["a_hydrocarbon"] = oRs[19]
                planet["vortex_strength"] = oRs[23]
                planet["info"] = True
            else:
                planet["floor"] = ""
                planet["space"] = ""
                planet["vortex_strength"] = oRs[23]
                planet["noinfo"] = ""

            if displayResources and (oRs[10] > 0 or oRs[11] > 0):
                planet["ore"] = oRs[10]
                planet["hydrocarbon"] = oRs[11]
                planet["resources"] = True
            else:
                planet["ore"] = 0
                planet["hydrocarbon"] = 0
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

            if oRs[16]:
                planet["frozen"] = True
            else:
                planet["active"] = True

            #
            # display planet
            #
            planets.append(planet)

        if not self.IsPlayerAccount():
            content.Parse("dev")
        
        content.AssignValue("locations", planets)
        
        content.Parse("nav_sector")
        content.Parse("galaxy_link")
        
        #
        # Display gm_fleets movements according to player radar strength
        #

        if radarstrength > 0: self.displayRadar(content, galaxy, sector, radarstrength)

        return self.Display(content)
