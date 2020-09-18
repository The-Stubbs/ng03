# -*- coding: utf-8 -*-

from game.views._base import *

#-------------------------------------------------------------------------------
class View(BaseView):

    def dispatch(self, request, *args, **kwargs):

        response = super().pre_dispatch(request, *args, **kwargs)
        if response: return response
        
        self.selected_menu = "overview"
        
        content = GetTemplate(request, "overview")
        
        # --- alliance data
        
        if self.allianceId:
            query = "SELECT announce, tag, name, defcon FROM gm_alliances WHERE id=" + str(self.allianceId)
            alliance = dbDictRow(query)
            content.AssignValue("alliance", alliance)

        # --- empire data
        
        empire = {}
        content.AssignValue("empire", empire)
        
        empire["date"] = timezone.now()
        empire["name"] = self.userInfo["login"]
        empire["credits"] = self.userInfo["credits"]
        empire["orientation"] = self.userInfo["orientation"]
        empire["max_planets"] = int(self.userInfo["mod_planets"])
        empire["prestige_points"] = self.userInfo["prestige_points"]

        if self.allianceRights: empire["rank_label"] = self.allianceRights["label"]
        
        query = "SELECT int4(count(1)) FROM vw_gm_profiles"
        row = dbRow(query)
        empire["players"] = row[0]

        query = "SELECT int4(count(1)) FROM vw_gm_profiles WHERE score >= " + str(self.userInfo["score"])
        row = dbRow(query)
        empire["score_dev"] = self.userInfo["score"]
        empire["score_dev_rank"] = row[0]
        empire["score_dev_delta"] = self.userInfo["score"] - self.userInfo["previous_score"]
        
        query = "SELECT (SELECT score_prestige FROM gm_profiles WHERE id=" + str(self.userId) + "), (SELECT int4(count(1)) FROM vw_gm_profiles WHERE score_prestige >= (SELECT score_prestige FROM gm_profiles WHERE id=" + str(self.userId) + "))"
        row = dbRow(query)
        empire["score_battle"] = row[0]
        empire["score_battle_rank"] = row[1]
        
        query = "SELECT count(1), sum(ore_production), sum(hydrocarbon_production), " + \
                " int4(sum(workers)), int4(sum(scientists)), int4(sum(soldiers)), now()" + \
                " FROM vw_gm_planets WHERE planet_floor > 0 AND planet_space > 0 AND ownerid=" + str(self.userId)
        row = dbRow(query)
        empire["cur_planets"] = row[0]
        empire["prod_ore"] = row[1]
        empire["prod_hydro"] = row[2]

        oRs2 = dbRow("SELECT COALESCE(int4(sum(cargo_workers)), 0), COALESCE(int4(sum(cargo_scientists)), 0), COALESCE(int4(sum(cargo_soldiers)), 0) FROM gm_fleets WHERE ownerid=" + str(self.userId))
        empire["workers"] = row[3] + oRs2[0]
        empire["scientists"] = row[4] + oRs2[1]
        empire["soldiers"] = row[5] + oRs2[2]

        # --- moving fleets
        
        fleets = []
        content.AssignValue("fleets", fleets)
        
        query =	"SELECT f.id, f.name, f.signature, f.ownerid, " + \
                "COALESCE((( SELECT vw_gm_profile_relations.relation FROM vw_gm_profile_relations WHERE vw_gm_profile_relations.user1 = gm_profiles.id AND vw_gm_profile_relations.user2 = f.ownerid)), -3) AS owner_relation, f.owner_name," + \
                "f.planetid, f.planet_name, COALESCE((( SELECT vw_gm_profile_relations.relation FROM vw_gm_profile_relations WHERE vw_gm_profile_relations.user1 = gm_profiles.id AND vw_gm_profile_relations.user2 = f.planet_ownerid)), -3) AS planet_owner_relation, f.planet_galaxy, f.planet_sector, f.planet_planet, " + \
                "f.destplanetid, f.destplanet_name, COALESCE((( SELECT vw_gm_profile_relations.relation FROM vw_gm_profile_relations WHERE vw_gm_profile_relations.user1 = gm_profiles.id AND vw_gm_profile_relations.user2 = f.destplanet_ownerid)), -3) AS destplanet_owner_relation, f.destplanet_galaxy, f.destplanet_sector, f.destplanet_planet, " + \
                "f.planet_owner_name, f.destplanet_owner_name, f.speed," + \
                "COALESCE(f.remaining_time, 0), COALESCE(f.total_time-f.remaining_time, 0), " + \
                "( SELECT int4(COALESCE(max(gm_planets.radar_strength), 0)) FROM gm_planets WHERE gm_planets.galaxy = f.planet_galaxy AND gm_planets.sector = f.planet_sector AND gm_planets.ownerid IS NOT NULL AND EXISTS ( SELECT 1 FROM vw_gm_friend_radars WHERE vw_gm_friend_radars.friend = gm_planets.ownerid AND vw_gm_friend_radars.userid = gm_profiles.id)) AS from_radarstrength, " + \
                "( SELECT int4(COALESCE(max(gm_planets.radar_strength), 0)) FROM gm_planets WHERE gm_planets.galaxy = f.destplanet_galaxy AND gm_planets.sector = f.destplanet_sector AND gm_planets.ownerid IS NOT NULL AND EXISTS ( SELECT 1 FROM vw_gm_friend_radars WHERE vw_gm_friend_radars.friend = gm_planets.ownerid AND vw_gm_friend_radars.userid = gm_profiles.id)) AS to_radarstrength, " + \
                "attackonsight" + \
                " FROM gm_profiles, vw_gm_fleets f " + \
                " WHERE gm_profiles.id=" + str(self.userId) + " AND (""action"" = 1 OR ""action"" = -1) AND (ownerid=" + str(self.userId) + " OR (destplanetid IS NOT NULL AND destplanetid IN (SELECT id FROM gm_planets WHERE ownerid=" + str(self.userId) + ")))" + \
                " ORDER BY ownerid, COALESCE(remaining_time, 0)"
        oRss = dbRows(query)
        
        if oRss:
            for row in oRss:
                
                extRadarStrength = row[23]
                incRadarStrength = row[24]
                if row[6] and row[4] < rAlliance and (row[21] > sqrt(incRadarStrength) * 6 * 1000 / row[20] * 3600) and (extRadarStrength == 0 or incRadarStrength == 0):
                    continue
                
                fleet = {}
    
                fleet["time"] = row[21]
                fleet["signature"] = row[2]
                
                dest = {}
                fleet["dest"] = dest
                dest["id"] = row[12]
                dest["name"] = self.getPlanetName(row[14], row[24], row[19], row[13])
                dest["relation"] = row[14]
                dest["g"] = row[15]
                dest["s"] = row[16]
                dest["p"] = row[17]
    
                if row[6] and extRadarStrength > 0 or row[4] >= rAlliance or row[8] >= rFriend:
                    origin = {}
                    fleet["origin"] = origin
                    origin["planetname"] = self.getPlanetName(row[8], row[23], row[18], row[7])
                    origin["planetid"] = row[6]
                    origin["g"] = row[9]
                    origin["s"] = row[10]
                    origin["p"] = row[11]
                    origin["relation"] = row[8]
                
                if row[4] == rSelf:
                    fleet["id"] = row[0]
                    fleet["name"] = row[1]
                    fleet["stance"] = row[25]
                    fleet["owned"] = True

                elif row[4] == rAlliance:
                    fleet["id"] = item[3]
                    fleet["name"] = item[5]
                    fleet["stance"] = row[25]
                    fleet["ally"] = True
                    
                elif row[4] == rFriend:
                    fleet["id"] = item[3]
                    fleet["name"] = item[5]
                    fleet["stance"] = row[25]
                    fleet["friend"] = True
                    
                else:
                    fleet["id"] = item[3]
                    fleet["name"] = item[5]
                    fleet["hostile"] = True

                fleets.append(fleet)

        # --- research in progress
        
        query = "SELECT researchid, int4(date_part('epoch', end_time - now())), dt_researches.label" + \
                " FROM gm_profile_research_pendings" + \
                "	 JOIN dt_researches ON dt_researches.id = researchid" + \
                " WHERE userid=" + str(self.userId) + " LIMIT 1"
        row = dbRow(query)
        
        if row:
            
            research = {}
            content.AssignValue("research", research)
            
            research["id"] = row[0]
            research["label"] = row[2]
            research["time"] = row[1]

        # --- current building constructions
        
        constructionyards = []
        content.AssignValue("constructionyards", constructionyards)
        
        query = "SELECT p.id, p.name, p.galaxy, p.sector, p.planet, b.buildingid, b.remaining_time, destroying, dt_buildings.label" + \
                " FROM gm_planets AS p" + \
                "	 LEFT JOIN vw_gm_planet_building_pendings AS b ON (p.id=b.planetid)" + \
                "	 LEFT JOIN dt_buildings ON dt_buildings.id = b.buildingid" + \
                " WHERE p.ownerid=" + str(self.userId) + \
                " ORDER BY p.id, destroying, remaining_time DESC"
        oRss = dbRows(query)

        lastplanet = -1
        for row in oRss:
            
            if row[0] != lastplanet:
                lastplanet = row[0]
                
                planet = { "buildings":[] }
                constructionyards.append(planet)

                planet["id"] = row[0]
                planet["name"] = row[1]
                planet["g"] = row[2]
                planet["s"] = row[3]
                planet["p"] = row[4]
            
            if row[5]:
                building = {}
                planet["buildings"].append(building)
                
                building["id"] = row[5]
                building["time"] = row[6]
                building["label"] = row[8]
                building["destroy"] = row[7]

        # --- current ship constructions
        
        shipyards = []
        content.AssignValue("shipyards", shipyards)
        
        query = "SELECT p.id, p.name, p.galaxy, p.sector, p.planet, s.shipid, s.remaining_time, s.recycle, p.shipyard_next_continue IS NOT NULL, p.shipyard_suspended," + \
                " (SELECT shipid FROM gm_planet_ship_pendings WHERE planetid=p.id ORDER BY start_time LIMIT 1)" + \
                " FROM gm_planets AS p" + \
                "	 LEFT JOIN vw_gm_planet_ship_pendings AS s ON (p.id=s.planetid AND p.ownerid=s.ownerid AND s.end_time IS NOT NULL)" + \
                " WHERE (s.recycle OR EXISTS(SELECT 1 FROM gm_planet_buildings WHERE (buildingid = 105 OR buildingid = 205) AND planetid=p.id)) AND p.ownerid=" + str(self.userId) + \
                " ORDER BY p.id, s.remaining_time DESC"
        oRss = dbRows(query)
        if oRss:
            for row in oRss:
                
                planet = {}
                shipyards.append(planet)

                planet["id"] = row[0]
                planet["name"] = row[1]
                planet["g"] = row[2]
                planet["s"] = row[3]
                planet["p"] = row[4]
                
                if row[5]:
                    planet["inprogress"] = True
                    
                    ship = {}
                    planet["ship"] = ship
                    
                    ship["id"] = row[5]
                    ship["label"] = getShipLabel(row[5])
                    ship["time"] = row[6]
                    ship["recycle"] = row[7]
    
                elif row[9]:
                    planet["suspended"] = True

                elif row[8]:
                    planet["waiting"] = True
                    
                    ship = {}
                    planet["ship"] = ship

                    ship["label"] = getShipLabel(row[10])

                else:
                    planet["none"] = True

        return self.display(content)
