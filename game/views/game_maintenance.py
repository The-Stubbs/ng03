# -*- coding: utf-8 -*-

from game.views._base import *

#-------------------------------------------------------------------------------
class View(View):

    def dispatch(self, request, *args, **kwargs):

        #
        # process page
        #

        return self.DisplayPage()

    def sqlValue(self, value):
        if value == None:
            sqlValue = "None"
        else:
            sqlValue = "'" + value + "'"

    #
    # display page
    #
    def DisplayPage(self):

        content = self.loadTemplate("maintenance")
        content.AssignValue("skin","s_transparent")

        return render(self.request, content.template, content.data)
