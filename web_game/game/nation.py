# -*- coding: utf-8 -*-

from web_game.game._global import *

class View(GlobalView):

    def dispatch(self, request, *args, **kwargs):

        response = super().pre_dispatch(request, *args, **kwargs)
        if response: return response

        from web_game.lib.accounts import *

        self.selected_menu = "nation"

        return self.display_nation()

    def display_nation_search(self, nation):

        content = GetTemplate(self.request, "nation-search")

        query = "SELECT login" + \
                " FROM users" + \
                " WHERE upper(login) ILIKE upper(" + dosql( "%" + nation + "%") + ")" + \
                " ORDER BY upper(login)"
        oRss = oConnExecuteAll(query)

        list = []
        for oRs in oRss:
            item = {}
            list.append(item)
            
            item["nation", oRs[0]
            content.Parse("nation"

        return self.Display(content)

    def display_nation(self):

        nation = request.GET.get("name").strip()

        # if no nation is given: display info on the current player
        if nation == "":    nation = self.oPlayerInfo["login")

        content = GetTemplate(self.request, "nation")

        query = "SELECT u.login, u.avatar_url, u.description, sp_relation(u.id, "+str(self.UserId)+"), " + \
                " u.alliance_id, a.tag, a.name, u.id, GREATEST(u.regdate, u.game_started) AS regdate, r.label," + \
                " COALESCE(u.alliance_joined, u.regdate), u.alliance_taxes_paid, u.alliance_credits_given, u.alliance_credits_taken," + \
                " u.id" + \
                " FROM users AS u" + \
                " LEFT JOIN alliances AS a ON (u.alliance_id = a.id) " + \
                " LEFT JOIN alliances_ranks AS r ON (u.alliance_id = r.allianceid AND u.alliance_rank = r.rankid) " + \
                " WHERE upper(u.login) = upper(" + dosql(nation) + ") LIMIT 1"
        oRs = oConnExecute(query)

        if oRs == None:
            if nation != "":
                display_nation_search(nation)
            else:
                return HttpResponseRedirect("/game/nation/")

        nationId = oRs["id")

        content.AssignValue("name", oRs[0]
        content.AssignValue("regdate", oRs[8]

        content.AssignValue("alliance_joined", oRs[10]

        if oRs[1] == None or oRs[1] == "":
            content.Parse("noavatar"
        else:
            content.AssignValue("avatar_url", oRs[1]
            content.Parse("avatar"

        if oRs[7] != self.UserId: content.Parse("sendmail"

        if oRs[2] and oRs[2] != "":
            content.AssignValue("description", oRs[2]
            content.Parse("description"

        if oRs[3] < rFriend:
            content.Parse("enemy"
        elif oRs[3] = rFriend:
            content.Parse("friend"
        elif oRs[3] > rFriend:  # display planets + fleets of alliance members if has the rights for it

            if oRs[3] = rAlliance:
                content.Parse("ally"
                show_details = self.oAllianceRights["leader"] or self.oAllianceRights["can_see_members_info"]
            else:
                content.Parse("self"
                show_details = True

            if show_details:
                if oRs[3] = rAlliance:
                    if not self.oAllianceRights["leader"]:
                        show_details = False

                if show_details:'oRs[3] = rSelf or self.oAllianceRights["leader"] ):
                    # view current nation planets
                    query = "SELECT name, galaxy, sector, planet FROM vw_planets WHERE ownerid=" + oRs[7]

                    query = query + " ORDER BY id"
                oPlanetsRs = oConnExecute(query)

                    if oPlanetsRs.EOF:
                        content.Parse("allied.noplanets"

                    while not oPlanetsRs.EOF
                        content.AssignValue("planetname", oPlanetsRs(0)
                        content.AssignValue("g", oPlanetsRs(1)
                        content.AssignValue("s", oPlanetsRs(2)
                        content.AssignValue("p", oPlanetsRs(3)
                        content.Parse("allied.planet"
                        oPlanetsRs.MoveNext

                # view current nation fleets

                query = "SELECT id, name, attackonsight, engaged, remaining_time, " + \
                    " planetid, planet_name, planet_galaxy, planet_sector, planet_planet, planet_ownerid, planet_owner_name, sp_relation(planet_ownerid, ownerid)," + \
                    " destplanetid, destplanet_name, destplanet_galaxy, destplanet_sector, destplanet_planet, destplanet_ownerid, destplanet_owner_name, sp_relation(destplanet_ownerid, ownerid)," + \
                    " action, signature, sp_get_user_rs(ownerid, planet_galaxy, planet_sector), sp_get_user_rs(ownerid, destplanet_galaxy, destplanet_sector)" + \
                    " FROM vw_fleets WHERE ownerid=" + oRs[7]

                if oRs[3] = rAlliance:
                    if not self.oAllianceRights["leader"]:
                        query = query + " AND action != 0"

                query = query + " ORDER BY planetid, upper(name)"

                oFleetsRs = oConnExecute(query)

                if oFleetsRs.EOF: content.Parse("allied.nofleets"

                while not oFleetsRs.EOF
                    content.AssignValue("fleetid", oFleetsRs(0)
                    content.AssignValue("fleetname", oFleetsRs(1)
                    content.AssignValue("planetid", oFleetsRs(5)
                    content.AssignValue("signature", oFleetsRs(22)
                    content.AssignValue("g", oFleetsRs(7)
                    content.AssignValue("s", oFleetsRs(8)
                    content.AssignValue("p", oFleetsRs(9)
                    if oFleetsRs(4):
                        content.AssignValue("time", oFleetsRs(4)
                    else:
                        content.AssignValue("time", 0

                    content.AssignValue("relation", oFleetsRs(12)
                    content.AssignValue("planetname", self.getPlanetName(oFleetsRs(12), oFleetsRs(23), oFleetsRs(11), oFleetsRs(6))

                    if oRs[3] = rAlliance:
                        content.Parse("allied.fleet.ally"
                    else:
                        content.Parse("allied.fleet.owned"

                    if oFleetsRs(3):
                        content.Parse("allied.fleet.fighting"
                    elif oFleetsRs(21)=2:
                        content.Parse("allied.fleet.recycling"
                    elif oFleetsRs(13):
                        # Assign destination planet
                        content.AssignValue("t_planetid", oFleetsRs(13)
                        content.AssignValue("t_g", oFleetsRs(15)
                        content.AssignValue("t_s", oFleetsRs(16)
                        content.AssignValue("t_p", oFleetsRs(17)
                        content.AssignValue("t_relation", oFleetsRs(20)
                        content.AssignValue("t_planetname", self.getPlanetName(oFleetsRs(20), oFleetsRs(24), oFleetsRs(19), oFleetsRs(14))

                        content.Parse("allied.fleet.moving"
                    else:
                        content.Parse("allied.fleet.patrolling"

                    content.Parse("allied.fleet"
                    oFleetsRs.MoveNext

                content.Parse("allied"

        if oRs[4] == None:
            content.AssignValue("alliancename", oRs[6]
            content.AssignValue("alliancetag", oRs[5]
            content.AssignValue("rank_label", oRs[9]

            if oRs[3] == rSelf:
                content.Parse("alliance.self"
            elif oRs[3] == rAlliance:
                content.Parse("alliance.ally"
            elif oRs[3] == rFriend:
                content.Parse("alliance.friend"
            else:
                content.Parse("alliance.enemy"

            content.Parse("alliance"
        else:
            content.Parse("noalliance"

        query = "SELECT alliance_tag, alliance_name, joined, ""left""" + \
                " FROM users_alliance_history" + \
                " WHERE userid = " + dosql(nationId) + " AND joined > (SELECT GREATEST(regdate, game_started) FROM users WHERE privilege < 100 AND id=" + dosql(nationId) + ")" + \
                " ORDER BY joined DESC"
        oRss = oConnExecuteAll(query)

        list = []
        for oRs in oRss:
            item = {}
            list.append(item)
            
            item["history_tag", oRs[0].value
            item["history_name", oRs[1].value
            item["joined", oRs[2].value
            item["left", oRs[3].value
            content.Parse("alliances.item"

        content.Parse("alliances"

        return self.Display(content)

