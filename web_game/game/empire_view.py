# -*- coding: utf-8 -*-

from web_game.game._global import *



class View(GlobalView):
    
    def dispatch(self, request, *args, **kwargs):
        
        response = super().pre_dispatch(request, *args, **kwargs)
        if response: return response
            
        return super().dispatch(request, *args, **kwargs)
    
    
    
    def get(self, request, *args, **kwargs):

        self.selected_menu = "empire"
        self.selected_tab = "overview"
        
        content = GetTemplate(request, "empire_view")

        # --- user alliance data
        
        if self.AllianceId:
            
            query = " SELECT announce, tag, name, defcon" + \
                    " FROM alliances WHERE id=" + str(self.AllianceId)
            row = oConnRow(query)

            row["rank_label"] = self.oAllianceRights["label"]
            content.AssignValue("alliance", row)

        # --- user stats data
        
        stats = {}
        content.AssignValue("stats", stats)

        stats["dev_score"] = self.oPlayerInfo["score"]
        stats["dev_score_delta"] = self.oPlayerInfo["score"] - self.oPlayerInfo["previous_score"]
        
        stats["battle_score"] = self.oPlayerInfo["score_prestige"]

        query = " SELECT int4(count(1)) AS player_count," + \
                " (SELECT int4(count(1)) AS dev_rank FROM vw_players WHERE score >= " + str(self.oPlayerInfo["score"]) + ")," + \
                " (SELECT int4(count(1)) AS battle_rank FROM vw_players WHERE score_prestige >= " + str(self.oPlayerInfo["score_prestige"]) + ")" + \
                " FROM vw_players"
        row = oConnRow(query)
        stats.update(row)

        query = " SELECT sum(ore_production) AS prod_ore, sum(hydrocarbon_production) AS prod_hydro, " + \
                " int4(sum(workers)) AS worker_count, int4(sum(scientists)) AS scientist_count, int4(sum(soldiers)) AS soldier_count" + \
                " FROM vw_planets WHERE planet_floor > 0 AND planet_space > 0 AND ownerid=" + str(self.UserId)
        row = oConnRow(query)
        stats.update(row)

        query = " SELECT COALESCE(int4(sum(cargo_workers)), 0), COALESCE(int4(sum(cargo_scientists)), 0), COALESCE(int4(sum(cargo_soldiers)), 0)" + \
                " FROM fleets WHERE ownerid=" + str(self.UserId)
        row = oConnExecute(query)
        stats["worker_count"] += row[0]
        stats["scientist_count"] += row[1]
        stats["soldier_count"] += row[2]

        # --- user moving fleets data + moving fleets to user planets data
        
        fleets = []
        content.AssignValue("fleets", fleets)
        
        query =	" SELECT f.id, f.name, f.signature, f.ownerid, " + \
                " COALESCE((( SELECT vw_relations.relation FROM vw_relations WHERE vw_relations.user1 = users.id AND vw_relations.user2 = f.ownerid)), -3) AS owner_relation, f.owner_name," + \
                " f.planetid, f.planet_name, COALESCE((( SELECT vw_relations.relation FROM vw_relations WHERE vw_relations.user1 = users.id AND vw_relations.user2 = f.planet_ownerid)), -3) AS planet_owner_relation, f.planet_galaxy, f.planet_sector, f.planet_planet, " + \
                " f.destplanetid, f.destplanet_name, COALESCE((( SELECT vw_relations.relation FROM vw_relations WHERE vw_relations.user1 = users.id AND vw_relations.user2 = f.destplanet_ownerid)), -3) AS destplanet_owner_relation, f.destplanet_galaxy, f.destplanet_sector, f.destplanet_planet, " + \
                " f.planet_owner_name, f.destplanet_owner_name, f.speed," + \
                " COALESCE(f.remaining_time, 0), COALESCE(f.total_time - f.remaining_time, 0), " + \
                " (SELECT int4(COALESCE(max(nav_planet.radar_strength), 0)) FROM nav_planet WHERE nav_planet.galaxy = f.planet_galaxy AND nav_planet.sector = f.planet_sector AND nav_planet.ownerid IS NOT NULL AND EXISTS ( SELECT 1 FROM vw_friends_radars WHERE vw_friends_radars.friend = nav_planet.ownerid AND vw_friends_radars.userid = users.id)) AS from_radarstrength, " + \
                " (SELECT int4(COALESCE(max(nav_planet.radar_strength), 0)) FROM nav_planet WHERE nav_planet.galaxy = f.destplanet_galaxy AND nav_planet.sector = f.destplanet_sector AND nav_planet.ownerid IS NOT NULL AND EXISTS ( SELECT 1 FROM vw_friends_radars WHERE vw_friends_radars.friend = nav_planet.ownerid AND vw_friends_radars.userid = users.id)) AS to_radarstrength, " + \
                " attackonsight" + \
                " FROM users, vw_fleets f " + \
                " WHERE users.id=" + str(self.UserId) + " AND (""action"" = 1 OR ""action"" = -1) AND (ownerid=" + str(self.UserId) + " OR (destplanetid IS NOT NULL AND destplanetid IN (SELECT id FROM nav_planet WHERE ownerid=" + str(self.UserId) + ")))" + \
                " ORDER BY ownerid, COALESCE(remaining_time, 0)"
        rows = oConnExecuteAll(query)
        if rows:
            for item in rows:
    
                parseFleet = True
                parseFrom = False

                if item[6]:
                    if item[4] < rAlliance and (item[21] > sqrt(item[24]) * 6 * 1000 / item[20] * 3600) and (item[23] == 0 or item[24] == 0):
                        parseFleet = False
                    else:
                        if item[24] > 0 or item[4] >= rAlliance or item[8] >= rFriend:
                            parseFrom = True

                if parseFleet:
                    
                    fleet = {}
                    fleets.append(fleet)
        
                    fleet["relation"] = item[4]
                    fleet["signature"] = item[2]
                    fleet["remaining_time"] = item[21]
        
                    if parseFrom:
        
                        fleet["planet"] = {}
                        fleet["planet"]["name"] = self.getPlanetName(item[8], item[23], item[18], item[7])
                        fleet["planet"]["id"] = item[6]
                        fleet["planet"]["g"] = item[9]
                        fleet["planet"]["s"] = item[10]
                        fleet["planet"]["p"] = item[11]
                        fleet["planet"]["relation"] = item[8]
        
                    fleet["dest"] = {}
                    fleet["dest"]["name"] = self.getPlanetName(item[14], item[24], item[19], item[13])
                    fleet["dest"]["id"] = item[12]
                    fleet["dest"]["g"] = item[15]
                    fleet["dest"]["s"] = item[16]
                    fleet["dest"]["p"] = item[17]
                    fleet["dest"]["relation"] = item[14]
        
                    if item[4] == rSelf:
                        
                        fleet["id"] = item[0]
                        fleet["name"] = item[1]
                        fleet["stance"] = item[25]

                    else:

                        fleet["id"] = item[3]
                        fleet["name"] = item[5]

        # --- user current research data
        
        query = " SELECT researchid AS id, int4(date_part('epoch', end_time-now())) AS remaining_time, db_research.label" + \
                " FROM researches_pending" + \
                "   JOIN db_research ON db_research.id = researchid" + \
                " WHERE userid=" + str(self.UserId)
        row = oConnRow(query)
        content.AssignValue("research", row)

        # --- user current buildings data
        
        constructionyards = []
        content.AssignValue("constructionyards", constructionyards)
        
        query = " SELECT p.id, p.name, p.galaxy, p.sector, p.planet, b.buildingid, b.remaining_time, destroying, db_buildings.label" + \
                " FROM nav_planet AS p" + \
                "   LEFT JOIN vw_buildings_under_construction2 AS b ON (p.id=b.planetid)" + \
                "   LEFT JOIN db_buildings ON db_buildings.id = b.buildingid" + \
                " WHERE p.ownerid=" + str(self.UserId) + \
                " ORDER BY p.id, destroying, remaining_time"
        rows = oConnExecuteAll(query)

        lastplanet = -1
        for item in rows:
            
            if item[0] != lastplanet:
                lastplanet = item[0]
                
                planet = { "buildings":[] }
                constructionyards.append(planet)
                
                planet["id"] = item[0]
                planet["name"] = item[1]
                planet["g"] = item[2]
                planet["s"] = item[3]
                planet["p"] = item[4]

            if item[5]:
                
                building = {}
                planet["buildings"].append(building)
                
                building["id"] = item[5]
                building["label"] = item[8]
                building["remaining_time"] = item[6]
                building["is_destroying"] = item[7]

        # --- user current ships data
        
        query = " SELECT p.id, p.name, p.galaxy, p.sector, p.planet, s.shipid, s.remaining_time, s.recycle, p.shipyard_next_continue IS NOT NULL, p.shipyard_suspended," + \
                " (SELECT shipid FROM planet_ships_pending WHERE planetid=p.id ORDER BY start_time LIMIT 1), db_ships.label, (SELECT db_ships.label FROM planet_ships_pending JOIN db_ships ON db_ships.id =shipid WHERE planetid=p.id ORDER BY start_time LIMIT 1)" + \
                " FROM nav_planet AS p" + \
                "	LEFT JOIN vw_ships_under_construction AS s ON (p.id=s.planetid AND p.ownerid=s.ownerid AND s.end_time IS NOT NULL)" + \
                "   LEFT JOIN db_ships ON db_ships.id = s.shipid" + \
                " WHERE (s.recycle OR EXISTS(SELECT 1 FROM planet_buildings WHERE (buildingid = 105 OR buildingid = 205) AND planetid=p.id)) AND p.ownerid=" + str(self.UserId) + \
                " ORDER BY p.id, s.remaining_time DESC"
        rows = oConnExecuteAll(query)
        if rows:
            
            shipyards = []
            content.AssignValue("shipyards", shipyards)
            
            for item in rows:
                
                planet = {}
                shipyards.append(planet)

                planet["id"] = item[0]
                planet["name"] = item[1]
                planet["g"] = item[2]
                planet["s"] = item[3]
                planet["p"] = item[4]
                
                if item[5]:
                    
                    planet["ship"] = {}
                    planet["ship"]["id"] = item[5]
                    planet["ship"]["label"] = item[11]
                    planet["ship"]["remaining_time"] = item[6]
                    planet["ship"]["is_recycling"] = item[7]

                elif item[8]:
                    
                    planet["ship"] = {}
                    planet["ship"]["label"] = item[12]
                    planet["ship"]["is_waiting"] = True

        return self.Display(content)
