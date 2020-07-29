# -*- coding: utf-8 -*-

from game.views._base import *



################################################################################
class View(ActionView):
    
    template_name = 'game/mercenary_spying.html'
    success_url = '/game/mercenary/spying/'
    
    menu_selected = 'mercenary_spying'

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
        if action == 'spy_user':
            #-------------------------------------------------------------------
            result = db_result(cursor, 'SELECT ua_spying_create(' + ')')
            if result == 0: return self.success()
            else: messages.error(request, 'error_' + str(result))
        #-----------------------------------------------------------------------
        elif action == 'spy_planet':
            #-------------------------------------------------------------------
            result = db_result(cursor, 'SELECT ua_spying_create(' + ')')
            if result == 0: return self.success()
            else: messages.error(request, 'error_' + str(result))
        #-----------------------------------------------------------------------
        return self.failed()
        #-----------------------------------------------------------------------

################################################################################
