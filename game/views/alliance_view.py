# -*- coding: utf-8 -*-

from game.views._base import *

class View(BaseView):

    def dispatch(self, request, *args, **kwargs):

        response = super().pre_dispatch(request, *args, **kwargs)
        if response: return response

        tag = request.GET.get("tag", "")
        if tag == "" and self.allianceId == None:
            return HttpResponseRedirect("/game/alliance-invitations/")
        elif tag == "" and self.allianceId:
            tag == None

        content = self.loadTemplate("alliance")

        # --- alliance data

        alliance = {}
        content.AssignValue("alliance", alliance)
        
        query = "SELECT id, name, tag, description, created, (SELECT count(*) FROM gm_profiles WHERE alliance_id=gm_alliances.id)," + \
                " logo_url, website_url, max_members" + \
                " FROM gm_alliances"
        if tag == None:
            query = query + " WHERE id=" + str(self.allianceId) + " LIMIT 1"
            self.selectedMenu = "alliance.overview"
        else:
            query = query + " WHERE tag=upper(" + sqlStr(tag) + ") LIMIT 1"
            self.selectedMenu = "ranking"
        oRs = dbRow(query)

        alliance_id = oRs[0]
        
        alliance["tag"] = oRs[2]
        alliance["name"] = oRs[1]
        alliance["logo"] = oRs[6]
        alliance["created"] = oRs[4]
        alliance["description"] = oRs[3]
        alliance["cur_members"] = oRs[5]
        alliance["max_members"] = oRs[8]

        # --- alliance displayed ranks and members

        ranks = []
        content.AssignValue("ranks", ranks)
        
        query = "SELECT rankid, label" + \
                " FROM gm_alliance_ranks" + \
                " WHERE members_displayed AND allianceid=" + str(alliance_id) + \
                " ORDER BY rankid"
        oRss = dbRows(query)
        
        if oRss:
            for oRs in oRss:

                query = "SELECT login" + \
                        " FROM gm_profiles" + \
                        " WHERE alliance_id=" + str(alliance_id) + " AND alliance_rank = " + str(oRs[0]) + \
                        " ORDER BY upper(login)"
                oRss2 = dbRows(query)
                if oRss2:

                    rank = { "name":oRs[1], "members":[] }
                    ranks.append(rank)
                    
                    for oRs2 in oRss2:
                        
                        member = { "name":oRs2[0] }
                        rank["members"].append(member)

        # --- alliance naps

        naps = []
        content.AssignValue("naps", naps)

        query = "SELECT allianceid1, tag, name" + \
                " FROM gm_alliance_naps INNER JOIN gm_alliances ON (gm_alliance_naps.allianceid1=gm_alliances.id)" + \
                " WHERE allianceid2=" + str(alliance_id)
        oRss = dbRows(query)
        
        if oRss:
            for oRs in oRss:

                nap = {}
                naps.append(nap)
                
                nap["tag"] = oRs[1]
                nap["name"] = oRs[2]

        # --- alliance wars

        wars = []
        content.AssignValue("wars", wars)

        query = "SELECT w.created, gm_alliances.id, gm_alliances.tag, gm_alliances.name"+ \
            " FROM gm_alliance_wars w" + \
            "    INNER JOIN gm_alliances ON (allianceid2 = gm_alliances.id)" + \
            " WHERE allianceid1=" + str(alliance_id) + \
            " UNION " + \
            "SELECT w.created, gm_alliances.id, gm_alliances.tag, gm_alliances.name"+ \
            " FROM gm_alliance_wars w" + \
            "    INNER JOIN gm_alliances ON (allianceid1 = gm_alliances.id)" + \
            " WHERE allianceid2=" + str(alliance_id)
        oRss = dbRows(query)

        if oRss:
            for oRs in oRss:

                war = {}
                wars.append(war)
                
                war["tag"] = oRs[2]
                war["name"] = oRs[3]

        return self.display(content)
