# -*- coding: utf-8 -*-

from game.views._base import *

#-------------------------------------------------------------------------------
class View(BaseView):

    success_url = "/game/alliance-overview/"
    template_name = "alliance-overview"
    selected_menu = "alliance.overview"

    #---------------------------------------------------------------------------
    def dispatch(self, request, *args, **kwargs):

        response = super().pre_dispatch(request, *args, **kwargs)
        if response: return response

        if self.allianceId == None: return HttpResponseRedirect("/game/alliance/")
        if not self.hasRight("can_manage_description" and not self.hasRight("can_manage_announce"): return HttpResponseRedirect("/game/alliance/")
        
        return super().dispatch(request, *args, **kwargs)

    #---------------------------------------------------------------------------
    def processAction(self, request, action):

        if action == "save":
        
            logo = request.POST.get("logo","").strip()
            if not isValidURL(logo): return -1
            
            defcon = ToInt(request.POST.get("defcon"), 5)
            announce = request.POST.get("announce","").strip()
            description = request.POST.get("description","").strip()

            dbExecute("UPDATE gm_alliances SET logo_url=" + sqlStr(logo) + ", description=" + sqlStr(description) + " defcon=" + str(defcon) + ", announce=" + sqlStr(announce) + "WHERE id=" + str(self.allianceId))        
            return 0
 
    #---------------------------------------------------------------------------
    def fillContent(self, request, data):

        # --- alliance data
        
        query = "SELECT id, tag, name, description, created, (SELECT count(*) FROM gm_profiles WHERE alliance_id=gm_alliances.id), logo_url," + \
                " max_members, announce, defcon" + \
                " FROM gm_alliances" + \
                " WHERE id=" + str(self.allianceId)
        row = dbRow(query)

        data["tag"] = row[1]
        data["name"] = row[2]
        data["description"] = row[3]
        data["created"] = row[4]
        data["cur_members"] = row[5]
        data["logo"] = row[6]
        data["max_members"] = row[7]
        data["announce"] = row[8]
        data["defcon"] = row[9]
