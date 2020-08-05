# -*- coding: utf-8 -*-

from game.views._base import *



################################################################################
class View(ActionView):
    
    template_name = 'game/alliance_requests.html'
    success_url = '/game/alliance/requests/'
    
    tab_selected = None
    menu_selected = 'alliance'
    submenu_selected = None

    #---------------------------------------------------------------------------
    def dispatch(self, request, *args, **kwargs):
        #-----------------------------------------------------------------------
        if not self.profile['alliance_id']: return HttpResponseRedirect('/game/empire/overview/')
        if not self.oAllianceRights("can_ask_money"): return HttpResponseRedirect('/game/empire/overview/')
        #-----------------------------------------------------------------------
        return super().dispatch(request, *args, **kwargs)
        #-----------------------------------------------------------------------

    #---------------------------------------------------------------------------
    def get_context(self, request, cursor, **kwargs):
        #-----------------------------------------------------------------------
        context = super().get_context(request, cursor, **kwargs)
        #-----------------------------------------------------------------------
        query = "SELECT credits, description, result" &_
                " FROM alliances_wallet_requests" &_
                " WHERE allianceid=" & AllianceId & " AND userid=" & UserId
        context['request'] = db_result(cursor, query)
        #-----------------------------------------------------------------------
        if oAllianceRights("can_accept_money_requests"):
            query = "SELECT r.id, datetime, login, r.credits, r.description" &_
                    " FROM alliances_wallet_requests r" &_
                    "	INNER JOIN users ON users.id=r.userid" &_
                    " WHERE allianceid=" & AllianceId & " AND result IS NULL"
            context['requests'] = db_results(cursor, query)            
        #-----------------------------------------------------------------------
        return context
        #-----------------------------------------------------------------------
    
    #---------------------------------------------------------------------------
    def process_action(self, request, cursor, action):
        #-----------------------------------------------------------------------
        if action == 'create':
            #-------------------------------------------------------------------
            result = db_result(cursor, 'SELECT ua_alliance_wallet_request_create(' + ')')
            if result == 0: return self.success()
            else: messages.error(request, 'error_' + str(result))
        #-----------------------------------------------------------------------
        elif action == 'accept':
            #-------------------------------------------------------------------
            result = db_result(cursor, 'SELECT ua_alliance_wallet_request_accept(' + ')')
            if result == 0: return self.success()
            else: messages.error(request, 'error_' + str(result))
        #-----------------------------------------------------------------------
        elif action == 'decline':
            #-------------------------------------------------------------------
            result = db_result(cursor, 'SELECT ua_alliance_wallet_request_decline(' + ')')
            if result == 0: return self.success()
            else: messages.error(request, 'error_' + str(result))
        #-----------------------------------------------------------------------
        elif action == 'cancel':
            #-------------------------------------------------------------------
            result = db_result(cursor, 'SELECT ua_alliance_wallet_request_cancel(' + ')')
            if result == 0: return self.success()
            else: messages.error(request, 'error_' + str(result))
        #-----------------------------------------------------------------------
        return self.failed()
        #-----------------------------------------------------------------------

################################################################################
