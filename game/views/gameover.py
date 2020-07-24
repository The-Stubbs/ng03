# -*- coding: utf-8 -*-

from game.views._base import *



################################################################################
class View(LoginRequiredMixin, View):
    
    template_name = 'game/gameover.html'
    success_url = '/game/gameover/'

    #---------------------------------------------------------------------------
    def dispatch(self, request, *args, **kwargs):
        #-----------------------------------------------------------------------
        if MAINTENANCE: return HttpResponseRedirect('/game/maintenance/')
        #-----------------------------------------------------------------------
        cursor = connection.cursor()
        profile = db_row(cursor, 'SELECT * FROM gm_profiles WHERE user_id=' + str(request.user.id) + ' LIMIT 1')
        if not profile: return HttpResponseRedirect('/game/welcome/')
        #-----------------------------------------------------------------------
        self.profile = profile
        #-----------------------------------------------------------------------
        planet = db_row(cursor, 'SELECT * FROM gm_planets WHERE profile_id=' + str(self.profile['id']) + ' LIMIT 1')
        if self.profile['bankruptcy'] > 0 and planet: return HttpResponseRedirect('/game/')
        #-----------------------------------------------------------------------
        return super().dispatch(request, *args, **kwargs)
        #-----------------------------------------------------------------------
 
    #---------------------------------------------------------------------------
    def get(self, request, *args, **kwargs):
        context = {}
        return render(request, self.template_name, context)
    #---------------------------------------------------------------------------
    
    #---------------------------------------------------------------------------
    def post(self, request, *args, **kwargs):
        #-----------------------------------------------------------------------
        if action == 'reset':
            #-------------------------------------------------------------------
            result = db_result(cursor, 'SELECT (' + ')')
            if result == 0: return HttpResponseRedirect(self.success_url)
            else: messages.error(request, 'error_' + str(result))
        #-----------------------------------------------------------------------
        elif action == 'delete':
            #-------------------------------------------------------------------
            result = db_result(cursor, 'SELECT (' + ')')
            if result == 0: return HttpResponseRedirect(self.success_url)
            else: messages.error(request, 'error_' + str(result))
        #-----------------------------------------------------------------------
        context = {}
        return render(request, self.template_name, context)
        #-----------------------------------------------------------------------

################################################################################
