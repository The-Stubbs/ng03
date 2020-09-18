# -*- coding: utf-8 -*-

from game.views._base import *

#-------------------------------------------------------------------------------
class View(BaseView):

    def dispatch(self, request, *args, **kwargs):

        response = super().pre_dispatch(request, *args, **kwargs)
        if response: return response

        self.selected_menu = "ranking"

        return self.DisplayRankingAlliances(request.GET.get("tag"), request.GET.get("name"))

    def DisplayRankingAlliances(self, search_tag, search_name):
        content = self.loadTemplate("ranking-gm_alliances")

        #
        # search by parameter
        #
        searchby = ""

        #
        # ordering column
        #
        col = ToInt(self.request.GET.get("col"), 1)
        if col < 1 or col > 7: col = 1

        # hide scores
        if col == 2 or col == 5: col = 1
        
        reversed = False
        if col == 1:
            orderby = "upper(gm_alliances.name)"
        elif col == 3:
            orderby = "members"
            reversed = True
        elif col == 4:
            orderby = "planets"
            reversed = True
        elif col == 6:
            orderby = "created"
        elif col == 7:
            orderby = "upper(gm_alliances.tag)"

        if self.request.GET.get("r", "") != "":
            reversed = not reversed
        else:
            content.Parse("r" + str(col))

        if reversed: orderby = orderby + " DESC"
        orderby = orderby + ", upper(gm_alliances.name)"

        content.AssignValue("sort_column", col)

        #
        # start offset
        #

        #offset = request.GET.get("start")
        offset = ToInt(self.request.GET.get("start"), -1)

        if offset < 0: offset = 0

        displayed = 25 # number of nations on each page

        # retrieve number of gm_alliances
        query = "SELECT count(DISTINCT alliance_id) FROM gm_profiles INNER JOIN gm_alliances ON gm_alliances.id=alliance_id WHERE gm_alliances.visible"+searchby
        row = dbRow(query)
        size = int(row[0])

        nb_pages = int(size/displayed)
        if nb_pages*displayed < size: nb_pages = nb_pages + 1
        if offset >= nb_pages: offset = nb_pages-1
        if offset < 0: offset = 0

        query = "SELECT gm_alliances.id, gm_alliances.tag, gm_alliances.name, gm_alliances.score, count(*) AS members, sum(planets) AS planets," + \
                " int4(gm_alliances.score / count(*)) AS score_average, gm_alliances.score-gm_alliances.previous_score as score_delta," + \
                " created, EXISTS(SELECT 1 FROM gm_alliance_naps WHERE allianceid1=gm_alliances.id AND allianceid2=" + str(sqlValue(self.allianceId)) + ")," + \
                " max_members, EXISTS(SELECT 1 FROM gm_alliance_wars WHERE (allianceid1=gm_alliances.id AND allianceid2=" + str(sqlValue(self.allianceId)) + ") OR (allianceid1=" + str(sqlValue(self.allianceId)) + " AND allianceid2=gm_alliances.id))" + \
                " FROM gm_profiles INNER JOIN gm_alliances ON gm_alliances.id=alliance_id" + \
                " WHERE gm_alliances.visible"+searchby + \
                " GROUP BY gm_alliances.id, gm_alliances.name, gm_alliances.tag, gm_alliances.score, gm_alliances.previous_score, gm_alliances.created, gm_alliances.max_members" + \
                " ORDER BY "+orderby+ \
                " OFFSET "+str(offset*displayed)+" LIMIT "+str(displayed)
        oRss = dbRows(query)

        if row == None: content.Parse("noresult")

        content.AssignValue("page_displayed", offset+1)
        content.AssignValue("page_first", offset*displayed+1)
        content.AssignValue("page_last", min(size, (offset+1)*displayed))

        idx_from = offset+1 - 10
        if idx_from < 1: idx_from = 1

        idx_to = offset+1 + 10
        if idx_to > nb_pages: idx_to = nb_pages

        list = []
        content.AssignValue("ps", list)
        for i in range(1, nb_pages+1):
            if (i==1) or (i >= idx_from and i <= idx_to) or (i % 10 == 0):
                item = {}
                list.append(item)
                
                item["page_id"] = i
                item["page_link"] = i-1
    
                if i-1 != offset:
                    if searchby != "": item["search_params"] = True
                    if request.GET.get("r") != "": item["reversed"] = True
    
                    item["link"] = True
                else:
                    item["selected"] = True

        #display only if there are more than 1 page
        if nb_pages > 1: content.Parse("nav")

        i = 1
        list = []
        content.AssignValue("gm_alliances", list)
        for row in oRss:
            item = {}
            list.append(item)
            
            item["place"] = offset*displayed+i
            item["tag"] = row[1]
            item["name"] = row[2]
            item["score"] = row[3]
            item["score_average"] = row[6]
            item["score_delta"] = row[7]
            item["members"] = row[4]
            item["stat_colonies"] = row[5]
            item["created"] = row[8]
            item["max_members"] = row[10]

            if row[6] > 0: item["plus"] = True
            if row[6] < 0: item["minus"] = True

            if self.allianceId and row[0] == self.allianceId: item["playeralliance"] = True
            if row[9]:
                item["nap"] = True
            elif row[11]:
                item["war"] = True

            i = i + 1

        return self.display(content)
