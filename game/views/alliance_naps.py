# -*- coding: utf-8 -*-

from game.views._base import *



################################################################################
class View(ActionView):
    
    template_name = 'game/alliance_naps.html'
    success_url = '/game/alliance/naps/'

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
            result = db_result(cursor, 'SELECT ua_alliance_nap_request_create(' + ')')
            if result == 0: return self.success()
            else: messages.error(request, 'error_' + str(result))
        #-----------------------------------------------------------------------
        elif action == 'accept':
            #-------------------------------------------------------------------
            result = db_result(cursor, 'SELECT ua_alliance_nap_request_accept(' + ')')
            if result == 0: return self.success()
            else: messages.error(request, 'error_' + str(result))
        #-----------------------------------------------------------------------
        elif action == 'decline':
            #-------------------------------------------------------------------
            result = db_result(cursor, 'SELECT ua_alliance_nap_request_decline(' + ')')
            if result == 0: return self.success()
            else: messages.error(request, 'error_' + str(result))
        #-----------------------------------------------------------------------
        elif action == 'cancel':
            #-------------------------------------------------------------------
            result = db_result(cursor, 'SELECT ua_alliance_nap_request_cancel(' + ')')
            if result == 0: return self.success()
            else: messages.error(request, 'error_' + str(result))
        #-----------------------------------------------------------------------
        elif action == 'toggle_location':
            #-------------------------------------------------------------------
            result = db_result(cursor, 'SELECT ua_alliance_nap_toggle_location(' + ')')
            if result == 0: return self.success()
            else: messages.error(request, 'error_' + str(result))
        #-----------------------------------------------------------------------
        elif action == 'toggle_radar':
            #-------------------------------------------------------------------
            result = db_result(cursor, 'SELECT ua_alliance_nap_toggle_radar(' + ')')
            if result == 0: return self.success()
            else: messages.error(request, 'error_' + str(result))
        #-----------------------------------------------------------------------
        elif action == 'break':
            #-------------------------------------------------------------------
            result = db_result(cursor, 'SELECT ua_alliance_nap_break(' + ')')
            if result == 0: return self.success()
            else: messages.error(request, 'error_' + str(result))
        #-----------------------------------------------------------------------
        return self.failed()
        #-----------------------------------------------------------------------

################################################################################
