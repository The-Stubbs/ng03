# -*- coding: utf-8 -*-

from game.views._base import *



################################################################################
class View(ActionView):
    
    template_name = 'game/alliance_gifts.html'
    success_url = '/game/alliance/gifts/'
    
    tab_selected = None
    menu_selected = 'alliance'
    submenu_selected = None

    #---------------------------------------------------------------------------
    def dispatch(self, request, *args, **kwargs):
        #-----------------------------------------------------------------------
        if not self.profile['alliance_id']: return HttpResponseRedirect('/game/empire/overview/')
        #-----------------------------------------------------------------------
        query = "SELECT game_started < now() - INTERVAL '2 weeks' FROM users WHERE id=" & userid
        row = db_result(cursor, query)
        self.can_give_money = row and row[0]
        #-----------------------------------------------------------------------
        return super().dispatch(request, *args, **kwargs)
        #-----------------------------------------------------------------------

    #---------------------------------------------------------------------------
    def get_context(self, request, cursor, **kwargs):
        #-----------------------------------------------------------------------
        context = super().get_context(request, cursor, **kwargs)
        #-----------------------------------------------------------------------
        if self.can_give_money: context['can_give'] = True
        else: context['can_give_after_a_week'] = True
        #-----------------------------------------------------------------------
        if self.alliance_rights['can_accept_money_requests']:
            query = "SELECT datetime, credits, source, description" &_
				" FROM alliances_wallet_journal" &_
				" WHERE allianceid="&AllianceId&" AND type=0 AND datetime >= now()-INTERVAL '1 week'" &_
				" ORDER BY datetime DESC"
            context['entries'] = db_results(cursor, query)
        #-----------------------------------------------------------------------
        return context
        #-----------------------------------------------------------------------
    
    #---------------------------------------------------------------------------
    def process_action(self, request, cursor, action):
        #-----------------------------------------------------------------------
        if action == 'give' and self.can_give_money:
            #-------------------------------------------------------------------
            credit = get_int(Request.Form("credits"), 0)
            description = Trim(Request.Form("description"))
            #-------------------------------------------------------------------
            result = db_result(cursor, 'SELECT ua_alliance_give_credits(' + str(self.profile['id']) + ',' + str(credit) + ',' + str(description) + ')')
            if result == 0: return self.success()
            else: messages.error(request, 'error_alliance_give_credits_' + str(result))
        #-----------------------------------------------------------------------
        return self.failed()
        #-----------------------------------------------------------------------

################################################################################
