# -*- coding: utf-8 -*-

from game.views._base import *



################################################################################
class View(LoginRequiredMixin, View):
    
    template_name = 'game/gameover.html'
    success_url = '/game/empire/overview/'

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
            name = request.POST.get('name', '')
            galaxy_id = get_int(request.POST.get('galaxy_id', 0))
            #-------------------------------------------------------------------
            result = db_result(cursor, 'SELECT ua_profile_rename(' + str(self.profile['id']) + ',' + sql_str(name) + ')')
            if result != 0: messages.error(request, 'profile_rename_error' + str(result))
            else:
                #-------------------------------------------------------------------
                result = db_result(cursor, 'SELECT ua_profile_reset(' + str(self.profile['id']) + ',' + str(galaxy_id) ')')
                if result == 0: return HttpResponseRedirect(self.success_url)
                else: messages.error(request, 'profile_reset_error' + str(result))
        #-----------------------------------------------------------------------
        elif action == 'delete':
            #-------------------------------------------------------------------
            result = db_result(cursor, 'SELECT ua_profile_delete(' + str(self.profile['id']) + ')')
            if result == 0: return HttpResponseRedirect(self.success_url)
            else: messages.error(request, 'profile_delete_error' + str(result))
        #-----------------------------------------------------------------------
        context = {}
        return render(request, self.template_name, context)
        #-----------------------------------------------------------------------

################################################################################
