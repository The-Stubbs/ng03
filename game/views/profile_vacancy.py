# -*- coding: utf-8 -*-

from game.views._base import *



################################################################################
class View(ActionView):
    
    template_name = 'game/profile_vacancy.html'
    success_url = '/game/profile/vacancy/'

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
        if action == 'save':
            #-------------------------------------------------------------------
            result = db_result(cursor, 'SELECT ua_profile_start_holidays(' + ')')
            if result == 0: return self.success()
            else: messages.error(request, 'error_' + str(result))
        #-----------------------------------------------------------------------
        return self.failed()
        #-----------------------------------------------------------------------

################################################################################
