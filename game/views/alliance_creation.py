# -*- coding: utf-8 -*-

from game.views._base import *

#-------------------------------------------------------------------------------
class View(BaseView):

    success_url = "/game/alliance/"
    template_name = "alliance-creation"
    selected_menu = "alliance.creation"

    #---------------------------------------------------------------------------
    def dispatch(self, request, *args, **kwargs):

        response = super().pre_dispatch(request, *args, **kwargs)
        if response: return response
        
        if self.allianceId: return HttpResponseRedirect("/game/alliance/")

        return super().dispatch(request, *args, **kwargs)

    #---------------------------------------------------------------------------
    def processAction(self, request, action):
    
        if action == "create":
            
            if not self.userInfo["can_join_alliance"]: return -1
            
            name = request.POST.get("name", "").strip()
            if not isValidAlliancename(name): return -2
            
            tag = request.POST.get("tag", "").strip()
            if not isValidAlliancetag(tag): return -3
            
            description = request.POST.get("description", "").strip()
            if not isValiddescription(description): return -4

            row = dbRow("SELECT user_alliance_create(" + str(self.userId) + "," + sqlStr(self.name) + "," + sqlStr(self.tag) + "," + sqlStr(self.description) + ")")
            return row[0]

    #---------------------------------------------------------------------------
    def fillContent(self, request, data):
        
        # --- user rights
        
        if self.userInfo["can_join_alliance"]:
            data["can_create"] = True
        
        # --- form data
        
        data["tag"] = request.POST.get("tag", "")
        data["name"] = request.POST.get("name", "")
        data["description"] = request.POST.get("description", "")
