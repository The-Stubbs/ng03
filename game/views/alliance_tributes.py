# -*- coding: utf-8 -*-

from game.views._base import *



################################################################################
class View(ActionView):
    
    template_name = 'game/alliance_tributes.html'
    success_url = '/game/alliance/tributes/'
    
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
        col = Request.QueryString("col")
        if col < 1 or col > 2 then col = 1
        #-----------------------------------------------------------------------
        select case col
            case 1
                orderby = "tag"
            case 2
                orderby = "created"
                reversed = true
        #-----------------------------------------------------------------------
        if Request.QueryString("r") <> "" then
            reversed = not reversed
        #-----------------------------------------------------------------------
        if reversed then orderby = orderby & " DESC"
        orderby = orderby & ", tag"
        #-----------------------------------------------------------------------
        query = "SELECT w.created, alliances.id, alliances.tag, alliances.name, w.credits, w.next_transfer"&_
                " FROM alliances_tributes w" &_
                "	INNER JOIN alliances ON (allianceid = alliances.id)" &_
                " WHERE target_allianceid=" & AllianceId &_
                " ORDER BY " & orderby
        context['tributes_received'] = db_results(cursor, query)
        #-----------------------------------------------------------------------
        query = "SELECT w.created, alliances.id, alliances.tag, alliances.name, w.credits"&_
                " FROM alliances_tributes w" &_
                "	INNER JOIN alliances ON (target_allianceid = alliances.id)" &_
                " WHERE allianceid=" & AllianceId &_
                " ORDER BY " & orderby
        context['tributes_sent'] = db_results(cursor, query)
        #-----------------------------------------------------------------------
        context['can_break_nap'] = oAllianceRights("can_break_nap")
        #-----------------------------------------------------------------------
        return context
        #-----------------------------------------------------------------------
    
    #---------------------------------------------------------------------------
    def process_action(self, request, cursor, action):
        #-----------------------------------------------------------------------
        if action == 'create':
            #-------------------------------------------------------------------
            result = db_result(cursor, 'SELECT ua_alliance_tribute_create(' + ')')
            if result == 0: return self.success()
            else: messages.error(request, 'error_' + str(result))
        #-----------------------------------------------------------------------
        elif action == 'cancel':
            #-------------------------------------------------------------------
            result = db_result(cursor, 'SELECT ua_alliance_tribute_cancel(' + ')')
            if result == 0: return self.success()
            else: messages.error(request, 'error_' + str(result))
        #-----------------------------------------------------------------------
        return self.failed()
        #-----------------------------------------------------------------------

################################################################################
