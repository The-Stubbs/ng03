# -*- coding: utf-8 -*-

from web_game.game._global import *

class View(GlobalView):

    def dispatch(self, request, *args, **kwargs):

        response = super().pre_dispatch(request, *args, **kwargs)
        if response: return response

        <!--#include virtual="/lib/config.asp"-->
        <!--#include virtual="/lib/template.asp"-->

        #
        # process page
        #

        DisplayPage

    def sqlValue(self, value):
        if value == None:
            sqlValue = "None"
        else:
            sqlValue = "'" + value + "'"

    #
    # display page
    #
    def DisplayPage(self):

        content = GetTemplate(self.request, "maintenance")
        content.AssignValue("skin", "s_transparent"

        Response.write content.Output

