# -*- coding: utf-8 -*-

from game.views._base import *

#-------------------------------------------------------------------------------
class View(BaseView):

    success_url = "/game/alliance-naps/"
    template_name = "alliance-naps"
    selected_menu = "alliance.naps"

    #---------------------------------------------------------------------------
    def dispatch(self, request, *args, **kwargs):

        response = super().pre_dispatch(request, *args, **kwargs)
        if response: return response

        if self.allianceId == None: return HttpResponseRedirect("/game/alliance/")
        
        return super().dispatch(request, *args, **kwargs)

    #---------------------------------------------------------------------------
    def processAction(self, request, action):

        if action == "accept":
        
            if not self.hasRight("can_create_nap"): return -1
            
            tag = request.POST.get("tag", "").strip()
            
            row = dbRow("SELECT user_alliance_nap_offer_accept(" + str(self.userId) + "," + sqlStr(tag) + ")")
            return row[0]

        elif action == "decline":
        
            if not self.hasRight("can_create_nap"): return -1
            
            tag = request.POST.get("tag", "").strip()
            
            row = dbRow("SELECT user_alliance_nap_offer_decline(" + str(self.userId) + "," + sqlStr(tag) + ")")
            return row[0]
            
        elif action == "cancel":
            
            if not self.hasRight("can_create_nap"): return -1
            
            tag = request.POST.get("tag", "").strip()
            
            row = dbRow("SELECT user_alliance_nap_offer_cancel(" + str(self.userId) + "," + sqlStr(tag) + ")")
            return row[0]
            
        elif action == "sharelocs":
            
            if not self.hasRight("can_create_nap") and not self.hasRight("can_break_nap"): return -1
            
            tag = request.POST.get("tag", "").strip()
            
            row = dbRow("SELECT user_alliance_nap_toggle_loc_sharing(" + str(self.userId) + "," + sqlStr(tag) + ")")
            return row[0]
            
        elif action == "shareradars":
            
            if not self.hasRight("can_create_nap") and not self.hasRight("can_break_nap"): return -1
            
            tag = request.POST.get("tag", "").strip()
            
            row = dbRow("SELECT user_alliance_nap_toggle_radar_sharing(" + str(self.userId) + "," + sqlStr(tag) + ")")
            return row[0]
        
        elif action == "break":
            
            if not self.hasRight("can_break_nap"): return -1
            
            tag = request.POST.get("tag", "").strip()
            
            row = dbRow("SELECT user_alliance_nap_break(" + str(self.userId) + "," + sqlStr(tag) + ")")
            return row[0]

        elif action == "new":
            
            if not self.hasRight("can_create_nap"): return -1
            
            tag = request.POST.get("tag", "").strip()
            hours = ToInt(request.POST.get("hours"), 24)

            row = dbRow("SELECT user_alliance_nap_offer_create(" + str(self.userId) + "," + sqlStr(tag) + "," + str(hours) + ")")
            return row[0]
 
    #---------------------------------------------------------------------------
    def fillContent(self, request, data):
    
        # --- column sorting
    
        col = ToInt(request.GET.get("col"), 1)
        if col < 1 or col > 3: col = 1

        reversed = False
        if col == 1:
            orderby = "tag"
        elif col == 3:
            orderby = "created"
            reversed = True

        if request.GET.get("r", "") != "":
            reversed = not reversed

        if reversed: orderby = orderby + " DESC"
        orderby = orderby + ", tag"
        
        data["col"] = col
        data["reversed"] = reversed
        
        # --- user rights
        
        if self.hasRight("can_create_nap"): data["can_create"] = True
        if self.hasRight("can_break_nap"): data["can_break"] = True
        
        # --- naps data
        
        data["naps"] = []
        
        query = "SELECT n.allianceid2, tag, name, " + \
                " (SELECT COALESCE(sum(score)/1000, 0) AS score FROM gm_profiles WHERE alliance_id=allianceid2), n.created, date_part('epoch', n.break_interval)::integer, date_part('epoch', break_on-now())::integer," + \
                " share_locs, share_radars" + \
                " FROM gm_alliance_naps n" + \
                "    INNER JOIN gm_alliances ON (allianceid2 = gm_alliances.id)" + \
                " WHERE allianceid1=" + str(self.allianceId) + \
                " ORDER BY " + orderby
        rows = dbRows(query)
        if rows:
            for row in rows:
            
                nap = {}
                data["naps"].append(nap)
                
                nap["tag"] = row[1]
                nap["name"] = row[2]
                nap["score"] = row[3]
                nap["created"] = row[4]
                nap["locs_shared"] = row[7]
                nap["radars_shared"] = row[8]

                if row[6] == None:
                    nap["break_interval"] = row[5]
                    nap["time"] = True
                else:
                    nap["break_interval"] = row[6]
                    nap["countdown"] = True
                    nap["broken"] = True
        
        # --- nap propositions data
        
        data["propositions"] = []
        
        query = "SELECT gm_alliances.tag, gm_alliances.name, gm_alliance_nap_offers.created, recruiters.login, declined, date_part('epoch', break_interval)::integer" + \
                " FROM gm_alliance_nap_offers" + \
                "   INNER JOIN gm_alliances ON gm_alliances.id = gm_alliance_nap_offers.allianceid" + \
                "   LEFT JOIN gm_profiles AS recruiters ON recruiters.id = gm_alliance_nap_offers.recruiterid" + \
                " WHERE targetallianceid=" + str(self.allianceId) + " AND NOT declined" + \
                " ORDER BY created DESC"
        rows = dbRows(query)
        if rows:
            for row in rows:
                
                proposition = {}
                data["propositions"].append(proposition)
                
                proposition["tag"] = row[0]
                proposition["name"] = row[1]
                proposition["date"] = row[2]
                proposition["recruiter"] = row[3]
                proposition["break_interval"] = row[5]

                if row[4]: proposition["declined"] = True
                else: proposition["waiting"] = True

        # --- nap requests data
        
        data["requests"] = []

        query = "SELECT gm_alliances.tag, gm_alliances.name, gm_alliance_nap_offers.created, recruiters.login, declined, date_part('epoch', break_interval)::integer" + \
                " FROM gm_alliance_nap_offers" + \
                "   INNER JOIN gm_alliances ON gm_alliances.id = gm_alliance_nap_offers.targetallianceid" + \
                "   LEFT JOIN gm_profiles AS recruiters ON recruiters.id = gm_alliance_nap_offers.recruiterid" + \
                " WHERE allianceid=" + str(self.allianceId) + \
                " ORDER BY created DESC"
        rows = dbRows(query)
        if rows:
            for row in rows:
            
                request = {}
                data["requests"].append(request)
                
                request["tag"] = row[0]
                request["name"] = row[1]
                request["date"] = row[2]
                request["recruiter"] = row[3]
                request["break_interval"] = row[5]

                if row[4]: request["declined"] = True
                else: request["waiting"] = True

        # --- request form data
        
        data["tag"] = request.POST.get("tag", "").strip()
        data["hours"] = ToInt(request.POST.get("hours"), 24)
