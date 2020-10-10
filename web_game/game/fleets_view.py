# -*- coding: utf-8 -*-

from web_game.game._global import *



class View(GlobalView):

    def dispatch(self, request, *args, **kwargs):

        response = super().pre_dispatch(request, *args, **kwargs)
        if response: return response
            
        return super().dispatch(request, *args, **kwargs)
    
    
    
    def get(self, request, *args, **kwargs):
        
        self.selected_menu = "fleets"

        content = GetTemplate(self.request, "fleets_view")

        # --- user fleet categories data

        list = []
        content.AssignValue("categories", list)
        
        query = "SELECT category, label" + \
                " FROM users_fleets_categories" + \
                " WHERE userid=" + str(self.UserId) + \
                " ORDER BY upper(label)"
        oRss = oConnExecuteAll(query)

        for oRs in oRss:
            
            item = {}
            list.append(item)
            
            item["id"] = oRs[0]
            item["label"] = oRs[1]

        return self.Display(content)
