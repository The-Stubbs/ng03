# -*- coding: utf-8 -*-

from game.views._base import *

#-------------------------------------------------------------------------------
class View(BaseView):

    success_url = "/game/alliance-members/"
    template_name = "alliance-members"
    selected_menu = "alliance.members"

    #---------------------------------------------------------------------------
    def dispatch(self, request, *args, **kwargs):

        response = super().pre_dispatch(request, *args, **kwargs)
        if response: return response

        if self.allianceId == None: return HttpResponseRedirect("/game/alliance/")
        if not self.hasRight("can_see_members_info"): return HttpResponseRedirect("/game/alliance/")
        
        return super().dispatch(request, *args, **kwargs)

    #---------------------------------------------------------------------------
    def processAction(self, request, action):
    
        if action == "kick":
        
            if not self.hasRight("can_kick_player"): return -1
            
            name = request.POST.get("name").strip()
            
            row = dbRow("SELECT user_alliance_kick_member(" + str(self.userId) + "," + sqlStr(self.username) + ")")
            return row[0]
            
        elif action == "save":
        
            query = "SELECT id" + \
                    " FROM gm_profiles" + \
                    " WHERE alliance_id=" + str(self.allianceId)
            rows = dbRows(query)
            if rows:
                for row in rows:
                
                    query = " UPDATE gm_profiles SET" + \
                            " alliance_rank=" + str(ToInt(request.POST.get("player" + str(row[0])), 100)) + \
                            " WHERE id=" + str(row) + " AND alliance_id=" + str(self.allianceId) + " AND (alliance_rank > 0 OR id=" + str(self.userId) + ")"
                    dbExecute(query)
                    
            if ToInt(request.POST.get("player" + str(self.userId)), 100) > 0:
                self.success_url = "/game/alliance/"
            
            return 0
 
    #---------------------------------------------------------------------------
    def fillContent(self, request, data):
        
        # --- column sorting
    
        col = ToInt(request.GET.get("col"), 1)
        if col < 1 or col > 7: col = 1

        reversed = False
        if col == 1:
            orderby = "upper(login)"
        elif col == 2:
            orderby = "score"
            reversed = True
        elif col == 3:
            orderby = "colonies"
            reversed = True
        elif col == 4:
            orderby = "credits"
            reversed = True
        elif col == 5:
            orderby = "lastactivity"
            reversed = True
        elif col == 6:
            orderby = "alliance_joined"
            reversed = True
        elif col == 7:
            orderby = "alliance_rank"
            reversed = False

        if request.GET.get("r","") != "":
            reversed = not reversed

        if reversed: orderby = orderby + " DESC"
        orderby = orderby + ", upper(login)"
        
        data["col"] = col
        data["reversed"] = reversed
        
        # --- user rights
        
        if not self.hasRight("can_kick_player"): data["viewonly"] = True
        
        # --- ranks data
        
        data["ranks"] = []
        
        query = "SELECT rankid, label" + \
                " FROM gm_alliance_ranks" + \
                " WHERE enabled AND allianceid=" + str(self.allianceId) + \
                " ORDER BY rankid"
        rows = dbRows(query)
        if rows:
            for row in rows:
            
                rank = {}
                data["ranks"].append(rank)
                
                rank["id"] = row[0]
                rank["name"] = row[1]

        # --- members data
        
        data["members"] = []
        data["total"] = { "planets":0, "credits":0, "score":0, "delta":0 }
        
        query = "SELECT login, CASE WHEN id=" + str(self.userId) + " OR score_visibility >=1 THEN score ELSE 0 END AS score, int4((SELECT count(1) FROM gm_planets WHERE ownerid=gm_profiles.id)) AS colonies," + \
                " date_part('epoch', now()-lastactivity) / 3600, alliance_joined, alliance_rank, privilege, score-previous_score AS score_delta, id," + \
                " 0, credits, score_visibility, orientation, COALESCE(date_part('epoch', leave_alliance_datetime-now()), 0)" + \
                " FROM gm_profiles" + \
                " WHERE alliance_id=" + str(self.allianceId) + \
                " ORDER BY " + orderby
        rows = dbRows(query)
        if rows:
            for row in rows:
            
                data["total"]["planets"] += row[2]
                data["total"]["credits"] += row[10]

                member = {}
                data["members"].append(member)
                
                member["place"] = i
                member["name"] = row[0]
                member["planets"] = row[2]
                member["hours_delay"] = int(row[3])
                member["days_delay"] = int(row[3] / 24)
                member["joined"] = row[4]
                member["rank"] = row[5]
                member["id"] = row[8]
                member["credits"] = row[10]
                member["orientation"] = row[12]
                member["leaving_time"] = row[13]

                if row[11] >= 1 or row[8] == self.userId:
                
                    member["score"] = row[1]
                    member["delta"] = row[7]
                    
                    data["total"]["score"] += row[1]
                    data["total"]["delta"] += row[7]

                if row[6] == -1: member["banned"] = True
                elif row[6] == -2: member["onholidays"] = True
                elif row[3] < 0.25: member["online"] = True
                elif row[3] < 1: member["less1h"] = True
                elif row[3] < 1 * 24: member["hours"] = True
                elif row[3] < 7 * 24: member["days"] = True
                elif row[3] <= 14 * 24: member["1weekplus"] = True
                elif row[3] > 14 * 24: member["2weeksplus"] = True

                if self.allianceRights["leader"] and (row[5] > self.allianceRankId or row[8] == self.userId):
                    member["can_manage"] = True

                if self.hasRight("can_kick_player") and row[13] == 0 and row[5] > self.allianceRankId:
                    member["can_kick"] = True
