# -*- coding: utf-8 -*-

from web_game.game._global import *

class View(GlobalView):

    def dispatch(self, request, *args, **kwargs):

        response = super().pre_dispatch(request, *args, **kwargs)
        if response: return response

        self.selected_menu = "ranking.players"

        return self.DisplayRanking()

    def DisplayRanking(self):
        content = GetTemplate(self.request, "ranking-players")

        #
        # Setup search by Alliance and Nation query string
        #
        if False:
            searchbyA = request.GET.get("a")
            if searchbyA != "":
                content.AssignValue("param_a", searchbyA

                searchbyA = dosql("%"+searchbyA+"%")
                searchbyA = " AND alliance_id IN (SELECT id FROM alliances WHERE upper(alliances.name) LIKE upper("+searchbyA+") OR upper(alliances.tag) LIKE upper("+searchbyA+"))"
            else:
                searchbyA = ""

            searchbyN = ""'request.GET.get("n")
            if searchbyN != "":
                content.AssignValue("param_n", searchbyN

                searchbyN = dosql("%"+searchbyN+"%")
                searchbyN = " AND upper(login) LIKE upper("+searchbyN+") "
            else:
                searchbyN = ""

        searchby = searchbyA + searchbyN

        # if the page is a search result, add the search params to column ordering links
        if searchby != "": content.Parse("search_params"

        #
        # Setup column ordering
        #
        col = ToInt(request.GET.get("col"), 3)
        if col < 1 or col > 4: col = 3

        if col == 1:
            orderby = "== WHEN score_visibility=2 OR v.id="+str(self.UserId)+": upper(login) else: '# END, upper(login)"
        elif col == 2:
            orderby = "upper(alliances.name)"
        elif col == 3:
            orderby = "v.score"
            reversed = True
        elif col == 4:
            orderby = "v.score_prestige"
            reversed = True

        if request.GET.get("r") != "":
            reversed = not reversed
        else:
            content.Parse("r" + col

        if reversed: orderby = orderby + " DESC"
        orderby = orderby + ", upper(login)"

        content.AssignValue("sort_column", col

        #
        # get the score of the tenth user to only show the avatars of the first 10 players
        #
        query = "SELECT score" + \
                " FROM vw_players" + \
                " WHERE True "+searchby + \
                " ORDER BY score DESC OFFSET 9 LIMIT 1"
        oRs = oConnExecute(query)

        if oRs == None:
            TenthUserScore = 0
        else:
            TenthUserScore = oRs[0]

        displayed = 100 # number of nations displayed per page

        #
        # Retrieve the offset from where to begin the display
        #
        offset = ToInt(request.GET.get("start"), -1)

        if offset < 0:
            query = "SELECT v.id" + \
                    " FROM vw_players v LEFT JOIN alliances ON alliances.id=v.alliance_id" + \
                    " WHERE True "+searchby + \
                    " ORDER BY "+orderby
            oRss = oConnExecuteAll(query)

            index = 0
            found = False
            for oRs in oRss:
                if oRs[0] == self.UserId:
                    found = True

                index = index +1

            myOffset = int(index/displayed)
            if not found: myOffset=0
            offset = myOffset

        # get total number of players that could be displayed
        query = "SELECT count(1) FROM vw_players WHERE True "+searchby
        oRs = oConnExecute(query)
        size = int(oRs[0])
        nb_pages = Int(size/displayed)
        if nb_pages*displayed < size: nb_pages = nb_pages + 1
        if offset >= nb_pages: offset = nb_pages-1
        if offset < 0: offset = 0

        content.AssignValue("page_displayed", offset+1
        content.AssignValue("page_first", offset*displayed+1
        content.AssignValue("page_last", min(size, (offset+1)*displayed)

        idx_from = offset+1 - 10
        if idx_from < 1: idx_from = 1

        idx_to = offset+1 + 10
        if idx_to > nb_pages: idx_to = nb_pages

        for i = 1 to nb_pages
            if (i=1) or (i >= idx_from and i <= idx_to) or (i mod 10 = 0):
            content.AssignValue("page_id", i
            content.AssignValue("page_link", i-1

            if i-1 != offset:
                if searchby != "": content.Parse("nav.p.link.search_params"
                if request.GET.get("r") != "": content.Parse("nav.p.link.reversed"

                content.Parse("nav.p.link"
            else:
                content.Parse("nav.p.selected"

            content.Parse("nav.p"

        #display only if there are more than 1 page
        if nb_pages > 1: content.Parse("nav"

        # Retrieve players to display
        query = "SELECT login, v.score, v.score_prestige," + \
                "COALESCE(date_part('day', now()-lastactivity), 15), alliances.name, alliances.tag, v.id, avatar_url, v.alliance_id, v.score-v.previous_score AS score_delta," + \
                "v.score >= " + TenthUserScore + " OR score_visibility = 2 OR (score_visibility = 1 AND alliance_id IS NOT None AND alliance_id="+sqlvalue(self.AllianceId)+") OR v.id="+UserId + \
                " FROM vw_players v" + \
                "    LEFT JOIN alliances ON ((v.score >= " + TenthUserScore + " OR score_visibility = 2 OR v.id="+str(self.UserId)+" OR (score_visibility = 1 AND alliance_id IS NOT None AND alliance_id="+sqlvalue(self.AllianceId)+")) AND alliances.id=v.alliance_id)" + \
                " WHERE True "+searchby + \
                " ORDER BY "+orderby+" OFFSET "+(offset*displayed)+" LIMIT "+displayed
        oRss = oConnExecuteAll(query)

        if oRs == None: content.Parse("noresult"

        i = 1
        list = []
        for oRs in oRss:
            item = {}
            list.append(item)
            
            content.AssignValue("place", offset*displayed+i
            content.AssignValue("name", oRs[0]

            visible = oRs[10] 'or self.request.session.get(sprivilege) > 100# or TenthUserScore <= oRs[1]

            if visible and not isnull(oRs[4]):
                content.AssignValue("alliancename", oRs[4]
                content.AssignValue("alliancetag", oRs[5]
                content.Parse("player.alliance"
            else:
                content.Parse("player.noalliance"

            content.AssignValue("score", oRs[1]
            content.AssignValue("score_battle", oRs[2]
            if visible:
                content.AssignValue("score_delta", oRs[9]
                if oRs[9] > 0: content.Parse("player.plus"
                if oRs[9] < 0: content.Parse("player.minus"
            else:
                content.AssignValue("score_delta", ""

            content.AssignValue("stat_colonies", oRs[2]
            content.AssignValue("last_login", oRs[3]

            if oRs[3] <= 7:
                content.Parse("player.recently"
            elif oRs[3] <= 14:
                content.Parse("player.1weekplus"
            elif oRs[3] > 14:
                content.Parse("player.2weeksplus"

            if visible:
                if oRs[6] = self.UserId:
                    content.Parse("player.self"
                elif oRs[8] = self.AllianceId:
                    content.Parse("player.ally"

                # show avatar only if top 10
                if oRs[1] >= TenthUserScore:
                    if oRs[7] == None or oRs[7] == "":
                        content.Parse("player.top10avatar.noavatar"
                    else:
                        content.AssignValue("avatar_url", oRs[7]
                        content.Parse("player.top10avatar.avatar"

                    content.Parse("player.top10avatar"

                content.Parse("player.name"
            else:
                content.Parse("player.name_na"

            content.Parse("player"

            i = i + 1

        return self.Display(content)

