# -*- coding: utf-8 -*-

from game.views._base import *

#-------------------------------------------------------------------------------
class View(BaseView):

    success_url = "/game/alliance-tributes/"
    template_name = "alliance-tributes"
    selected_menu = "alliance.tributes"

    #---------------------------------------------------------------------------
    def dispatch(self, request, *args, **kwargs):

        response = super().pre_dispatch(request, *args, **kwargs)
        if response: return response

        if self.allianceId == None: return HttpResponseRedirect("/game/alliance/")
        
        return super().dispatch(request, *args, **kwargs)

    #---------------------------------------------------------------------------
    def processAction(self, request, action):

        if not self.hasRight["can_create_nap"] and not self.hasRight["can_break_nap"]: return -1

        if action == "cancel":
        
            tag = request.POST.get("tag","").strip()
            
            row = dbRow("SELECT user_alliance_tribute_cancel(" + str(self.userId) + "," + sqlStr(tag) + ")")
            return row[0]

        elif action == "new":

            tag = request.POST.get("tag","").strip()
            credits = ToInt(request.POST.get("credits"), 0)

            row = dbRow("SELECT user_alliance_tribute_create(" + str(self.userId) + "," + sqlStr(tag) + "," + str(credits) + ")")
            return row[0]

    #---------------------------------------------------------------------------
    def fillContent(self, request, data):
    
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

        # --- user rights
        
        if self.hasRight("can_break_nap"): data["can_cancel"] = True
        if self.hasRight("can_create_nap"): data["can_create"] = True
        
        # --- received tributes data
        
        data["receiveds"] = []
        
        query = "SELECT w.created, gm_alliances.id, gm_alliances.tag, gm_alliances.name, w.credits, w.next_transfer" + \
                " FROM gm_alliance_tributes w" + \
                "    INNER JOIN gm_alliances ON (allianceid = gm_alliances.id)" + \
                " WHERE target_allianceid=" + str(self.allianceId) + \
                " ORDER BY " + orderby
        rows = dbRows(query)
        if rows:
            for row in rows:
            
                tribute = {}
                data["receiveds"].append(tribute)
                
                tribute["created"] = row[0]
                tribute["tag"] = row[2]
                tribute["name"] = row[3]
                tribute["credits"] = row[4]
                tribute["next_transfer"] = row[5]

        # --- sent tributes data
        
        data["sents"] = []
        
        query = "SELECT w.created, gm_alliances.id, gm_alliances.tag, gm_alliances.name, w.credits" + \
                " FROM gm_alliance_tributes w" + \
                "    INNER JOIN gm_alliances ON (target_allianceid = gm_alliances.id)" + \
                " WHERE allianceid=" + str(self.allianceId) + \
                " ORDER BY " + orderby
        rows = dbRows(query)
        if rows:
            for row in rows:
            
                tribute = {}
                data["sents"].append(tribute)
                
                tribute["created"] = row[0]
                tribute["tag"] = row[2]
                tribute["name"] = row[3]
                tribute["credits"] = row[4]

        # --- form data
        
        if self.hasRight("can_create_nap"):

            data["tag"] = request.POST.get("tag","").strip()
            data["credits"] = ToInt(request.POST.get("credits"), 0)
            
            data["new"] = True
