# -*- coding: utf-8 -*-

from game.views._base import *



################################################################################
class View(ExileMixin, ActionView):
    
    template_name = 'game/commander_overview.html'
    success_url = '/game/commander/overview/'

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
        if action == 'engage':
            #-------------------------------------------------------------------
            result = db_result(cursor, 'SELECT (' + ')')
            if result == 0: return self.success()
            else: messages.error(request, 'error_' + str(result))
        #-----------------------------------------------------------------------
        elif action == 'fire':
            #-------------------------------------------------------------------
            result = db_result(cursor, 'SELECT (' + ')')
            if result == 0: return self.success()
            else: messages.error(request, 'error_' + str(result))
        #-----------------------------------------------------------------------
        elif action == 'rename':
            #-------------------------------------------------------------------
            result = db_result(cursor, 'SELECT (' + ')')
            if result == 0: return self.success()
            else: messages.error(request, 'error_' + str(result))
        #-----------------------------------------------------------------------
        elif action == 'train':
            #-------------------------------------------------------------------
            result = db_result(cursor, 'SELECT (' + ')')
            if result == 0: return self.success()
            else: messages.error(request, 'error_' + str(result))
        #-----------------------------------------------------------------------
        return self.failed()
        #-----------------------------------------------------------------------

################################################################################
