# -*- coding: utf-8 -*-

from game.views._base import *

#-------------------------------------------------------------------------------
class View(BaseView):

    success_url = "/game/alliance-wars/"
    template_name = "alliance-wars"
    selected_menu = "alliance.wars"

    #---------------------------------------------------------------------------
    def dispatch(self, request, *args, **kwargs):

        response = super().pre_dispatch(request, *args, **kwargs)
        if response: return response

        if self.allianceId == None: return HttpResponseRedirect("/game/alliance/")
        
        return super().dispatch(request, *args, **kwargs)

    #---------------------------------------------------------------------------
    def processAction(self, request, action):

        if not self.hasRight("can_create_nap") and not self.hasRight("can_break_nap"): return -1
        
        if action == "pay":
        
            tag = request.POST.get("tag","").strip()
            
            row = dbRow("SELECT user_alliance_war_extend(" + str(self.userId) + "," + sqlStr(tag) + ")")
            return row[0]

        elif action == "stop":
        
            tag = request.POST.get("tag","").strip()
            
            row = dbRow("SELECT user_alliance_war_stop(" + str(self.userId) + "," + sqlStr(tag) + ")")
            return row[0]

        elif action == "create":
        
            tag = request.POST.get("tag","").strip()

            row = dbRow("SELECT user_alliance_war_create(" + str(self.userId) + "," + sqlStr(tag) + ")")                
            return row[0]
    
    #---------------------------------------------------------------------------
    def fillContent(self, request, data):
    
        # --- user right
        
        if self.hasRight("can_create_nap") or self.hasRight("can_break_nap"): data["can_manage"] = True

        # --- column sorting

        col = ToInt(request.GET.get("col"), 1)
        if col < 1 or col > 2: col = 1

        reversed = False
        if col == 1:
            orderby = "tag"
        elif col == 2:
            orderby = "created"
            reversed = True

        if request.GET.get("r","") != "":
            reversed = not reversed

        if reversed: orderby = orderby + " DESC"
        orderby = orderby + ", tag"
        
        data["col"] = col
        data["reversed"] = reversed

        # --- wars data
        
        data["wars"] = []
        
        query = "SELECT w.created, gm_alliances.id, gm_alliances.tag, gm_alliances.name, cease_fire_requested, date_part('epoch', cease_fire_expire-now())::integer, w.can_fight < now() AS can_fight, True AS attacker, next_bill < now() + INTERVAL '1 week', internal_alliance_get_war_cost(allianceid2), next_bill" + \
                " FROM gm_alliance_wars w" + \
                "    INNER JOIN gm_alliances ON (allianceid2 = gm_alliances.id)" + \
                " WHERE allianceid1=" + str(self.allianceId) + \
                " UNION " + \
                "SELECT w.created, gm_alliances.id, gm_alliances.tag, gm_alliances.name, cease_fire_requested, date_part('epoch', cease_fire_expire-now())::integer, w.can_fight < now() AS can_fight, False AS attacker, False, 0, next_bill" + \
                " FROM gm_alliance_wars w" + \
                "    INNER JOIN gm_alliances ON (allianceid1 = gm_alliances.id)" + \
                " WHERE allianceid2=" + str(self.allianceId) + \
                " ORDER BY " + orderby
        rows = dbRows(query)
        if rows:
            for row in rows:
            
                war = {}
                data["wars"].append(war)
                
                war["created"] = row[0]
                war["tag"] = row[2]
                war["name"] = row[3]
                
                if self.hasRight["can_break_nap"]:
                
                    if row[4] == None:
                        if row[7]:
                            if row[8]:
                                war["cost"] = row[9]
                                war["extend"] = True
                            war["stop"] = True

                    elif row[4] == self.allianceId:
                        war["time"] = row[5]
                        war["ceasing"] = True
                        
                    else:
                        war["time"] = row[5]
                        war["cease_requested"] = True

                if row[6]:
                    war["next_bill"] = row[10]
                    if row[10]: war["can_fight"] = True

        # --- war declaration data
        
        if request.GET.get("a","") == "new":

            tag = request.GET.get("tag","").strip()

            row = dbRow("SELECT id, tag, name, internal_alliance_get_war_cost(id) + (static_alliance_war_cost_coeff()*internal_alliance_get_value(" + str(self.allianceId) + "))::integer FROM gm_alliances WHERE lower(tag)=lower(" + sqlStr(self.tag) + ")")
            if row == None:
                data["tag"] = tag
                data["newwar"] = True
                data["unknown"] = True
                
            else:
                data["tag"] = row[1]
                data["name"] = row[2]
                data["cost"] = row[3]
                data["confirmwar"] = True

        else: data["newwar"] = True

        # --- form data
        
        if not data["tag"]: data["tag"] = request.POST.get("tag","").strip()
