# -*- coding: utf-8 -*-

from game.views._base import *



################################################################################
class View(ActionView):
    
    template_name = 'game/alliance_wallet.html'
    success_url = '/game/alliance/wallet/'
    
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
        set oRs = oConn.Execute("SELECT credits, tax FROM alliances WHERE id=" & AllianceId)
        content.AssignValue "credits", oRs(0)
        content.AssignValue "tax", oRs(1)/10
        #-----------------------------------------------------------------------
        set oRs = oConn.Execute("SELECT COALESCE(sum(credits), 0) FROM alliances_wallet_journal WHERE allianceid=" & AllianceId & " AND datetime >= now()-INTERVAL '24 hours'")
        content.AssignValue "last24h", oRs(0)
        #-----------------------------------------------------------------------
        col = Request.QueryString("col")
        if col < 1 or col > 4 then col = 1

        select case col
            case 1
                orderby = "datetime"
                reversed = true
            case 2
                orderby = "type"
                reversed = true
            case 3
                orderby = "upper(source)"
                reversed = true
            case 4
                orderby = "upper(destination)"
                reversed = true
            case 5
                orderby = "credits"
            case 6
                orderby = "upper(description)"
        end select

        if Request.QueryString("r") <> "" then
            reversed = not reversed
        
        if reversed then orderby = orderby & " DESC"
        orderby = orderby & ", datetime DESC"
        #-----------------------------------------------------------------------
		query = "SELECT COALESCE(wallet_display[1], true)," &_
				" COALESCE(wallet_display[2], true)," &_
				" COALESCE(wallet_display[3], true)," &_
				" COALESCE(wallet_display[4], true)" &_
				" FROM users" &_
				" WHERE id=" & UserId
		set oRs = oConn.Execute(query)
        if not displayGiftsRequests then query = query & " AND type <> 0 AND type <> 3 AND type <> 20"
        if not displaySetTax then query = query & " AND type <> 4"
        if not displayTaxes then query = query & " AND type <> 1"
        if not displayKicksBreaks then query = query & " AND type <> 2 AND type <> 5 AND type <> 10 AND type <> 11"
        #-----------------------------------------------------------------------
        query = "SELECT Max(datetime), userid, int4(sum(credits)), description, source, destination, type, groupid"&_
                " FROM alliances_wallet_journal"&_
                " WHERE allianceid=" & AllianceId & query & " AND datetime >= now()-INTERVAL '1 week'"&_
                " GROUP BY userid, description, source, destination, type, groupid"&_
                " ORDER BY Max(datetime) DESC"&_
                " LIMIT 500"
        set oRs = oConn.Execute(query)
        #-----------------------------------------------------------------------
        return context
        #-----------------------------------------------------------------------
    
    #---------------------------------------------------------------------------
    def process_action(self, request, cursor, action):
        #-----------------------------------------------------------------------
        if action == 'save':
            #-------------------------------------------------------------------
            result = db_result(cursor, 'SELECT ua_alliance_update_tax(' + ')')
            if result == 0: return self.success()
            else: messages.error(request, 'error_' + str(result))
        #-----------------------------------------------------------------------
        return self.failed()
        #-----------------------------------------------------------------------

################################################################################
