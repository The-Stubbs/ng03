# -*- coding: utf-8 -*-

from game.views._base import *



################################################################################
class View(TemplateView, ExileMixin):
    
    template_name = 'game/report_spying.html'

    #---------------------------------------------------------------------------
    def get_context(self, request, cursor, **kwargs):
        #-----------------------------------------------------------------------
        context = super().get_context(request, cursor, **kwargs)
        #-----------------------------------------------------------------------
        #-----------------------------------------------------------------------
        return context
        #-----------------------------------------------------------------------

################################################################################
