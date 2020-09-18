# -*- coding: utf-8 -*-

from game.views._base import *

#-------------------------------------------------------------------------------
class View(BaseView):

    success_url = "/game/alliance-requests/"
    template_name = "alliance-requests"
    selected_menu = "alliance.requests"

    #---------------------------------------------------------------------------
    def dispatch(self, request, *args, **kwargs):

        response = super().pre_dispatch(request, *args, **kwargs)
        if response: return response

        if self.allianceId == None: return HttpResponseRedirect("/game/alliance/")
        
        return super().dispatch(request, *args, **kwargs)

    #---------------------------------------------------------------------------
    def processAction(self, request, action):
    
        if action == "accept":
        
            id = request.GET.get("id", "")

            row = dbRow("SELECT user_alliance_money_request_accept(" + str(self.userId) + "," + sqlStr(id) + ")")
            return row[0]
            
        elif action == "deny":
        
            id = request.GET.get("id", "")
            
            row = dbRow("SELECT user_alliance_money_request_decline(" + str(self.userId) + "," + sqlStr(id) + ")")
            return row[0]
        
        elif action == "cancel":
        
            row = dbRow("SELECT user_alliance_money_request_create(" + str(self.userId) + ",0,\"\")")
            return row[0]
        
        elif action == "request":
        
            credits = ToInt(request.POST.get("credits"), 0)
            description = request.POST.get("description", "").strip()
            
            row = dbRow("SELECT user_alliance_money_request_create(" + str(self.userId) + "," + str(credits) + "," + sqlStr(description) + ")")
            return row[0]

    #---------------------------------------------------------------------------
    def fillContent(self, request, data):
    
        # --- user rights
        
        if self.hasRight["can_accept_money_requests"]: data["can_accept"] = True
        
        # --- user request data
    
        query = "SELECT credits, description, result" + \
                " FROM gm_alliance_money_requests" + \
                " WHERE allianceid=" + str(self.allianceId) + " AND userid=" + str(self.userId)
        row = dbRow(query)
        if row:
            
            data["request"] = {}
            
            data["request"]["credits"] = row[0]
            data["request"]["description"] = row[1]
            
            if row[2] == False: data["request"]["denied"] = True
            else: data["request"]["request_submitted"] = True

        # --- requests data
        
        if self.hasRight["can_accept_money_requests"]:
            
            data["requests"] = []
            
            query = "SELECT r.id, datetime, login, r.credits, r.description" + \
                    " FROM gm_alliance_money_requests r" + \
                    "   INNER JOIN gm_profiles ON gm_profiles.id=r.userid" + \
                    " WHERE allianceid=" + str(self.allianceId) + " AND result IS NULL"
            rows = dbRows(query)
            if rows:
                for row in rows:
                
                    request = {}
                    data["requests"].append(request)
                
                    request["id"] = row[0]
                    request["date"] = row[1]
                    request["nation"] = row[2]
                    request["credits"] = row[3]
                    request["description"] = row[4]
