# -*- coding: utf-8 -*-

from game.views._base import *

#-------------------------------------------------------------------------------
class View(BaseView):

    success_url = "/game/alliance-ranks/"
    template_name = "alliance-ranks"
    selected_menu = "alliance.ranks"

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
        
            query = "SELECT rankid, leader" + \
                    " FROM gm_alliance_ranks" + \
                    " WHERE allianceid=" + str(self.allianceId) + \
                    " ORDER BY rankid"
            rows = dbRows(query)
            if rows:
                for row in rows:
                
                    name = request.POST.get("n" + str(row[0]), "").strip()
                    if len(name) > 2:
                        query = "UPDATE gm_alliance_ranks SET" + \
                                " label=" + sqlStr(name) + \
                                ", is_default=NOT leader AND " + str(ToBool(request.POST.get("c" + str(row[0]) + "_0"), False)) + \
                                ", can_invite_player=leader OR " + str(ToBool(request.POST.get("c" + str(row[0]) + "_1"), False)) + \
                                ", can_kick_player=leader OR " + str(ToBool(request.POST.get("c" + str(row[0]) + "_2"), False)) + \
                                ", can_create_nap=leader OR " + str(ToBool(request.POST.get("c" + str(row[0]) + "_3"), False)) + \
                                ", can_break_nap=leader OR " + str(ToBool(request.POST.get("c" + str(row[0]) + "_4"), False)) + \
                                ", can_ask_money=leader OR " + str(ToBool(request.POST.get("c" + str(row[0]) + "_5"), False)) + \
                                ", can_see_reports=leader OR " + str(ToBool(request.POST.get("c" + str(row[0]) + "_6"), False)) + \
                                ", can_accept_money_requests=leader OR " + str(ToBool(request.POST.get("c" + str(row[0]) + "_7"), False)) + \
                                ", can_change_tax_rate=leader OR " + str(ToBool(request.POST.get("c" + str(row[0]) + "_8"), False)) + \
                                ", can_mail_alliance=leader OR " + str(ToBool(request.POST.get("c" + str(row[0]) + "_9"), False)) + \
                                ", can_manage_description=leader OR " + str(ToBool(request.POST.get("c" + str(row[0]) + "_10"), False)) + \
                                ", can_manage_announce=leader OR " + str(ToBool(request.POST.get("c" + str(row[0]) + "_11"), False)) + \
                                ", can_see_members_info=leader OR " + str(ToBool(request.POST.get("c" + str(row[0]) + "_12"), False)) + \
                                ", members_displayed=leader OR " + str(ToBool(request.POST.get("c" + str(row[0]) + "_13"), False)) + \
                                ", can_order_other_fleets=leader OR " + str(ToBool(request.POST.get("c" + str(row[0]) + "_14"), False)) + \
                                ", can_use_alliance_radars=leader OR " + str(ToBool(request.POST.get("c" + str(row[0]) + "_15"), False)) + \
                                ", enabled=leader OR EXISTS(SELECT 1 FROM gm_profiles WHERE alliance_id=" + str(self.allianceId) + " AND alliance_rank=" + str(row[0])+ " LIMIT 1) OR " + str(ToBool(request.POST.get("c" + str(row[0]) + "_enabled"), False)) + " OR " + str(ToBool(request.POST.get("c" + str(row[0]) + "_0"), False)) + \
                                " WHERE allianceid=" + str(self.allianceId) + " AND rankid=" + str(row[0])
                        dbExecute(query)
            return 0
 
    #---------------------------------------------------------------------------
    def fillContent(self, request, data):

        # --- ranks data
        
        data["ranks"] = []
        
        query = "SELECT rankid, label, leader, can_invite_player, can_kick_player, can_create_nap, can_break_nap, can_ask_money, can_see_reports, " + \
                " can_accept_money_requests, can_change_tax_rate, can_mail_alliance, is_default, members_displayed, can_manage_description, can_manage_announce, " + \
                " enabled, can_see_members_info, can_order_other_fleets, can_use_alliance_radars" + \
                " FROM gm_alliance_ranks" + \
                " WHERE allianceid=" + str(self.allianceId) + \
                " ORDER BY rankid"
        rows = dbDictRows(query)
        if rows:
            for row in rows:
            
                rank = {}
                data["ranks"].append(rank)
                
                rank["id"] = row["rankid"]
                rank["name"] = row["label"]
                rank["disabled"] = row["leader"]

                if row["leader"] or row["enabled"]: rank["enabled"] = True
                if not row["leader"] and row["is_default"]: rank["checked_0"] = True

                if row["leader"] or row["can_invite_player"]: rank["checked_1"] = True
                if row["leader"] or row["can_kick_player"]: rank["checked_2"] = True

                if row["leader"] or row["can_create_nap"]: rank["checked_3"] = True
                if row["leader"] or row["can_break_nap"]: rank["checked_4"] = True

                if row["leader"] or row["can_ask_money"]: rank["checked_5"] = True
                if row["leader"] or row["can_see_reports"]: rank["checked_6"] = True

                if row["leader"] or row["can_accept_money_requests"]: rank["checked_7"] = True
                if row["leader"] or row["can_change_tax_rate"]: rank["checked_8"] = True

                if row["leader"] or row["can_mail_alliance"]: rank["checked_9"] = True

                if row["leader"] or row["can_manage_description"]: rank["checked_10"] = True
                if row["leader"] or row["can_manage_announce"]: rank["checked_11"] = True

                if row["leader"] or row["can_see_members_info"]: rank["checked_12"] = True

                if row["leader"] or row["members_displayed"]: rank["checked_13"] = True

                if row["leader"] or row["can_order_other_fleets"]: rank["checked_14"] = True
                if row["leader"] or row["can_use_alliance_radars"]: rank["checked_15"] = True
