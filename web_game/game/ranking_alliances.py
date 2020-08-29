# -*- coding: utf-8 -*-

from web_game.game._global import *

class View(GlobalView):

    def dispatch(self, request, *args, **kwargs):

        response = super().pre_dispatch(request, *args, **kwargs)
        if response: return response

        self.selected_menu = "ranking"

        return self.DisplayRankingAlliances(request.GET.get("tag"), request.GET.get("name"))

    def DisplayRankingAlliances(self, search_tag, search_name):
        content = GetTemplate(self.request, "ranking-alliances")

        #
        # search by parameter
        #
        searchby = request.GET.get("a")
        if searchby != "":
            # if the page is a search result, add the search params to ordering column links
            item["param_a", searchby
            content.Parse("search_params"

            searchby = dosql("%"+searchby+"%")
            searchby = " AND alliance_id IN (SELECT id FROM alliances WHERE upper(alliances.name) LIKE upper("+searchby+") OR upper(alliances.tag) LIKE upper("+searchby+"))"
        else:
            searchby = ""

        #
        # ordering column
        #
        col = ToInt(request.GET.get("col"), 1)
        if col < 1 or col > 7: col = 1

        # hide scores
        if col = 2 or col = 5: col = 1

        if col == 1:
            orderby = "upper(alliances.name)"
        elif col == 3:
            orderby = "members"
            reversed = True
        elif col == 4:
            orderby = "planets"
            reversed = True
        elif col == 6:
            orderby = "created"
        elif col == 7:
            orderby = "upper(alliances.tag)"

        if request.GET.get("r") != "":
            reversed = not reversed
        else:
            content.Parse("r" + col

        if reversed: orderby = orderby + " DESC"
        orderby = orderby + ", upper(alliances.name)"

        content.AssignValue("sort_column", col

        #
        # start offset
        #

        #offset = request.GET.get("start")
        offset = ToInt(request.GET.get("start"), -1)

        if offset < 0: offset = 0

        displayed = 25 # number of nations on each page

        # retrieve number of alliances
        query = "SELECT count(DISTINCT alliance_id) FROM users INNER JOIN alliances ON alliances.id=alliance_id WHERE alliances.visible"+searchby
        oRs = oConnExecute(query)
        size = int(oRs[0])

        nb_pages = int(size/displayed)
        if nb_pages*displayed < size: nb_pages = nb_pages + 1
        if offset >= nb_pages: offset = nb_pages-1
        if offset < 0: offset = 0

        query = "SELECT alliances.id, alliances.tag, alliances.name, alliances.score, count(*) AS members, sum(planets) AS planets," + \
                " int4(alliances.score / count(*)) AS score_average, alliances.score-alliances.previous_score as score_delta," + \
                " created, EXISTS(SELECT 1 FROM alliances_naps WHERE allianceid1=alliances.id AND allianceid2=" + sqlValue(self.AllianceId) + ")," + \
                " max_members, EXISTS(SELECT 1 FROM alliances_wars WHERE (allianceid1=alliances.id AND allianceid2=" + sqlValue(self.AllianceId) + ") OR (allianceid1=" + sqlValue(self.AllianceId) + " AND allianceid2=alliances.id))" + \
                " FROM users INNER JOIN alliances ON alliances.id=alliance_id" + \
                " WHERE alliances.visible"+searchby + \
                " GROUP BY alliances.id, alliances.name, alliances.tag, alliances.score, alliances.previous_score, alliances.created, alliances.max_members" + \
                " ORDER BY "+orderby+ \
                " OFFSET "+(offset*displayed)+" LIMIT "+displayed
        oRss = oConnExecuteAll(query)

        if oRs == None: content.Parse("noresult"

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

        i = 1
        list = []
        for oRs in oRss:
            item = {}
            list.append(item)
            
            item["place", offset*displayed+i
            item["tag", oRs[1]
            item["name", oRs[2]
            item["score", oRs[3]
            item["score_average", oRs[6]
            item["score_delta", oRs[7]
            item["members", oRs[4]
            item["stat_colonies", oRs[5]
            item["created", oRs[8]
            item["max_members", oRs[10]

            if oRs[6] > 0: content.Parse("alliance.plus"
            if oRs[6] < 0: content.Parse("alliance.minus"

            if oRs[0] = self.AllianceId: content.Parse("alliance.playeralliance"
            if oRs[9]:
                content.Parse("alliance.nap"
            elif oRs[11]:
                content.Parse("alliance.war"

            content.Parse("alliance"

            i = i + 1

        return self.Display(content)

