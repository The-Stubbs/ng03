# -*- coding: utf-8 -*-

from game.views._base import *



################################################################################
class View(ActionView):
    
    template_name = 'game/empire_fleets.html'
    success_url = '/game/empire/fleets/'
    
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
        if action == 'create':
            #-------------------------------------------------------------------
            result = db_result(cursor, 'SELECT ua_profile_fleet_category_create(' + ')')
            if result == 0: return self.success()
            else: messages.error(request, 'error_' + str(result))
        #-----------------------------------------------------------------------
        elif action == 'rename':
            #-------------------------------------------------------------------
            result = db_result(cursor, 'SELECT ua_profile_fleet_category_rename(' + ')')
            if result == 0: return self.success()
            else: messages.error(request, 'error_' + str(result))
        #-----------------------------------------------------------------------
        elif action == 'delete':
            #-------------------------------------------------------------------
            result = db_result(cursor, 'SELECT ua_profile_fleet_category_delete(' + ')')
            if result == 0: return self.success()
            else: messages.error(request, 'error_' + str(result))
        #-----------------------------------------------------------------------
        return self.failed()
        #-----------------------------------------------------------------------

################################################################################
