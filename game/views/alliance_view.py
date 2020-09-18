# -*- coding: utf-8 -*-

from game.views._base import *

#-------------------------------------------------------------------------------
class View(BaseView):

    template_name = "alliance-view"
    selected_menu = "alliance.view"

    #---------------------------------------------------------------------------
    def dispatch(self, request, *args, **kwargs):

        response = super().pre_dispatch(request, *args, **kwargs)
        if response: return response

        self.tag = request.GET.get("tag", "")
        if self.tag == "" and self.allianceId == None:
            return HttpResponseRedirect("/game/alliance-invitations/")
        elif self.tag == "" and self.allianceId:
            self.tag == None
        
        return super().dispatch(request, *args, **kwargs)

    #---------------------------------------------------------------------------
    def fillContent(self, request, data):
    
        # --- alliance data

        alliance = {}
        content.AssignValue("alliance", alliance)
        
        query = "SELECT id, name, tag, description, created, (SELECT count(*) FROM gm_profiles WHERE alliance_id=gm_alliances.id)," + \
                " logo_url, website_url, max_members" + \
                " FROM gm_alliances"
        if tag == None:
            query = query + " WHERE id=" + str(self.allianceId) + " LIMIT 1"
            self.selected_menu = "alliance.overview"
        else:
            query = query + " WHERE tag=upper(" + sqlStr(self.tag) + ") LIMIT 1"
            self.selected_menu = "ranking"
        row = dbRow(query)

        alliance_id = row[0]
        
        alliance["tag"] = row[2]
        alliance["name"] = row[1]
        alliance["logo"] = row[6]
        alliance["created"] = row[4]
        alliance["description"] = row[3]
        alliance["cur_members"] = row[5]
        alliance["max_members"] = row[8]

        # --- alliance displayed ranks and members

        data["ranks"] = []
        
        query = "SELECT rankid, label" + \
                " FROM gm_alliance_ranks" + \
                " WHERE members_displayed AND allianceid=" + str(alliance_id) + \
                " ORDER BY rankid"
        oRss = dbRows(query)
        if oRss:
            for row in oRss:

                query = "SELECT login" + \
                        " FROM gm_profiles" + \
                        " WHERE alliance_id=" + str(alliance_id) + " AND alliance_rank = " + str(row[0]) + \
                        " ORDER BY upper(login)"
                oRss2 = dbRows(query)
                if oRss2:

                    rank = { "name":row[1], "members":[] }
                    data["ranks"].append(rank)
                    
                    for oRs2 in oRss2:
                        
                        member = { "name":oRs2[0] }
                        rank["members"].append(member)

        # --- alliance naps

        data["naps"] = []

        query = "SELECT allianceid1, tag, name" + \
                " FROM gm_alliance_naps INNER JOIN gm_alliances ON (gm_alliance_naps.allianceid1=gm_alliances.id)" + \
                " WHERE allianceid2=" + str(alliance_id)
        oRss = dbRows(query)
        if oRss:
            for row in oRss:

                nap = {}
                data["naps"].append(nap)
                
                nap["tag"] = row[1]
                nap["name"] = row[2]

        # --- alliance wars

        data["wars"] = []

        query = "SELECT w.created, gm_alliances.id, gm_alliances.tag, gm_alliances.name" + \
                " FROM gm_alliance_wars w" + \
                "    INNER JOIN gm_alliances ON (allianceid2 = gm_alliances.id)" + \
                " WHERE allianceid1=" + str(alliance_id) + \
                " UNION " + \
                "SELECT w.created, gm_alliances.id, gm_alliances.tag, gm_alliances.name" + \
                " FROM gm_alliance_wars w" + \
                "    INNER JOIN gm_alliances ON (allianceid1 = gm_alliances.id)" + \
                " WHERE allianceid2=" + str(alliance_id)
        oRss = dbRows(query)
        if oRss:
            for row in oRss:

                war = {}
                data["wars"].append(war)
                
                war["tag"] = row[2]
                war["name"] = row[3]
