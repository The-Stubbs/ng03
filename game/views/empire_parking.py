# -*- coding: utf-8 -*-

from game.views._base import *



################################################################################
class View(TemplateView):
    
    template_name = 'game/empire_parking.html'
    
    menu_selected = 'empire_fleets'
    submenu_selected = 'empire_parking'

    #---------------------------------------------------------------------------
    def get_context(self, request, cursor, **kwargs):
        #-----------------------------------------------------------------------
        context = super().get_context(request, cursor, **kwargs)
        #-----------------------------------------------------------------------
        #-----------------------------------------------------------------------
        return context
        #-----------------------------------------------------------------------

################################################################################
