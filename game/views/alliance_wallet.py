# -*- coding: utf-8 -*-

from game.views._base import *

#-------------------------------------------------------------------------------
class View(BaseView):

    success_url = "/game/alliance-wallet/"
    template_name = "alliance-wallet"
    selected_menu = "alliance.wallet"

    #---------------------------------------------------------------------------
    def dispatch(self, request, *args, **kwargs):

        response = super().pre_dispatch(request, *args, **kwargs)
        if response: return response

        if self.allianceId == None: return HttpResponseRedirect("/game/alliance/")
        
        return super().dispatch(request, *args, **kwargs)

    #---------------------------------------------------------------------------
    def processAction(self, request, action):

        if action == "refresh":
        
            gifts = ToInt(request.POST.get("gifts"), 0) == 1
            taxes = ToInt(request.POST.get("taxes"), 0) == 1
            settax = ToInt(request.POST.get("settax"), 0) == 1
            kicksbreaks = ToInt(request.POST.get("kicksbreaks"), 0) == 1

            query = "UPDATE gm_profiles SET" + \
                    " wallet_display[1]=" + str(gifts) + \
                    " ,wallet_display[2]=" + str(settax) + \
                    " ,wallet_display[3]=" + str(taxes) + \
                    " ,wallet_display[4]=" + str(kicksbreaks) + \
                    " WHERE id=" + str(self.userId)
            dbExecute(query)
            return 0
        
        elif action == "save":

            if not self.hasRight["can_change_tax_rate"]: return -1
            
            taxrates = request.POST.get("taxrates","")
            
            row = dbRow("SELECT user_alliance_set_tax(" + str(self.userId) + "," + sqlStr(taxrates) + ")")
            return row[0]
    
    #---------------------------------------------------------------------------
    def fillContent(self, request, data):
    
        # --- user right
        
        if not self.hasRight["can_change_tax_rate"]: data["can_change"] = True
    
        # --- tax data

        row = dbRow("SELECT tax FROM gm_alliances WHERE id=" + str(self.allianceId))
        data["tax"] = row[0]
    
        # --- tax values data

        data["taxes"] = []
        
        for i in range(0, 20):
        
            tax = {}
            data["taxes"].append(tax)
            
            tax["value"] = i * 0.5
            tax["rates"] = i * 5
        
        # --- column sorting
        
        col = ToInt(request.GET.get("col"), 1)
        if col < 1 or col > 4: col = 1

        reversed = False
        if col == 1:
            orderby = "datetime"
            reversed = True
        elif col == 2:
            orderby = "type"
            reversed = True
        elif col == 3:
            orderby = "upper(source)"
            reversed = True
        elif col == 4:
            orderby = "upper(destination)"
            reversed = True

        if request.GET.get("r","") != "":
            reversed = not reversed

        if reversed: orderby = orderby + " DESC"
        orderby = orderby + ", datetime DESC"
        
        data["col"] = col
        data["reversed"] = reversed
    
        # --- filtering data

        query = "SELECT COALESCE(wallet_display[1], True)," + \
                " COALESCE(wallet_display[2], True)," + \
                " COALESCE(wallet_display[3], True)," + \
                " COALESCE(wallet_display[4], True)" + \
                " FROM gm_profiles" + \
                " WHERE id=" + str(self.userId)
        row = dbRow(query)

        gifts = row[0]
        settax = row[1]
        taxes = row[2]
        kicksbreaks = row[3]

        if gifts: data["gifts_checked"] = True
        if taxes: data["taxes_checked"] = True
        if settax: data["settax_checked"] = True
        if kicksbreaks: data["kicksbreaks_checked"] = True
    
        # --- wallet log data
        
        data["entries"] = []

        query = ""
        if not gifts: query = query + " AND type != 0 AND type != 3 AND type != 20"
        if not taxes: query = query + " AND type != 1"
        if not settax: query = query + " AND type != 4"
        if not kicksbreaks: query = query + " AND type != 2 AND type != 5 AND type != 10 AND type != 11"

        query = "SELECT Max(datetime), userid, int4(sum(credits)), description, source, destination, type, groupid" + \
                " FROM gm_alliance_wallet_logs" + \
                " WHERE allianceid=" + str(self.allianceId) + query + " AND datetime >= now()-INTERVAL '1 week'" + \
                " GROUP BY userid, description, source, destination, type, groupid" + \
                " ORDER BY Max(datetime) DESC" + \
                " LIMIT 500"
        rows = dbRows(query)
        if rows:
            for row in rows:
            
                entry = {}
                data["entries"].append(entry)
                
                entry["date"] = row[0]
                entry["amount"] = row[2]
                entry["description"] = row[3] if row[3] else ""
                entry["source"] = row[4] if row[4] else ""
                entry["destination"] = row[5] if row[5] else ""
                entry["type"] = row[6]
                
                if row[6] == 4: item["description"] = str(int(row[3]) / 10) + " %"
