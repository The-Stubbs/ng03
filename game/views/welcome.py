# -*- coding: utf-8 -*-

from game.views._base import *



################################################################################
class View(ActionView):
    
    template_name = 'game/welcome.html'
    success_url = '/game/starting/'

    #---------------------------------------------------------------------------
    def dispatch(self, request, *args, **kwargs):
        #-----------------------------------------------------------------------
        if MAINTENANCE: return HttpResponseRedirect('/game/maintenance/')
        if not REGISTRATION: return HttpResponseRedirect('/game/closed/')
        #-----------------------------------------------------------------------
        cursor = connection.cursor()
        profile = db_row(cursor, 'SELECT * FROM gm_profiles WHERE user_id=' + str(request.user.id) + ' LIMIT 1')
        if profile: return HttpResponseRedirect('/game/')
        #-----------------------------------------------------------------------
        return super().dispatch(request, *args, **kwargs)
        #-----------------------------------------------------------------------

    #---------------------------------------------------------------------------
    def get_context(self, request, cursor, **kwargs):
        #-----------------------------------------------------------------------
        context = super().get_context(request, cursor, **kwargs)
        return context
        #-----------------------------------------------------------------------
    
    #---------------------------------------------------------------------------
    def process_action(self, request, cursor, action):
        #-----------------------------------------------------------------------
        if action == 'create':
            #-------------------------------------------------------------------
            result = db_result(cursor, 'SELECT ua_profile_create(' + str(request.user.id) + ',' + sql_str(request.META.get('REMOTE_ADDR')) + ',' + sql_str(request.META.get('HTTP_USER_AGENT')) + ')')
            if result == 0: return self.success(request)
            else: messages.error(request, 'profile_create_error' + str(result))
        #-----------------------------------------------------------------------
        return self.failed(request, cursor)
        #-----------------------------------------------------------------------

################################################################################
