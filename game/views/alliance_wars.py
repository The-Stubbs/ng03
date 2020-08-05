# -*- coding: utf-8 -*-

from game.views._base import *



################################################################################
class View(ActionView):
    
    template_name = 'game/alliance_wars.html'
    success_url = '/game/alliance/wars/'
    
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
        cat = Request.QueryString("cat")
        if cat < 1 or cat > 2 then cat = 1
        #-----------------------------------------------------------------------
        col = Request.QueryString("col")
        if col < 1 or col > 2 then col = 1

        select case col
            case 1
                orderby = "tag"
            case 2
                orderby = "created"
                reversed = true
        end select

        if Request.QueryString("r") <> "" then
            reversed = not reversed
        #-----------------------------------------------------------------------
        if reversed then orderby = orderby & " DESC"
        orderby = orderby & ", tag"
        #-----------------------------------------------------------------------
        query = "SELECT w.created, alliances.id, alliances.tag, alliances.name, cease_fire_requested, date_part('epoch', cease_fire_expire-now())::integer, w.can_fight < now() AS can_fight, true AS attacker, next_bill < now() + INTERVAL '1 week', sp_alliance_war_cost(allianceid2), next_bill"&_
                " FROM alliances_wars w" &_
                "	INNER JOIN alliances ON (allianceid2 = alliances.id)" &_
                " WHERE allianceid1=" & AllianceId &_
                " UNION " &_
                "SELECT w.created, alliances.id, alliances.tag, alliances.name, cease_fire_requested, date_part('epoch', cease_fire_expire-now())::integer, w.can_fight < now() AS can_fight, false AS attacker, false, 0, next_bill"&_
                " FROM alliances_wars w" &_
                "	INNER JOIN alliances ON (allianceid1 = alliances.id)" &_
                " WHERE allianceid2=" & AllianceId &_
                " ORDER BY " & orderby
        set oRs = oConn.Execute(query)
        #-----------------------------------------------------------------------
        context["can_break_nap"] = oAllianceRights("can_break_nap")
        #-----------------------------------------------------------------------
        return context
        #-----------------------------------------------------------------------
    
    #---------------------------------------------------------------------------
    def process_action(self, request, cursor, action):
        #-----------------------------------------------------------------------
        if action == 'create':
            #-------------------------------------------------------------------
            result = db_result(cursor, 'SELECT ua_alliance_war_create(' + ')')
            if result == 0: return self.success()
            else: messages.error(request, 'error_' + str(result))
        #-----------------------------------------------------------------------
        elif action == 'pay':
            #-------------------------------------------------------------------
            result = db_result(cursor, 'SELECT ua_alliance_war_pay(' + ')')
            if result == 0: return self.success()
            else: messages.error(request, 'error_' + str(result))
        #-----------------------------------------------------------------------
        elif action == 'cancel':
            #-------------------------------------------------------------------
            result = db_result(cursor, 'SELECT ua_alliance_war_cancel(' + ')')
            if result == 0: return self.success()
            else: messages.error(request, 'error_' + str(result))
        #-----------------------------------------------------------------------
        return self.failed()
        #-----------------------------------------------------------------------

################################################################################
