# -*- coding: utf-8 -*-

from web_game.game._global import *

class View(GlobalView):

    def dispatch(self, request, *args, **kwargs):

        response = super().pre_dispatch(request, *args, **kwargs)
        if response: return response

        self.selected_menu = ""

        if self.request.session.get("privilege") < 100:
            return HttpResponseRedirect("/")

        cat = ToInt(request.GET.get("cat"), 0)

        if cat < 0 or cat > 3: cat = 0

        set content = GetTemplate(self.request, "dev-stats")

        content.Parse("tabnav."+cat+".selected"
        content.Parse("tabnav.0"
        content.Parse("tabnav.1"
        content.Parse("tabnav.2"
        content.Parse("tabnav.3"
        content.Parse("tabnav"

        if cat == 0:
            display_galaxies content
        elif cat == 1:
            display_stats content
        elif cat == 2:
            display_alliances_production content
        elif cat == 3:
            display_server_stats content

        return self.Display(content)

    def query(self, aQuery):

        oRs = oConnExecute(aQuery)
        query = oRs[0]

    def display_galaxies(self, content):

        query = "SELECT id, colonies, planets, float4(100.0*colonies / planets)," + \
                " visible, allow_new_players, (SELECT count(*) FROM nav_planet WHERE galaxy=nav_galaxies.id AND warp_to IS NOT None)" + \
                " FROM nav_galaxies" + \
                " ORDER BY id"
        oRss = oConnExecuteAll(query)

        list = []
        for oRs in oRss:
            item = {}
            list.append(item)
            
            item["galaxy", oRs[0]
            item["colonies", oRs[1]
            item["planets", oRs[2]
            item["colonies_pct", oRs[3]

            if oRs[4]:
                content.Parse("galaxies.galaxy.visible"
            else:
                content.Parse("galaxies.galaxy.invisible"

            if oRs[5]:
                content.Parse("galaxies.galaxy.allow_new_players"
            else:
                content.Parse("galaxies.galaxy.deny_new_players"

            item["vortex", oRs[6]

            content.Parse("galaxies.galaxy"

        content.Parse("galaxies"

    # display statistics
    def display_stats(self, content):

        players = int(query("SELECT count(*) FROM users WHERE privilege=0 AND credits_bankruptcy > 0"))
        content.AssignValue("players", players
        content.AssignValue("recent_players", query("SELECT count(*) FROM users WHERE lastlogin > now()-INTERVAL '2 day'")

        colonies = int(query("SELECT count(*) FROM nav_planet WHERE ownerid IS NOT None"))
        planets = int(query("SELECT count(*) FROM nav_planet"))

        content.AssignValue("colonies", colonies
        content.AssignValue("planets", planets
        content.AssignValue("colonized", 100.0*colonies / planets

        content.AssignValue("colonies_per_player", 1.0*colonies / players

        oRs = oConnExecute("SELECT login, planets FROM users WHERE id > 100 ORDER BY planets DESC LIMIT 1")
        content.AssignValue("max_colonies_playername", oRs[0]
        content.AssignValue("max_colonies", oRs[1]

        buildings = int(query("SELECT sum(quantity) FROM planet_buildings"))
        content.AssignValue("buildings", buildings
        content.AssignValue("buildings_average", 1.0*buildings / colonies

        buildings_pending = int(query("SELECT count(*) FROM planet_buildings_pending"))
        content.AssignValue("buildings_pending", buildings_pending
        content.AssignValue("buildings_pending_average", 1.0*buildings_pending / colonies

        oRs = oConnExecute("SELECT sum(scientists), sum(soldiers), sum(workers) FROM vw_planets WHERE ownerid IS NOT None")
        oRs = oConnExecute("SELECT "+oRs[0]+"+sum(cargo_scientists), "+oRs[1]+"+sum(cargo_soldiers), "+oRs[2]+"+sum(cargo_workers) FROM fleets WHERE ownerid IS NOT None")

        content.AssignValue("scientists", oRs[0]
        content.AssignValue("soldiers", oRs[1]
        content.AssignValue("workers", oRs[2]

        fleets = int(query("SELECT count(*) FROM fleets WHERE ownerid > 100"))
        ships = int(query("SELECT sum(quantity) FROM fleets JOIN fleets_ships ON (fleets.id=fleets_ships.fleetid) WHERE fleets.ownerid > 100"))

        content.AssignValue("fleets", fleets
        content.AssignValue("ships", ships
        content.AssignValue("ships_signature", int(query("SELECT sum(signature) FROM fleets WHERE fleets.ownerid > 100"))

        content.AssignValue("ships_average", 1.0*ships/fleets

        ships_not_in_fleet = int(query("SELECT sum(quantity) FROM planet_ships"))

        content.AssignValue("ships_not_in_fleet", ships_not_in_fleet
        content.AssignValue("ships_not_in_fleet_signature", int(query("SELECT sum(signature*quantity) FROM planet_ships INNER JOIN db_ships ON (db_ships.id=planet_ships.shipid)"))
        content.AssignValue("ships_not_in_fleet_percent", 1.0*(ships_not_in_fleet) / (ships_not_in_fleet+ships) * 100

        content.AssignValue("fleets_patrolling", int(query("SELECT count(*) FROM fleets WHERE action=0 AND ownerid > 100"))
        content.AssignValue("fleets_moving", int(query("SELECT count(*) FROM fleets WHERE action=1 or action=-1 AND ownerid > 100"))
        content.AssignValue("fleets_recycling", int(query("SELECT count(*) FROM fleets WHERE action=2 AND ownerid > 100"))

        content.AssignValue("battles", int(query("SELECT count(*) FROM battles WHERE time > now()-INTERVAL '1 days'"))
        content.AssignValue("invasions", int(query("SELECT count(*) FROM invasions WHERE time > now()-INTERVAL '1 days'"))
        content.AssignValue("alerts", int(query("SELECT count(*) FROM reports WHERE type=7 AND datetime > now()-INTERVAL '1 days'"))

        content.AssignValue("displayed_ads", query("SELECT sum(displays_ads) FROM users WHERE privilege=0 AND credits_bankruptcy > 0")
        content.AssignValue("displayed_pages", query("SELECT sum(displays_pages) FROM users WHERE privilege=0 AND credits_bankruptcy > 0")
        content.AssignValue("ads_pct", query("SELECT float4(1.0*sum(displays_ads)/sum(displays_pages)*100) FROM users WHERE privilege=0 AND credits_bankruptcy > 0")

        content.AssignValue("players_blocking_ads", query("SELECT count(1) FROM users WHERE privilege=0  AND credits_bankruptcy > 0 AND displays_ads < 0.9*displays_pages")
        content.AssignValue("players_blocking_ads_pct", query("SELECT float4(100.0*count(1)/" + players +") FROM users WHERE privilege=0  AND credits_bankruptcy > 0 AND displays_ads < 0.9*displays_pages")

        content.Parse("general"

    def display_alliances_production(self, content):

        query = "SELECT alliances.tag, alliances.name," + \
                " sum(ore_production), float4(100.0*sum(ore_production)/(select sum(ore_production) from nav_planet where ownerid > 100))," + \
                " sum(hydrocarbon_production), float4(100.0*sum(hydrocarbon_production)/(select sum(hydrocarbon_production) from nav_planet where ownerid > 100))" + \
                " FROM nav_planet" + \
                "    INNER JOIN users on nav_planet.ownerid=users.id" + \
                "    LEFT JOIN alliances on users.alliance_id=alliances.id" + \
                " GROUP BY users.alliance_id, alliances.tag, alliances.name" + \
                " ORDER BY sum(ore_production) DESC"
        oRss = oConnExecuteAll(query)

        list = []
        for oRs in oRss:
            item = {}
            list.append(item)
            
            item["tag", oRs[0]
            item["name", oRs[1]

            item["ore", oRs[2]
            item["ore_pct", oRs[3]    # total univers production

            item["hydrocarbon", oRs[4] # total univers production
            item["hydrocarbon_pct", oRs[5] # total univers production

            content.Parse("alliances_production.alliance"

        content.Parse("alliances_production"

    def display_server_stats(self, content):

        content.AssignValue("db_buildings", Application("db_buildings.retrieved")
        content.AssignValue("db_buildings_lastupdate", Application("db_buildings.last_retrieve")

        content.AssignValue("db_buildings_req", Application("db_buildings_req.retrieved")
        content.AssignValue("db_buildings_req_lastupdate", Application("db_buildings_req.last_retrieve")

        content.AssignValue("db_ships", Application("db_ships.retrieved")
        content.AssignValue("db_ships_lastupdate", Application("db_ships.last_retrieve")

        content.AssignValue("db_ships_req", Application("db_ships_req.retrieved")
        content.AssignValue("db_ships_req_lastupdate", Application("db_ships_req.last_retrieve")

        content.AssignValue("db_research", Application("db_research.retrieved")
        content.AssignValue("db_research_lastupdate", Application("db_research.last_retrieve")

        query = "SELECT category, procedure, enabled, last_runtime, last_result, average_executiontime, last_runtime+run_every+INTERVAL '1 minute# <= now()" + \
                " FROM sys_executions"
        oRss = oConnExecuteAll(query)

        list = []
        for oRs in oRss:
            item = {}
            list.append(item)
            
            item["category", oRs[0]
            item["procedure", oRs[1]
            if not oRs[2]: content.Parse("server.procedure.disabled"
            item["last_runtime", oRs[3]
            item["last_result", oRs[4]
            item["average_executetime", oRs[5]

            if oRs[6]: content.Parse("server.procedure.error"

            content.Parse("server.procedure"

        content.Parse("server"

