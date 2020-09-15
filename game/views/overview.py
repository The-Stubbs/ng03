# -*- coding: utf-8 -*-

from game.views.lib._global import *

class View(GlobalView):

    def dispatch(self, request, *args, **kwargs):

        response = super().pre_dispatch(request, *args, **kwargs)
        if response: return response
        
        self.selected_menu = "overview"
        
        content = GetTemplate(request, "overview")
        
        # --- alliance data
        
        if self.AllianceId:
            query = "SELECT announce, tag, name, defcon FROM gm_alliances WHERE id=" + str(self.AllianceId)
            alliance = oConnRow(query)
            content.AssignValue("alliance", alliance)

        # --- empire data
        
        empire = {}
        content.AssignValue("empire", empire)
        
        empire["date"] = timezone.now()
        empire["name"] = self.oPlayerInfo["login"]
        empire["credits"] = self.oPlayerInfo["credits"]
        empire["orientation"] = self.oPlayerInfo["orientation"]
        empire["max_planets"] = int(self.oPlayerInfo["mod_planets"])
        empire["prestige_points"] = self.oPlayerInfo["prestige_points"]

        if self.oAllianceRights: empire["rank_label"] = self.oAllianceRights["label"]
        
        query = "SELECT int4(count(1)) FROM vw_gm_profiles"
        oRs = oConnExecute(query)
        empire["players"] = oRs[0]

        query = "SELECT int4(count(1)) FROM vw_gm_profiles WHERE score >= " + str(self.oPlayerInfo["score"])
        oRs = oConnExecute(query)
        empire["score_dev"] = self.oPlayerInfo["score"]
        empire["score_dev_rank"] = oRs[0]
        empire["score_dev_delta"] = self.oPlayerInfo["score"] - self.oPlayerInfo["previous_score"]
        
        query = "SELECT (SELECT score_prestige FROM gm_profiles WHERE id=" + str(self.UserId) + "), (SELECT int4(count(1)) FROM vw_gm_profiles WHERE score_prestige >= (SELECT score_prestige FROM gm_profiles WHERE id=" + str(self.UserId) + "))"
        oRs = oConnExecute(query)
        empire["score_battle"] = oRs[0]
        empire["score_battle_rank"] = oRs[1]
        
        query = "SELECT count(1), sum(ore_production), sum(hydrocarbon_production), " + \
                " int4(sum(workers)), int4(sum(scientists)), int4(sum(soldiers)), now()" + \
                " FROM vw_gm_planets WHERE planet_floor > 0 AND planet_space > 0 AND ownerid=" + str(self.UserId)
        oRs = oConnExecute(query)
        empire["cur_planets"] = oRs[0]
        empire["prod_ore"] = oRs[1]
        empire["prod_hydro"] = oRs[2]

        oRs2 = oConnExecute("SELECT COALESCE(int4(sum(cargo_workers)), 0), COALESCE(int4(sum(cargo_scientists)), 0), COALESCE(int4(sum(cargo_soldiers)), 0) FROM gm_fleets WHERE ownerid=" + str(self.UserId))
        empire["workers"] = oRs[3] + oRs2[0]
        empire["scientists"] = oRs[4] + oRs2[1]
        empire["soldiers"] = oRs[5] + oRs2[2]

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
                " WHERE gm_profiles.id=" + str(self.UserId) + " AND (""action"" = 1 OR ""action"" = -1) AND (ownerid=" + str(self.UserId) + " OR (destplanetid IS NOT NULL AND destplanetid IN (SELECT id FROM gm_planets WHERE ownerid=" + str(self.UserId) + ")))" + \
                " ORDER BY ownerid, COALESCE(remaining_time, 0)"
        oRss = oConnExecuteAll(query)
        
        if oRss:
            for oRs in oRss:
                
                extRadarStrength = oRs[23]
                incRadarStrength = oRs[24]
                if oRs[6] and oRs[4] < rAlliance and (oRs[21] > sqrt(incRadarStrength) * 6 * 1000 / oRs[20] * 3600) and (extRadarStrength == 0 or incRadarStrength == 0):
                    continue
                
                fleet = {}
    
                fleet["time"] = oRs[21]
                fleet["signature"] = oRs[2]
                
                dest = {}
                fleet["dest"] = dest
                dest["id"] = oRs[12]
                dest["name"] = self.getPlanetName(oRs[14], oRs[24], oRs[19], oRs[13])
                dest["relation"] = oRs[14]
                dest["g"] = oRs[15]
                dest["s"] = oRs[16]
                dest["p"] = oRs[17]
    
                if oRs[6] and extRadarStrength > 0 or oRs[4] >= rAlliance or oRs[8] >= rFriend:
                    origin = {}
                    fleet["origin"] = origin
                    origin["planetname"] = self.getPlanetName(oRs[8], oRs[23], oRs[18], oRs[7])
                    origin["planetid"] = oRs[6]
                    origin["g"] = oRs[9]
                    origin["s"] = oRs[10]
                    origin["p"] = oRs[11]
                    origin["relation"] = oRs[8]
                
                if oRs[4] == rSelf:
                    fleet["id"] = oRs[0]
                    fleet["name"] = oRs[1]
                    fleet["stance"] = oRs[25]
                    fleet["owned"] = True

                elif oRs[4] == rAlliance:
                    fleet["id"] = item[3]
                    fleet["name"] = item[5]
                    fleet["stance"] = oRs[25]
                    fleet["ally"] = True
                    
                elif oRs[4] == rFriend:
                    fleet["id"] = item[3]
                    fleet["name"] = item[5]
                    fleet["stance"] = oRs[25]
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
                " WHERE userid=" + str(self.UserId) + " LIMIT 1"
        oRs = oConnExecute(query)
        
        if oRs:
            
            research = {}
            content.AssignValue("research", research)
            
            research["id"] = oRs[0]
            research["label"] = oRs[2]
            research["time"] = oRs[1]

        # --- current building constructions
        
        constructionyards = []
        content.AssignValue("constructionyards", constructionyards)
        
        query = "SELECT p.id, p.name, p.galaxy, p.sector, p.planet, b.buildingid, b.remaining_time, destroying, dt_buildings.label" + \
                " FROM gm_planets AS p" + \
                "	 LEFT JOIN vw_gm_planet_building_pendings AS b ON (p.id=b.planetid)" + \
                "	 LEFT JOIN dt_buildings ON dt_buildings.id = b.buildingid" + \
                " WHERE p.ownerid=" + str(self.UserId) + \
                " ORDER BY p.id, destroying, remaining_time DESC"
        oRss = oConnExecuteAll(query)

        lastplanet = -1
        for oRs in oRss:
            
            if oRs[0] != lastplanet:
                lastplanet = oRs[0]
                
                planet = { "buildings":[] }
                constructionyards.append(planet)

                planet["id"] = oRs[0]
                planet["name"] = oRs[1]
                planet["g"] = oRs[2]
                planet["s"] = oRs[3]
                planet["p"] = oRs[4]
            
            if oRs[5]:
                building = {}
                planet["buildings"].append(building)
                
                building["id"] = oRs[5]
                building["time"] = oRs[6]
                building["label"] = oRs[8]
                building["destroy"] = oRs[7]

        # --- current ship constructions
        
        shipyards = []
        content.AssignValue("shipyards", shipyards)
        
        query = "SELECT p.id, p.name, p.galaxy, p.sector, p.planet, s.shipid, s.remaining_time, s.recycle, p.shipyard_next_continue IS NOT NULL, p.shipyard_suspended," + \
                " (SELECT shipid FROM gm_planet_ship_pendings WHERE planetid=p.id ORDER BY start_time LIMIT 1)" + \
                " FROM gm_planets AS p" + \
                "	 LEFT JOIN vw_gm_planet_ship_pendings AS s ON (p.id=s.planetid AND p.ownerid=s.ownerid AND s.end_time IS NOT NULL)" + \
                " WHERE (s.recycle OR EXISTS(SELECT 1 FROM gm_planet_buildings WHERE (buildingid = 105 OR buildingid = 205) AND planetid=p.id)) AND p.ownerid=" + str(self.UserId) + \
                " ORDER BY p.id, s.remaining_time DESC"
        oRss = oConnExecuteAll(query)
        if oRss:
            for oRs in oRss:
                
                planet = {}
                shipyards.append(planet)

                planet["id"] = oRs[0]
                planet["name"] = oRs[1]
                planet["g"] = oRs[2]
                planet["s"] = oRs[3]
                planet["p"] = oRs[4]
                
                if oRs[5]:
                    planet["inprogress"] = True
                    
                    ship = {}
                    planet["ship"] = ship
                    
                    ship["id"] = oRs[5]
                    ship["label"] = getShipLabel(oRs[5])
                    ship["time"] = oRs[6]
                    ship["recycle"] = oRs[7]
    
                elif oRs[9]:
                    planet["suspended"] = True

                elif oRs[8]:
                    planet["waiting"] = True
                    
                    ship = {}
                    planet["ship"] = ship

                    ship["label"] = getShipLabel(oRs[10])

                else:
                    planet["none"] = True

        return self.Display(content)
