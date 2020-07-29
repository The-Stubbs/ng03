# -*- coding: utf-8 -*-

from game.views._base import *



################################################################################
class View(TemplateView):
    
    template_name = 'game/alliance_reports.html'
    success_url = '/game/alliance/reports/'
    
    tab_selected = None
    menu_selected = 'alliance'
    submenu_selected = None

    #---------------------------------------------------------------------------
    def get_context(self, request, cursor, **kwargs):
        #-----------------------------------------------------------------------
        context = super().get_context(request, cursor, **kwargs)
        #-----------------------------------------------------------------------
        #-----------------------------------------------------------------------
        return context
        #-----------------------------------------------------------------------

################################################################################
