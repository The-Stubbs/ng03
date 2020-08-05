# -*- coding: utf-8 -*-

from game.views._base import *



################################################################################
class View(ActionView):
    
    template_name = 'game/alliance_ranks.html'
    success_url = '/game/alliance/ranks/'
    
    tab_selected = None
    menu_selected = 'alliance'
    submenu_selected = None

    #---------------------------------------------------------------------------
    def dispatch(self, request, *args, **kwargs):
        #-----------------------------------------------------------------------
        if not self.profile['alliance_id']: return HttpResponseRedirect('/game/empire/overview/')
        if not (oAllianceRights("leader") or oAllianceRights("can_manage_description") or oAllianceRights("can_manage_announce")) then RedirectTo "alliance.asp"
        #-----------------------------------------------------------------------
        return super().dispatch(request, *args, **kwargs)
        #-----------------------------------------------------------------------

    #---------------------------------------------------------------------------
    def get_context(self, request, cursor, **kwargs):
        #-----------------------------------------------------------------------
        context = super().get_context(request, cursor, **kwargs)
        #-----------------------------------------------------------------------
        query = "SELECT rankid, label, leader, can_invite_player, can_kick_player, can_create_nap, can_break_nap, can_ask_money, can_see_reports, " &_
                " can_accept_money_requests, can_change_tax_rate, can_mail_alliance, is_default, members_displayed, can_manage_description, can_manage_announce, " &_
                " enabled, can_see_members_info, can_order_other_fleets, can_use_alliance_radars" &_
                " FROM alliances_ranks" &_
                " WHERE allianceid=" & AllianceId &_
                " ORDER BY rankid"
        context['ranks'] = db_result(cursor, query)
        #-----------------------------------------------------------------------
        return context
        #-----------------------------------------------------------------------
    
    #---------------------------------------------------------------------------
    def process_action(self, request, cursor, action):
        #-----------------------------------------------------------------------
        if action == 'save':
            #-------------------------------------------------------------------
            result = db_result(cursor, 'SELECT ua_alliance_rank_update(' + ')')
            if result == 0: return self.success()
            else: messages.error(request, 'error_' + str(result))
        #-----------------------------------------------------------------------
        return self.failed()
        #-----------------------------------------------------------------------

################################################################################
