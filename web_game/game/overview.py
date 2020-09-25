# -*- coding: utf-8 -*-

from math import sqrt

from web_game.game._global import *
from web_game.lib.accounts import *

class View(GlobalView):
        
    def dispatch(self, request, *args, **kwargs):

        response = super().pre_dispatch(request, *args, **kwargs)
        if response: return response
        
        return super().dispatch(request, *args, **kwargs)
        
    def get(self, request, *args, **kwargs):
    
        self.selected_tab = "empire"
        self.selected_menu = "overview"
        
        content = GetTemplate(request, "overview")
        data = content.data

        # --- alliance data
        
        if self.AllianceId:

            query = " SELECT announce, tag, name, defcon" + \
                    " FROM alliances" + \
                    " WHERE id=" + str(self.AllianceId)
            data["alliance"] = oConnRow(query)

        # --- empire stats data
        
        query = " SELECT orientation, ""login"" AS username, credits AS credit_count, alliances_ranks.label AS rank_label," + \
                "   users.score AS dev_score, (users.score - users.previous_score) AS dev_score_delta, prestige_points AS prestige_count," + \
                "   int4(mod_planets) AS planet_max, (SELECT int4(count(1)) AS player_count FROM vw_players)," + \
                "   (SELECT int4(count(1)) AS dev_rank FROM vw_players WHERE vw_players.score >= users.score)," + \
                "   score_prestige AS battle_score, (SELECT int4(count(1)) AS battle_rank FROM vw_players WHERE vw_players.score_prestige >= score_prestige)," + \
                "   (SELECT count(1) AS planet_count FROM vw_planets WHERE planet_floor > 0 AND planet_space > 0 AND ownerid=users.id)," + \
                "   (SELECT sum(ore_production) AS prod_ore FROM vw_planets WHERE planet_floor > 0 AND planet_space > 0 AND ownerid=users.id)," + \
                "   (SELECT sum(hydrocarbon_production) AS prod_hydro FROM vw_planets WHERE planet_floor > 0 AND planet_space > 0 AND ownerid=users.id)," + \
                "   (SELECT ((SELECT sum(workers) FROM vw_planets WHERE planet_floor > 0 AND planet_space > 0 AND ownerid=users.id) + (SELECT COALESCE(int4(sum(cargo_workers)), 0) FROM fleets WHERE ownerid=users.id)) AS worker_count)," + \
                "   (SELECT ((SELECT sum(scientists) FROM vw_planets WHERE planet_floor > 0 AND planet_space > 0 AND ownerid=users.id) + (SELECT COALESCE(int4(sum(cargo_scientists)), 0) FROM fleets WHERE ownerid=users.id)) AS scientist_count)," + \
                "   (SELECT ((SELECT sum(soldiers) FROM vw_planets WHERE planet_floor > 0 AND planet_space > 0 AND ownerid=users.id) + (SELECT COALESCE(int4(sum(cargo_soldiers)), 0) FROM fleets WHERE ownerid=users.id)) AS soldier_count)" + \
                " FROM users" + \
                "   LEFT JOIN alliances_ranks ON users.alliance_rank=alliances_ranks.rankid" + \
                " WHERE users.id=" + str(self.UserId)
        data["stats"] = oConnRow(query)

        # --- pending research data
        
        query = " SELECT researchid AS id, db_research.label AS name, int4(date_part('epoch', end_time - now())) AS remaining_time" + \
                " FROM researches_pending" + \
                "   JOIN db_research ON researches_pending.researchid=db_research.id" + \
                " WHERE userid=" + str(self.UserId)
        data["research"] = oConnRow(query)

        # --- moving fleets data
        
        query =	"SELECT f.id, f.name, f.signature, f.ownerid, " +\
                "COALESCE((( SELECT vw_relations.relation FROM vw_relations WHERE vw_relations.user1 = users.id AND vw_relations.user2 = f.ownerid)), -3) AS owner_relation, f.owner_name," +\
                "f.planetid, f.planet_name, COALESCE((( SELECT vw_relations.relation FROM vw_relations WHERE vw_relations.user1 = users.id AND vw_relations.user2 = f.planet_ownerid)), -3) AS planet_owner_relation, f.planet_galaxy, f.planet_sector, f.planet_planet, " +\
                "f.destplanetid, f.destplanet_name, COALESCE((( SELECT vw_relations.relation FROM vw_relations WHERE vw_relations.user1 = users.id AND vw_relations.user2 = f.destplanet_ownerid)), -3) AS destplanet_owner_relation, f.destplanet_galaxy, f.destplanet_sector, f.destplanet_planet, " +\
                "f.planet_owner_name, f.destplanet_owner_name, f.speed," +\
                "COALESCE(f.remaining_time, 0), COALESCE(f.total_time-f.remaining_time, 0), " +\
                "( SELECT int4(COALESCE(max(nav_planet.radar_strength), 0)) FROM nav_planet WHERE nav_planet.galaxy = f.planet_galaxy AND nav_planet.sector = f.planet_sector AND nav_planet.ownerid IS NOT NULL AND EXISTS ( SELECT 1 FROM vw_friends_radars WHERE vw_friends_radars.friend = nav_planet.ownerid AND vw_friends_radars.userid = users.id)) AS from_radarstrength, " +\
                "( SELECT int4(COALESCE(max(nav_planet.radar_strength), 0)) FROM nav_planet WHERE nav_planet.galaxy = f.destplanet_galaxy AND nav_planet.sector = f.destplanet_sector AND nav_planet.ownerid IS NOT NULL AND EXISTS ( SELECT 1 FROM vw_friends_radars WHERE vw_friends_radars.friend = nav_planet.ownerid AND vw_friends_radars.userid = users.id)) AS to_radarstrength, " +\
                "attackonsight" +\
                " FROM users, vw_fleets f " +\
                " WHERE users.id="+str(self.UserId)+" AND (""action"" = 1 OR ""action"" = -1) AND (ownerid="+str(self.UserId)+" OR (destplanetid IS NOT NULL AND destplanetid IN (SELECT id FROM nav_planet WHERE ownerid="+str(self.UserId)+")))" +\
                " ORDER BY ownerid, COALESCE(remaining_time, 0)"
        rows = oConnRows(query)
        if rows:
            data["fleets"] = []
            for row in rows:
                
                parseFleet = True
                if row["planetid"]:
    
                    if row["owner_relation"] < rAlliance and (row["remaining_time"] > sqrt(item["to_radarstrength"])*6*1000/item["speed"]*3600) and (extRadarStrength == 0 or incRadarStrength == 0):
                        parseFleet = False
                    else:
                        if item["from_radarstrength"] > 0 or row["owner_relation"] >= rAlliance or item["planet_owner_relation"] >= rFriend: item["movingfrom"] = True
                        else: item["no_from"] = True
    
                if parseFleet: data["fleets"].append(row)

        # --- pending buildings data
        
        query = " SELECT id, name, galaxy AS g, sector AS s, planet AS p" + \
                " FROM nav_planet" + \
                " WHERE ownerid=" + str(self.UserId) + \
                " ORDER BY id"
        data["constructionyards"] = oConnRows(query)
        
        for item in data["constructionyards"]:
            query = "SELECT buildingid AS id, label AS name, remaining_time, destroying" + \
                    " FROM vw_buildings_under_construction2"+ \
                    "   JOIN db_buildings ON vw_buildings_under_construction2.buildingid=db_buildings.id" + \
                    " WHERE planetid=" + str(item["id"]) + \
                    " ORDER BY destroying, remaining_time DESC"
            item["buildings"] = oConnRows(query)

        # --- pending ships data
        
        query = " SELECT id, name, galaxy AS g, sector AS s, planet AS p" + \
                " FROM nav_planet" + \
                " WHERE EXISTS(SELECT 1 FROM planet_buildings WHERE (buildingid = 105 OR buildingid = 205) AND planetid=nav_planet.id) AND ownerid=" + str(self.UserId) + \
                " ORDER BY id"
        data["shipyards"] = oConnRows(query)
        
        for item in data["shipyards"]:
            query = "SELECT shipid AS id, s.remaining_time, recycle AS recycling, shipyard_next_continue IS NOT NULL AS waiting, shipyard_suspended AS suspended," +\
                    " (SELECT shipid AS waiting_ship_id FROM planet_ships_pending WHERE planetid=" + str(item["id"]) + " ORDER BY start_time LIMIT 1)" +\
                    " FROM vw_ships_under_construction"+\
                    " WHERE end_time IS NOT NULL AND planetid=" + str(item["id"])
            item["ship"] = oConnRow(query)
            
        return self.Display(content)
