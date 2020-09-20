# -*- coding: utf-8 -*-

from game.views._base import *

#-------------------------------------------------------------------------------
class View(BaseView):

    success_url = "/game/alliance-recruitment/"
    template_name = "alliance-recruitment"
    selected_menu = "alliance.recruitment"

    #---------------------------------------------------------------------------
    def dispatch(self, request, *args, **kwargs):

        response = super().pre_dispatch(request, *args, **kwargs)
        if response: return response

        if self.allianceId == None: return HttpResponseRedirect("/game/alliance/")
        if not self.hasRight("can_invite_player"): return HttpResponseRedirect("/game/alliance/")
        
        return super().dispatch(request, *args, **kwargs)

    #---------------------------------------------------------------------------
    def processAction(self, request, action):

        if action == "save":
        
            name = request.POST.get("name","").strip()

            row = dbRow("SELECT user_alliance_invitation_create(" + str(self.userId) + "," + sqlStr(self.username) + ")")
            return row[0]
 
    #---------------------------------------------------------------------------
    def fillContent(self, request, data):

        # --- invitations data
        
        data["invitations"] = []
        
        query = "SELECT recruit.login, created, recruiters.login, declined" + \
                " FROM gm_alliance_invitations" + \
                "   INNER JOIN gm_profiles AS recruit ON recruit.id = gm_alliance_invitations.userid" + \
                "   LEFT JOIN gm_profiles AS recruiters ON recruiters.id = gm_alliance_invitations.recruiterid" + \
                " WHERE allianceid=" + str(self.allianceId) + \
                " ORDER BY created DESC"
        rows = dbRows(query)
        if rows:
            for row in rows:
            
                invitation = {}
                data["invitations"].append(invitation)
                
                invitation["name"] = row[0]
                invitation["date"] = row[1]
                invitation["recruiter"] = row[2]

                if row[3]: invitation["declined"] = True
                else: invitation["waiting"] = True

        # --- form data

        content.AssignValue("player", self.username)
