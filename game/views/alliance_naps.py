# -*- coding: utf-8 -*-

from game.views._base import *



################################################################################
class View(ActionView):
    
    template_name = 'game/alliance_naps.html'
    success_url = '/game/alliance/naps/'
    
    tab_selected = None
    menu_selected = 'alliance'
    submenu_selected = None

    #---------------------------------------------------------------------------
    def dispatch(self, request, *args, **kwargs):
        #-----------------------------------------------------------------------
        if not self.profile['alliance_id']: return HttpResponseRedirect('/game/empire/overview/')
        #-----------------------------------------------------------------------
        return super().dispatch(request, *args, **kwargs)
        #-----------------------------------------------------------------------

    #---------------------------------------------------------------------------
    def get_context(self, request, cursor, **kwargs):
        #-----------------------------------------------------------------------
        context = super().get_context(request, cursor, **kwargs)
        #-----------------------------------------------------------------------
        context['can_create_nap'] = self.oAllianceRights("can_create_nap")
        context['can_break_nap'] = self.oAllianceRights("can_break_nap")
        #-----------------------------------------------------------------------
        query = "SELECT alliances.tag, alliances.name, alliances_naps_offers.created, recruiters.login, declined, date_part('epoch', break_interval)::integer" &_
                " FROM alliances_naps_offers" &_
                "			INNER JOIN alliances ON alliances.id = alliances_naps_offers.targetallianceid" &_
                "			LEFT JOIN users AS recruiters ON recruiters.id = alliances_naps_offers.recruiterid" &_
                " WHERE allianceid=" & AllianceId &_
                " ORDER BY created DESC"
        context['requests'] = db_results(cursor, query)
        #-----------------------------------------------------------------------
        query = "SELECT alliances.tag, alliances.name, alliances_naps_offers.created, recruiters.login, declined, date_part('epoch', break_interval)::integer" &_
                " FROM alliances_naps_offers" &_
                "			INNER JOIN alliances ON alliances.id = alliances_naps_offers.allianceid" &_
                "			LEFT JOIN users AS recruiters ON recruiters.id = alliances_naps_offers.recruiterid" &_
                " WHERE targetallianceid=" & AllianceId & " AND NOT declined" &_
                " ORDER BY created DESC"
        context['propositions'] = db_results(cursor, query)
        #-----------------------------------------------------------------------
        col = Request.QueryString("col")
        if col < 1 or col > 4 then col = 1
        if col = 2 then col = 1
        #-----------------------------------------------------------------------
        select case col
            case 1
                orderby = "tag"
            case 3
                orderby = "created"
                reversed = true
            case 4
                orderby = "break_interval"
            case 5
                orderby = "share_locs"
            case 6
                orderby = "share_radars"
        #-----------------------------------------------------------------------
        if Request.QueryString("r") <> "" then
            reversed = not reversed
        #-----------------------------------------------------------------------
        if reversed then orderby = orderby & " DESC"
        orderby = orderby & ", tag"
        #-----------------------------------------------------------------------
        query = "SELECT n.allianceid2, tag, name, "&_
                " (SELECT COALESCE(sum(score)/1000, 0) AS score FROM users WHERE alliance_id=allianceid2), n.created, date_part('epoch', n.break_interval)::integer, date_part('epoch', break_on-now())::integer," &_
                " share_locs, share_radars" &_
                " FROM alliances_naps n" &_
                "	INNER JOIN alliances ON (allianceid2 = alliances.id)" &_
                " WHERE allianceid1=" & AllianceId &_
                " ORDER BY " & orderby
        context['naps'] = db_results(cursor, query)
        #-----------------------------------------------------------------------
        return context
        #-----------------------------------------------------------------------
    
    #---------------------------------------------------------------------------
    def process_action(self, request, cursor, action):
        #-----------------------------------------------------------------------
        if action == 'create':
            #-------------------------------------------------------------------
            result = db_result(cursor, 'SELECT ua_alliance_nap_request_create(' + ')')
            if result == 0: return self.success()
            else: messages.error(request, 'error_' + str(result))
        #-----------------------------------------------------------------------
        elif action == 'accept':
            #-------------------------------------------------------------------
            result = db_result(cursor, 'SELECT ua_alliance_nap_request_accept(' + ')')
            if result == 0: return self.success()
            else: messages.error(request, 'error_' + str(result))
        #-----------------------------------------------------------------------
        elif action == 'decline':
            #-------------------------------------------------------------------
            result = db_result(cursor, 'SELECT ua_alliance_nap_request_decline(' + ')')
            if result == 0: return self.success()
            else: messages.error(request, 'error_' + str(result))
        #-----------------------------------------------------------------------
        elif action == 'cancel':
            #-------------------------------------------------------------------
            result = db_result(cursor, 'SELECT ua_alliance_nap_request_cancel(' + ')')
            if result == 0: return self.success()
            else: messages.error(request, 'error_' + str(result))
        #-----------------------------------------------------------------------
        elif action == 'toggle_location':
            #-------------------------------------------------------------------
            result = db_result(cursor, 'SELECT ua_alliance_nap_toggle_location(' + ')')
            if result == 0: return self.success()
            else: messages.error(request, 'error_' + str(result))
        #-----------------------------------------------------------------------
        elif action == 'toggle_radar':
            #-------------------------------------------------------------------
            result = db_result(cursor, 'SELECT ua_alliance_nap_toggle_radar(' + ')')
            if result == 0: return self.success()
            else: messages.error(request, 'error_' + str(result))
        #-----------------------------------------------------------------------
        elif action == 'break':
            #-------------------------------------------------------------------
            result = db_result(cursor, 'SELECT ua_alliance_nap_break(' + ')')
            if result == 0: return self.success()
            else: messages.error(request, 'error_' + str(result))
        #-----------------------------------------------------------------------
        return self.failed()
        #-----------------------------------------------------------------------

################################################################################
