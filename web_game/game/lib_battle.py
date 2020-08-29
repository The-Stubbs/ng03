# -*- coding: utf-8 -*-

from web_game.game._global import *

class View(GlobalView):

    def dispatch(self, request, *args, **kwargs):

        response = super().pre_dispatch(request, *args, **kwargs)
        if response: return response

    def FormatBattle(self, battleid, creator, pointofview, ispubliclink):
        FormatBattle = nothing

        # Retrieve/assign battle info
        query = "SELECT time, planetid, name, galaxy, sector, planet, rounds," + \
                "EXISTS(SELECT 1 FROM battles_ships WHERE battleid=" + battleid + " AND owner_id=" + creator + " AND won LIMIT 1), MD5(key||"+creator+")," + \
                "EXISTS(SELECT 1 FROM battles_ships WHERE battleid=" + battleid + " AND owner_id=" + creator + " AND damages > 0 LIMIT 1) AS see_details" + \
                " FROM battles" + \
                "    INNER JOIN nav_planet ON (planetid=nav_planet.id)" + \
                " WHERE battles.id = " + battleid
        oRs = oConnExecute(query)

        if oRs == None: exit function

        content = GetTemplate(self.request, "battle")

        content.AssignValue("battleid", battleid
        content.AssignValue("userid", creator
        content.AssignValue("key", oRs[8]

        if not ispubliclink:
            # link for the freely viewable report of this battle
            content.AssignValue("baseurl", Request.ServerVariables("HTTP_HOST")
            content.Parse("publiclink"

        content.AssignValue("time", oRs[0].value
        content.AssignValue("planetid", oRs[1]
        content.AssignValue("planet", oRs[2]
        content.AssignValue("g", oRs[3]
        content.AssignValue("s", oRs[4]
        content.AssignValue("p", oRs[5]
        content.AssignValue("rounds", oRs[6]

        rounds = oRs[6]
        hasWon = oRs[7]
        showEnemyDetails = oRs[9] or hasWon or rounds > 1

        query = "SELECT fleet_id, shipid, destroyed_shipid, sum(count)" + \
                " FROM battles_fleets" + \
                "    INNER JOIN battles_fleets_ships_kills ON (battles_fleets.id=fleetid)" + \
                " WHERE battleid=" + battleid + \
                " GROUP BY fleet_id, shipid, destroyed_shipid" + \
                " ORDER BY sum(count) DESC"
        oRs = oConnExecute(query)

        if oRs == None:
            killsCount = -1
        else:
            killsArray = oRs.GetRows()
            killsCount = UBound(killsArray, 2)

        query = "SELECT owner_name, fleet_name, shipid, shipcategory, shiplabel, count, lost, killed, won, relation1, owner_id , relation2, fleet_id, attacked, mod_shield, mod_handling, mod_tracking_speed, mod_damage, alliancetag" + \
                " FROM sp_get_battle_result(" + battleid + "," + creator + "," + pointofview + ")"

        oRss = oConnExecuteAll(query)

        if oRs:
            playerid = oRs[10]
            lastPlayerid = playerid
            lastPlayerColorRelation = oRs[11]

            player = oRs[0]
            lastPlayer = player

            tag = oRs["alliancetag")
            lastTag = tag

            lastPlayerWon = oRs[8]
            lastPlayerRelation = oRs[9]

            fleet = oRs[12]'oRs[1]
            lastFleet = fleet

            fleetName = oRs[1]
            lastFleetName = fleetName

            lastPlayerAggressive = oRs[13]

            content.AssignValue("mod_shield", oRs[14]
            content.AssignValue("mod_handling", oRs[15]
            content.AssignValue("mod_tracking_speed", oRs[16]
            content.AssignValue("mod_damage", oRs[17]

            if not showEnemyDetails and oRs[9] < rFriend:
                content.AssignValue("mod_shield", "?"
                content.AssignValue("mod_handling", "?"
                content.AssignValue("mod_tracking_speed", "?"
                content.AssignValue("mod_damage", "?"

        category = -1
        lastCategory = -1

        player_ships = 0
        player_lost = 0
        player_killed = 0

        fleet_ships = 0
        fleet_lost = 0
        fleet_killed = 0

        cat_ships = 0
        cat_lost = 0
        cat_killed = 0

        list = []
        for oRs in oRss:
            item = {}
            list.append(item)
            
            playerid = oRs[10]
            player = oRs[0]
            tag = oRs["alliancetag")
            fleet = oRs[12]
            fleetName = oRs[1]
            category = oRs[3]

            if (lastCategory > -1) and (category != lastCategory or fleet != lastFleet or player != lastPlayer):

                item["ships", cat_ships
                item["lost", cat_lost
                item["killed", cat_killed
                item["after", cat_ships - cat_lost
                content.Parse("opponent.fleet.ship"

                lastCategory = -1

            # finish a fleet
            if (fleet != lastFleet) or (player != lastPlayer):
                item["fleet", lastFleetName
                item["ships", fleet_ships
                item["lost", fleet_lost
                item["killed", fleet_killed
                item["after", fleet_ships - fleet_lost

                if lastPlayerColorRelation == rSelf:
                    Content.Parse "opponent.fleet.self"
                elif lastPlayerColorRelation == rAlliance:
                    Content.Parse "opponent.fleet.ally"
                elif lastPlayerColorRelation == rFriend:
                    Content.Parse "opponent.fleet.friend"
                else:
                    Content.Parse "opponent.fleet.enemy"

                content.Parse("opponent.fleet"

                item["mod_shield", oRs[14]
                item["mod_handling", oRs[15]
                item["mod_tracking_speed", oRs[16]
                item["mod_damage", oRs[17]

                if not showEnemyDetails and oRs[9] < rFriend:
                    item["mod_shield", "?"
                    item["mod_handling", "?"
                    item["mod_tracking_speed", "?"
                    item["mod_damage", "?"

                lastFleet = fleet
                lastFleetName = fleetName

                fleet_ships = 0
                fleet_lost = 0
                fleet_killed = 0

            # finish an opponent
            if player != lastPlayer:
                if (lastTag):
                    item["alliancetag", lastTag
                    content.Parse("opponent.alliance"

                item["opponent", lastPlayer
                item["ships", player_ships
                item["lost", player_lost
                item["killed", player_killed
                item["after", player_ships - player_lost

                if lastPlayerColorRelation == rSelf:
                    Content.Parse "opponent.self"
                elif lastPlayerColorRelation == rAlliance:
                    Content.Parse "opponent.ally"
                elif lastPlayerColorRelation == rFriend:
                    Content.Parse "opponent.friend"
                else:
                    Content.Parse "opponent.enemy"

                if lastPlayerWon: content.Parse("opponent.won"

                if lastPlayerAggressive:
                    content.Parse("opponent.attack"
                else:
                    content.Parse("opponent.defend"

                lastPlayerAggressive = False

                item["view", lastPlayerid

                if ispubliclink: content.Parse("opponent.public"

                content.Parse("opponent"

                lastTag = tag
                lastPlayer = player
                lastPlayerid = playerid
                lastPlayerWon = oRs[8]
                lastPlayerColorRelation = oRs[11]
                lastPlayerRelation = oRs[9]

                player_ships = 0
                player_lost = 0
                player_killed = 0

            lastPlayerAggressive = lastPlayerAggressive or oRs[13]

            if showEnemyDetails or lastPlayerRelation >= rFriend:
                # if not a friend and there was no more than a fixed number of rounds, display ships by category and not their name
                if not hasWon and rounds <= 1 and lastPlayerRelation < rFriend:

                    if lastCategory = -1:
                        # entering in a new category
                        lastCategory = category

                        content.Parse("opponent.fleet.ship.category" + lastCategory

                        cat_ships = 0
                        cat_lost = 0
                        cat_killed = 0

                    cat_ships = cat_ships + oRs[5]
                    cat_lost = cat_lost + oRs[6]
                    cat_killed = cat_killed + oRs[7]
                else:
                    item["label", oRs[4]
                    item["ships", oRs[5]
                    item["lost", oRs[6]
                    item["killed", oRs[7]
                    item["after", oRs[5]-oRs[6]

                    killed = 0

                    for i = 0 to killsCount
                        if oRs[12] = killsArray(0, i) and oRs[2] = killsArray(1, i):
                            item["killed_name", getShipLabel(killsArray(2, i))
                            item["killed_count", killsArray(3, i)
                            content.Parse("opponent.fleet.ship.killed"
                            killed = killed + 1 # count how many different ships were destroyed

                    if killed == 0: content.Parse("opponent.fleet.ship.killed_zero"
                    if killed > 1: content.Parse("opponent.fleet.ship.killed_total"

                    content.Parse("opponent.fleet.ship.name"
                    content.Parse("opponent.fleet.ship"

                    lastCategory = -1

                player_ships = player_ships + oRs[5]
                player_lost = player_lost + oRs[6]
                player_killed = player_killed + oRs[7]

                fleet_ships = fleet_ships + oRs[5]
                fleet_lost = fleet_lost + oRs[6]
                fleet_killed = fleet_killed + oRs[7]

        if lastCategory > -1:
            item["ships", cat_ships
            item["lost", cat_lost
            item["killed", cat_killed
            item["after", cat_ships - cat_lost

            content.Parse("opponent.fleet.ship"

        item["fleet", lastFleetName
        item["ships", fleet_ships
        item["lost", fleet_lost
        item["killed", fleet_killed
        item["after", fleet_ships - fleet_lost

        if lastPlayerColorRelation
        == rSelf:
            Content.Parse "opponent.self"
            Content.Parse "opponent.fleet.self"
        == rAlliance:
            Content.Parse "opponent.ally"
            Content.Parse "opponent.fleet.ally"
        == rFriend:
            Content.Parse "opponent.friend"
            Content.Parse "opponent.fleet.friend"
        else:
            Content.Parse "opponent.enemy"
            Content.Parse "opponent.fleet.enemy"

        content.Parse("opponent.fleet"

        if (lastTag):
            item["alliancetag", lastTag
            content.Parse("opponent.alliance"

        item["opponent", lastPlayer
        item["ships", player_ships
        item["lost", player_lost
        item["killed", player_killed
        item["after", player_ships - player_lost

        if lastPlayerWon: content.Parse("opponent.won"

        if lastPlayerAggressive:
            content.Parse("opponent.attack"
        else:
            content.Parse("opponent.defend"

        item["view", lastPlayerid

        if ispubliclink: content.Parse("opponent.public"

        content.Parse("opponent"

    FormatBattle = content

