# -*- coding: utf-8 -*-

from game.views._base import *

#-------------------------------------------------------------------------------
class View(BaseView):

    success_url = "/game/alliance/"
    template_name = "alliance-invitations"
    
    #---------------------------------------------------------------------------
    def dispatch(self, request, *args, **kwargs):

        response = super().pre_dispatch(request, *args, **kwargs)
        if response: return response

        if self.allianceId == None: self.selected_menu = "noalliance.invitations"
        else: self.selected_menu = "alliance.invitations"
        
        return super().dispatch(request, *args, **kwargs)

    #---------------------------------------------------------------------------
    def processAction(self, request, action):
    
        if action == "accept":
            
            tag = request.POST.get("tag","").strip()
            
            row = dbRow("SELECT user_alliance_invitation_accept(" + str(self.userId) + "," + sqlStr(tag) + ")")
            return row[0]

        elif action == "decline":
            
            self.success_url = "/game/alliance-invitations/"
        
            row = dbRow("SELECT user_alliance_invitation_decline(" + str(self.userId) + "," + sqlStr(tag) + ")")
            return row[0]

        elif action == "leave":
        
            row = dbRow("SELECT user_alliance_leave(" + str(self.userId) + ",0)")
            return row[0]
 
    #---------------------------------------------------------------------------
    def fillContent(self, request, data):
        
        # --- user rights
        
        if self.userInfo["can_join_alliance"]: data["can_join"] = True
        
        if self.allianceId: data["can_accept"] = True
        
        # --- leaving data
        
        if self.allianceId and self.userInfo["can_join_alliance"]:
            
            data["leave"] = True
            
            row = dbRow("SELECT date_part('epoch', static_alliance_joining_delay()) / 3600")
            data["hours_before_rejoin"] = int(row[0])
            
        # --- invitations data
        
        data["invitations"] = []
        
        query = "SELECT gm_alliances.tag, gm_alliances.name, gm_alliance_invitations.created, gm_profiles.login" + \
                " FROM gm_alliance_invitations" + \
                "   INNER JOIN gm_alliances ON gm_alliances.id = gm_alliance_invitations.allianceid" + \
                "   LEFT JOIN gm_profiles ON gm_profiles.id = gm_alliance_invitations.recruiterid" + \
                " WHERE userid=" + str(self.userId) + " AND NOT declined" + \
                " ORDER BY created DESC"
        rows = dbRows(query)
        if rows:
            for row in rows:
            
                invitation = {}
                data["invitations"].append(invitation)
                
                invitation["tag"] = row[0]
                invitation["name"] = row[1]
                invitation["date"] = row[2]
                invitation["recruiter"] = row[3]
