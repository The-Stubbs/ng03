# -*- coding: utf-8 -*-

from game.views._base import *

#-------------------------------------------------------------------------------
class View(View):

    success_url = ""
    template_name = ""
    selected_menu = ""

    #---------------------------------------------------------------------------
    def dispatch(self, request, *args, **kwargs):

        
        return super().dispatch(request, *args, **kwargs)

    #---------------------------------------------------------------------------

    #
    # display page
    #
    def DisplayPage(self):

        content = self.loadTemplate("maintenance")
        content.AssignValue("skin","s_transparent")

        return render(self.request, content.template, content.data)
