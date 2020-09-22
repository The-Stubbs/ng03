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
    
        self.selected_menu = "overview"
        
        content = GetTemplate(request, "overview")
        data = content.data

        # ---
        if self.AllianceId:

            query = " SELECT announce, tag, name, defcon" + \
                    " FROM alliances" + \
                    " WHERE id=" + str(self.AllianceId)
            row = oConnExecute(query)
            if row:
                data["alliance"] = {}
                data["alliance"]["announce"] = row[0]
                data["alliance"]["tag"] = row[1]
                data["alliance"]["name"] = row[2]
                data["alliance"]["defcon"] = row[3]

        # ---
        data["orientation"] = self.oPlayerInfo["orientation"]
        data["username"] = self.oPlayerInfo["login"]
        data["rank_label"] = self.oAllianceRights["label"] if self.AllianceId else None
        data["credit_count"] = self.oPlayerInfo["credits"]
        data["dev_score"] = self.oPlayerInfo["score"]
        data["dev_score_delta"] = self.oPlayerInfo["score"] - self.oPlayerInfo["previous_score"]                
        data["prestige_count"] = self.oPlayerInfo["prestige_points"]
        data["planet_max"] = int(self.oPlayerInfo["mod_planets"])

        query = " SELECT int4(count(1))," + \
                " (SELECT int4(count(1)) FROM vw_players WHERE score >= "+str(self.oPlayerInfo["score"])+")" + \
                " FROM vw_players"
        row = oConnExecute(query)
        if row:
            data["player_count"] = row[0]
            data["dev_rank"] = row[1]

        query = "SELECT (SELECT score_prestige FROM users WHERE id="+str(self.UserId)+"), (SELECT int4(count(1)) FROM vw_players WHERE score_prestige >= (SELECT score_prestige FROM users WHERE id=" + str(self.UserId) + "))"
        oRs = oConnExecute(query)
        if oRs:
            data["battle_score"] = oRs[0]
            data["battle_rank"] = oRs[1]

        query = "SELECT count(1), sum(ore_production), sum(hydrocarbon_production), " + \
                " int4(sum(workers)), int4(sum(scientists)), int4(sum(soldiers)), now()" + \
                " FROM vw_planets WHERE planet_floor > 0 AND planet_space > 0 AND ownerid=" + str(self.UserId)
        oRs = oConnExecute(query)
        if oRs:
            data["date"] = oRs[6]
            data["planet_count"] = oRs[0]
            data["prod_ore"] = oRs[1]
            data["prod_hydro"] = oRs[2]

            oRs2 = oConnExecute("SELECT COALESCE(int4(sum(cargo_workers)), 0), COALESCE(int4(sum(cargo_scientists)), 0), COALESCE(int4(sum(cargo_soldiers)), 0) FROM fleets WHERE ownerid=" + str(self.UserId))

            data["worker_count"] = oRs[3] + oRs2[0]
            data["scientist_count"] = oRs[4] + oRs2[1]
            data["soldier_count"] = oRs[5] + oRs2[2]

        # ---
        constructionyards = []
        content.AssignValue("constructionyards", constructionyards)
        
        query = "SELECT p.id, p.name, p.galaxy, p.sector, p.planet, b.buildingid, b.remaining_time, destroying" +\
                " FROM nav_planet AS p" +\
                "	 LEFT JOIN vw_buildings_under_construction2 AS b ON (p.id=b.planetid)"+\
                " WHERE p.ownerid="+str(self.UserId)+\
                " ORDER BY p.id, destroying, remaining_time DESC"
        oRs = oConnExecuteAll(query)
        lastplanet = -1
        for item in oRs:
            if item[0] != lastplanet:
                lastplanet = item[0]
                
                planet = {"buildings":[]}
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
                building["name"] = getBuildingLabel(item[5])
                building["time"] = item[6]
                if item[7]: building["destroying"] = True

        # ---
        query = "SELECT p.id, p.name, p.galaxy, p.sector, p.planet, s.shipid, s.remaining_time, s.recycle, p.shipyard_next_continue IS NOT NULL, p.shipyard_suspended," +\
                " (SELECT shipid FROM planet_ships_pending WHERE planetid=p.id ORDER BY start_time LIMIT 1)" +\
                " FROM nav_planet AS p" +\
                "	LEFT JOIN vw_ships_under_construction AS s ON (p.id=s.planetid AND p.ownerid=s.ownerid AND s.end_time IS NOT NULL)"+\
                " WHERE (s.recycle OR EXISTS(SELECT 1 FROM planet_buildings WHERE (buildingid = 105 OR buildingid = 205) AND planetid=p.id)) AND p.ownerid=" + str(self.UserId) +\
                " ORDER BY p.id, s.remaining_time DESC"
        oRs = oConnExecuteAll(query)
        if oRs:
            constructionyards = []
            content.AssignValue("shipyards", shipyards)
            for item in oRs:
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
                    planet["ship"]["name"] = getShipLabel(item[5])
                    planet["ship"]["time"] = item[6]
                    planet["ship"]["recycling"] = item[7]
                    
                elif item[9]:
                    planet["suspended"] = True
                    
                elif item[8]:
                    planet["waiting_resources"] = True
                    planet["waiting_ship"] = getShipLabel(item[10])

        # ---
        query = "SELECT researchid, int4(date_part('epoch', end_time-now()))" +\
                " FROM researches_pending" +\
                " WHERE userid=" + str(self.UserId)
        oRs = oConnExecute(query)
        if oRs:
            research = {}
            content.AssignValue("research", research)
            
            research["id"] = item[0]
            research["name"] = getResearchLabel(item[0])
            research["time"] = item[1]

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
        oRs = oConnExecuteAll(query)

        fleets = []
        i = 0
        if oRs:
            for item in oRs:
    
                parseFleet = True
                fleet = {}
    
                fleet["signature"] = item[2]
    
                # display planet names f (from) and t (to)
    
                fleet["f_planetname"] = self.getPlanetName(item[8], item[23], item[18], item[7])
                fleet["f_planetid"] = item[6]
                fleet["f_g"] = item[9]
                fleet["f_s"] = item[10]
                fleet["f_p"] = item[11]
                fleet["f_relation"] = item[8]
    
                fleet["t_planetname"] = self.getPlanetName(item[14], item[24], item[19], item[13])
                fleet["t_planetid"] = item[12]
                fleet["t_g"] = item[15]
                fleet["t_s"] = item[16]
                fleet["t_p"] = item[17]
                fleet["t_relation"] = item[14]
    
                fleet["time"] = item[21]
                
                # retrieve the radar strength where the fleet comes from
                extRadarStrength = item[23]
                
                # retrieve the radar strength where the fleet goes to
                incRadarStrength = item[24]
    
                # if remaining time is longer than our radar range
                if item[6]: # if origin planet is not null
    
                    if item[4] < rAlliance and (item[21] > sqrt(incRadarStrength)*6*1000/item[20]*3600) and (extRadarStrength == 0 or incRadarStrength == 0):
                        parseFleet = False
                    else:
                        # display origin if we have a radar or the planet owner is an ally or the fleet is in NAP
                        if extRadarStrength > 0 or item[4] >= rAlliance or item[8] >= rFriend:
                            fleet["movingfrom"] = True
                        else:
                            fleet["no_from"] = True
    
                if parseFleet:
    
                    # assign either fleet name or fleet owner name
                    if item[4] == rSelf:
                        # Assign fleet (id & name)
                        fleet["id"] = item[0]
                        fleet["name"] = item[1]
                        if item[25]:
                            fleet["attack"] = True
                        else:
                            fleet["defend"] = True
                        fleet["owned"] = True
                    elif item[4] == rAlliance:
                        # assign fleet owner (id & name)
                        fleet["id"] = item[3]
                        fleet["name"] = item[5]
                        if item[25]:
                            fleet["attack"] = True
                        else:
                            fleet["defend"] = True
                        fleet["ally"] = True
                    elif item[4] == rFriend:
                        # assign fleet owner (id & name)
                        fleet["id"] = item[3]
                        fleet["name"] = item[5]
                        if item[25]:
                            fleet["attack"] = True
                        else:
                            fleet["defend"] = True
                        fleet["friend"] = True
                    else:
                        # assign fleet owner (id & name)
                        fleet["id"] = item[3]
                        fleet["name"] = item[5]
                        fleet["hostile"] = True
    
                    fleets.append(fleet)
                    i = i + 1

        if i==0: content.Parse("nofleets")
        content.AssignValue("fleets", fleets)
        
        return self.Display(content)
