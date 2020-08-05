# -*- coding: utf-8 -*-

from game.views._base import *



################################################################################
class View(ActionView):
    
    template_name = 'game/alliance_recruitment.html'
    success_url = '/game/alliance/recruitment/'
    
    tab_selected = None
    menu_selected = 'alliance'
    submenu_selected = None

    #---------------------------------------------------------------------------
    def dispatch(self, request, *args, **kwargs):
        #-----------------------------------------------------------------------
        if not self.profile['alliance_id']: return HttpResponseRedirect('/game/empire/overview/')
        if not self.oAllianceRights['can_invite_player']: return HttpResponseRedirect('/game/empire/overview/')
        #-----------------------------------------------------------------------
        return super().dispatch(request, *args, **kwargs)
        #-----------------------------------------------------------------------

    #---------------------------------------------------------------------------
    def get_context(self, request, cursor, **kwargs):
        #-----------------------------------------------------------------------
        context = super().get_context(request, cursor, **kwargs)
        #-----------------------------------------------------------------------
		query = "SELECT recruit.login, created, recruiters.login, declined" &_
				" FROM alliances_invitations" &_
				"		INNER JOIN users AS recruit ON recruit.id = alliances_invitations.userid" &_
				"		LEFT JOIN users AS recruiters ON recruiters.id = alliances_invitations.recruiterid" &_
				" WHERE allianceid=" & AllianceId &_
				" ORDER BY created DESC"
        context['invitations'] = db_results(cursor, query)
        #-----------------------------------------------------------------------
        return context
        #-----------------------------------------------------------------------
    
    #---------------------------------------------------------------------------
    def process_action(self, request, cursor, action):
        #-----------------------------------------------------------------------
        if action == 'create':
            #-------------------------------------------------------------------
            result = db_result(cursor, 'SELECT ua_alliance_invitation_create(' + ')')
            if result == 0: return self.success()
            else: messages.error(request, 'error_' + str(result))
        #-----------------------------------------------------------------------
        return self.failed()
        #-----------------------------------------------------------------------

################################################################################
