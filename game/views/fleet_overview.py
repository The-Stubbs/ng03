# -*- coding: utf-8 -*-

from game.views._base import *



################################################################################
class View(ActionView):
    
    template_name = 'game/fleet_overview.html'
    success_url = '/game/fleet/overview/'
    
    tab_selected = None
    menu_selected = None
    submenu_selected = None

    #---------------------------------------------------------------------------
    def get_context(self, request, cursor, **kwargs):
        #-----------------------------------------------------------------------
        context = super().get_context(request, cursor, **kwargs)
        #-----------------------------------------------------------------------
        #-----------------------------------------------------------------------
        return context
        #-----------------------------------------------------------------------
    
    #---------------------------------------------------------------------------
    def process_action(self, request, cursor, action):
        #-----------------------------------------------------------------------
        if action == 'invade':
            #-------------------------------------------------------------------
            result = db_result(cursor, 'SELECT ua_profile_fleet_invade_planet(' + ')')
            if result == 0: return self.success()
            else: messages.error(request, 'error_' + str(result))
        #-----------------------------------------------------------------------
        elif action == 'rename':
            #-------------------------------------------------------------------
            result = db_result(cursor, 'SELECT ua_profile_fleet_rename(' + ')')
            if result == 0: return self.success()
            else: messages.error(request, 'error_' + str(result))
        #-----------------------------------------------------------------------
        elif action == 'assign':
            #-------------------------------------------------------------------
            result = db_result(cursor, 'SELECT ua_profile_fleet_assign_commander(' + ')')
            if result == 0: return self.success()
            else: messages.error(request, 'error_' + str(result))
        #-----------------------------------------------------------------------
        elif action == 'move':
            #-------------------------------------------------------------------
            result = db_result(cursor, 'SELECT ua_profile_fleet_start_moving(' + ')')
            if result == 0: return self.success()
            else: messages.error(request, 'error_' + str(result))
        #-----------------------------------------------------------------------
        elif action == 'share':
            #-------------------------------------------------------------------
            result = db_result(cursor, 'SELECT ua_profile_fleet_toggle_sharing(' + ')')
            if result == 0: return self.success()
            else: messages.error(request, 'error_' + str(result))
        #-----------------------------------------------------------------------
        elif action == 'leave':
            #-------------------------------------------------------------------
            result = db_result(cursor, 'SELECT ua_profile_fleet_leave(' + ')')
            if result == 0: return self.success()
            else: messages.error(request, 'error_' + str(result))
        #-----------------------------------------------------------------------
        elif action == 'toggle':
            #-------------------------------------------------------------------
            result = db_result(cursor, 'SELECT ua_profile_fleet_toggle_stance(' + ')')
            if result == 0: return self.success()
            else: messages.error(request, 'error_' + str(result))
        #-----------------------------------------------------------------------
        elif action == 'recycle':
            #-------------------------------------------------------------------
            result = db_result(cursor, 'SELECT ua_profile_fleet_start_recycling(' + ')')
            if result == 0: return self.success()
            else: messages.error(request, 'error_' + str(result))
        #-----------------------------------------------------------------------
        elif action == 'stop':
            #-------------------------------------------------------------------
            result = db_result(cursor, 'SELECT ua_profile_fleet_stop_recycling(' + ')')
            if result == 0: return self.success()
            else: messages.error(request, 'error_' + str(result))
        #-----------------------------------------------------------------------
        elif action == 'merge':
            #-------------------------------------------------------------------
            result = db_result(cursor, 'SELECT ua_profile_fleet_merge(' + ')')
            if result == 0: return self.success()
            else: messages.error(request, 'error_' + str(result))
        #-----------------------------------------------------------------------
        elif action == 'return':
            #-------------------------------------------------------------------
            result = db_result(cursor, 'SELECT ua_profile_fleet_stop_moving(' + ')')
            if result == 0: return self.success()
            else: messages.error(request, 'error_' + str(result))
        #-----------------------------------------------------------------------
        elif action == 'deploy':
            #-------------------------------------------------------------------
            result = db_result(cursor, 'SELECT ua_profile_fleet_deploy_ship(' + ')')
            if result == 0: return self.success()
            else: messages.error(request, 'error_' + str(result))
        #-----------------------------------------------------------------------
        elif action == 'warp':
            #-------------------------------------------------------------------
            result = db_result(cursor, 'SELECT ua_profile_fleet_warp(' + ')')
            if result == 0: return self.success()
            else: messages.error(request, 'error_' + str(result))
        #-----------------------------------------------------------------------
        elif action == 'transfer':
            #-------------------------------------------------------------------
            result = db_result(cursor, 'SELECT ua_profile_fleet_transfer_ressources(' + ')')
            if result == 0: return self.success()
            else: messages.error(request, 'error_' + str(result))
        #-----------------------------------------------------------------------
        return self.failed()
        #-----------------------------------------------------------------------

################################################################################
