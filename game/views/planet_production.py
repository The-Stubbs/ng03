# -*- coding: utf-8 -*-

from game.views._base import *



################################################################################
class View(TemplateView):
    
    template_name = 'game/planet_production.html'
    
    tab_selected = None
    menu_selected = 'planet_production'

    #---------------------------------------------------------------------------
    def get_context(self, request, cursor, **kwargs):
        #-----------------------------------------------------------------------
        context = super().get_context(request, cursor, **kwargs)
        context = self.fill_header_planet(context, request, cursor)
        #-----------------------------------------------------------------------
        #-----------------------------------------------------------------------
        return context
        #-----------------------------------------------------------------------

################################################################################
