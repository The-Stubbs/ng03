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
    def dispatch(self, request, *args, **kwargs):
        #-----------------------------------------------------------------------
        if not self.profile['alliance_id']: return HttpResponseRedirect('/game/empire/overview/')
        #-----------------------------------------------------------------------
        return super().dispatch(request, *args, **kwargs)
        #-----------------------------------------------------------------------

    #---------------------------------------------------------------------------
    def get_context(self, request, cursor, **kwargs):
        #-----------------------------------------------------------------------
        context = super().get_context(request, cursor, **kwargs)
        #-----------------------------------------------------------------------
        context['data'] = db_result(cursor, 'SELECT announce, defcon FROM gm_alliances WHERE id=' + str(self.profile['alliance_id']))
        #-----------------------------------------------------------------------
        return context
        #-----------------------------------------------------------------------
    
    #---------------------------------------------------------------------------
    def process_action(self, request, cursor, action):
        #-----------------------------------------------------------------------
        if action == 'save':
            #-------------------------------------------------------------------
            motd = request.POST.get('motd').strip()
            defcon = get_int(request.POST.get('defcon', 5))
            #-------------------------------------------------------------------
            db_execute(cursor, 'UPDATE gm_alliances SET defcon=' + str('defcon') + ', announce=' + sql_str(motd) + ' WHERE id= ' + str(self.profile['alliance_id']))
            return self.success()
        #-----------------------------------------------------------------------
        return self.failed()
        #-----------------------------------------------------------------------

################################################################################
