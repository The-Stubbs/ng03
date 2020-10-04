# -*- coding: utf-8 -*-

from web_game.game._global import *



class View(GlobalView):

    def dispatch(self, request, *args, **kwargs):

        response = super().pre_dispatch(request, *args, **kwargs)
        if response: return response
            
        return super().dispatch(request, *args, **kwargs)
    
    
    
    def get(self, request, *args, **kwargs):
    
        self.selected_tab = "stats"
        self.selected_menu = "empire"

        content = GetTemplate(self.request, "empire_stats")

        # --- user lost and killed ships data

        kills = []
        content.AssignValue("kills", kills)

        losses = []
        content.AssignValue("losses", losses)

        total_kills = 0
        total_losses = 0
        
        query = " SELECT shipid, killed, lost, db_ships.label" + \
                " FROM users_ships_kills" + \
                "   INNER JOIN db_ships ON (db_ships.id = users_ships_kills.shipid)" + \
                " WHERE userid=" + str(self.UserId) + \
                " ORDER BY shipid"
        oRss = oConnExecuteAll(query)
        if oRss:
            for oRs in oRss:
                
                if oRs[1] > 0:
                
                    item = {}
                    kills.append(item)
                    
                    item["id"] = oRs[0]
                    item["name"] = oRs[3]
                    item["count"] = oRs[1]
                
                if oRs[2] > 0:
                
                    item = {}
                    losses.append(item)
                    
                    item["id"] = oRs[0]
                    item["name"] = oRs[3]
                    item["count"] = oRs[2]

                total_kills += oRs[1]
                total_losses += oRs[2]

        content.AssignValue("total_kills", total_kills)
        content.AssignValue("total_losses", total_losses)
        
        return self.Display(content)
