# -*- coding: utf-8 -*-

from game.views._base import *



################################################################################
class View(TemplateView):
    
    template_name = 'game/empire_overview.html'
    
    tab_selected = None
    menu_selected = 'empire_overview'
    submenu_selected = None
    
    #---------------------------------------------------------------------------
    def get_context(self, request, cursor, **kwargs):
        #-----------------------------------------------------------------------
        context = super().get_context(request, cursor, **kwargs)
        #-----------------------------------------------------------------------
        context['profile'] = self.profile
        #-----------------------------------------------------------------------
        return context
        #-----------------------------------------------------------------------

################################################################################
