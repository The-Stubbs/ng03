# -*- coding: utf-8 -*-

from game.views._base import *



################################################################################
class View(ActionView):
    
    template_name = 'game/planet_overview.html'
    success_url = '/game/planet/overview/'

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
        if action == 'assign':
            #-------------------------------------------------------------------
            result = db_result(cursor, 'SELECT ua_planet_assign_commander(' + ')')
            if result == 0: return self.success()
            else: messages.error(request, 'error_' + str(result))
        #-----------------------------------------------------------------------
        elif action == 'rename':
            #-------------------------------------------------------------------
            result = db_result(cursor, 'SELECT ua_planet_rename(' + ')')
            if result == 0: return self.success()
            else: messages.error(request, 'error_' + str(result))
        #-----------------------------------------------------------------------
        elif action == 'leave':
            #-------------------------------------------------------------------
            result = db_result(cursor, 'SELECT ua_planet_leave(' + ')')
            if result == 0: return self.success()
            else: messages.error(request, 'error_' + str(result))
        #-----------------------------------------------------------------------
        elif action == 'fire':
            #-------------------------------------------------------------------
            result = db_result(cursor, 'SELECT ua_planet_fire_people(' + ')')
            if result == 0: return self.success()
            else: messages.error(request, 'error_' + str(result))
        #-----------------------------------------------------------------------
        elif action == 'update':
            #-------------------------------------------------------------------
            result = db_result(cursor, 'SELECT ua_planet_update_resource_prices(' + ')')
            if result == 0: return self.success()
            else: messages.error(request, 'error_' + str(result))
        #-----------------------------------------------------------------------
        elif action == 'toggle':
            #-------------------------------------------------------------------
            result = db_result(cursor, 'SELECT ua_planet_toggle_worker_growing(' + ')')
            if result == 0: return self.success()
            else: messages.error(request, 'error_' + str(result))
        #-----------------------------------------------------------------------
        return self.failed()
        #-----------------------------------------------------------------------

################################################################################
