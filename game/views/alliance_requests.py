# -*- coding: utf-8 -*-

from game.views._base import *



################################################################################
class View(ActionView, ExileMixin):
    
    template_name = 'game/alliance_requests.html'
    success_url = '/game/alliance/requests/'

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
            result = db_result(cursor, 'SELECT (' + ')')
            if result == 0: return self.success()
            else: messages.error(request, 'error_' + str(result))
        #-----------------------------------------------------------------------
        elif action == 'accept':
            #-------------------------------------------------------------------
            result = db_result(cursor, 'SELECT (' + ')')
            if result == 0: return self.success()
            else: messages.error(request, 'error_' + str(result))
        #-----------------------------------------------------------------------
        elif action == 'decline':
            #-------------------------------------------------------------------
            result = db_result(cursor, 'SELECT (' + ')')
            if result == 0: return self.success()
            else: messages.error(request, 'error_' + str(result))
        #-----------------------------------------------------------------------
        elif action == 'cancel':
            #-------------------------------------------------------------------
            result = db_result(cursor, 'SELECT (' + ')')
            if result == 0: return self.success()
            else: messages.error(request, 'error_' + str(result))
        #-----------------------------------------------------------------------
        return self.failed()
        #-----------------------------------------------------------------------

################################################################################
