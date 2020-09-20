# -*- coding: utf-8 -*-

from game.views._base import *

#-------------------------------------------------------------------------------
class View(BaseView):

    success_url = "/game/alliance-gifts/"
    template_name = "alliance-gifts"
    selected_menu = "alliance.gifts"

    #---------------------------------------------------------------------------
    def dispatch(self, request, *args, **kwargs):

        response = super().pre_dispatch(request, *args, **kwargs)
        if response: return response

        if self.allianceId == None: return HttpResponseRedirect("/game/overview/")
            
        return super().dispatch(request, *args, **kwargs)

    #---------------------------------------------------------------------------
    def processAction(self, request, action):
    
        if action == "give":
        
            if not self.canGiveMoney(): return -1
        
            credits = ToInt(request.POST.get("credits"), 0)
            description = self.request.POST.get("description","").strip()
        
            if credits > 0:

                row = dbRow("SELECT user_alliance_give_money(" + str(self.userId) + "," + str(credits) + "," + sqlStr(description) + ",0)")
                return row[0]

    #---------------------------------------------------------------------------
    def fillContent(self, request, data):

        # --- user rights
        
        if self.canGiveMoney():
            data["can_give"] = True

        # --- gifts data
        
        if self.allianceRights["can_accept_money_requests"]:
            
            data["gifts"] = []
            
            query = "SELECT datetime, credits, source, description" + \
                    " FROM gm_alliance_wallet_logs" + \
                    " WHERE allianceid=" + str(self.allianceId) + " AND type=0 AND datetime >= now()-INTERVAL '1 week'" + \
                    " ORDER BY datetime DESC"
            rows = dbRows(query)
            if rows:
                for row in rows:

                    gift = {}
                    data["gifts"].append(gift)
                    
                    gift["date"] = row[0]
                    gift["credits"] = row[1]
                    gift["nation"] = row[2]
                    gift["description"] = row[3]

    #---------------------------------------------------------------------------
    def canGiveMoney(self):
        row = dbRow("SELECT game_started < now() - INTERVAL '2 weeks' FROM gm_profiles WHERE id=" + str(self.userId))
        return row and row[0]
