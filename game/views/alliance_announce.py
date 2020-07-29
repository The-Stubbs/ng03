# -*- coding: utf-8 -*-

from game.views._base import *



################################################################################
class View(ActionView):
    
    template_name = 'game/alliance_announce.html'
    success_url = '/game/alliance/announce/'
    
    tab_selected = None
    menu_selected = 'alliance'
    submenu_selected = 'alliance_overview'

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
            result = db_result(cursor, 'SELECT ua_alliance_update_announce(' + ')')
            if result == 0: return self.success()
            else: messages.error(request, 'error_' + str(result))
        #-----------------------------------------------------------------------
        return self.failed()
        #-----------------------------------------------------------------------

################################################################################
