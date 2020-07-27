# -*- coding: utf-8 -*-

from game.views._base import *



################################################################################
class View(LoginRequiredMixin, View):
    
    template_name = 'game/starting.html'
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
        if self.profile['privilege'] != 'new': return HttpResponseRedirect('/game/')
        if self.profile['reset_count'] != 0: return HttpResponseRedirect('/game/')
        #-----------------------------------------------------------------------
        return super().dispatch(request, *args, **kwargs)
        #-----------------------------------------------------------------------

    #---------------------------------------------------------------------------
    def get(self, request, *args, **kwargs):
        #------------------------------------------------------------------------
        cursor = connection.cursor()
        context = {}
        #------------------------------------------------------------------------
        context['galaxies'] = db_rows(cursor, 'SELECT * FROM vw_starting_galaxies')
        context['orientations'] = db_rows(cursor, 'SELECT * FROM vw_starting_orientations')
        #------------------------------------------------------------------------
        return render(request, self.template_name, context)
        #------------------------------------------------------------------------
    
    #---------------------------------------------------------------------------
    def post(self, request, *args, **kwargs):
        #-----------------------------------------------------------------------
        cursor = connection.cursor()
        action = request.POST.get('action', '')
        #-----------------------------------------------------------------------
        if action == 'start':
            #-------------------------------------------------------------------
            name = request.POST.get('name', '')
            galaxy_id = get_int(request.POST.get('galaxy_id', 0))
            orientation = get_int(request.POST.get('orientation', 0))
            #-------------------------------------------------------------------
            result = db_result(cursor, 'SELECT ua_profile_init(' + str(self.profile['id']) + ',' + sql_str(name) + ',' + str(orientation) + ')')
            if result != 0: messages.error(request, 'profile_init_error' + str(result))
            else:
                #-------------------------------------------------------------------
                result = db_result(cursor, 'SELECT ua_profile_reset(' + str(self.profile['id']) + ',' + str(galaxy_id) + ')')
                if result == 0: return HttpResponseRedirect(self.success_url)
                else: messages.error(request, 'profile_reset_error' + str(result))
        #-----------------------------------------------------------------------
        context = {}
        return render(request, self.template_name, context)
        #-----------------------------------------------------------------------

################################################################################
