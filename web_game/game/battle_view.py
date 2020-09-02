# -*- coding: utf-8 -*-

from django.http import HttpResponseRedirect
from django.shortcuts import render
from django.views import View

from web_game.lib.exile import *
from web_game.lib.template import *

class View(ExileMixin, View):

    def dispatch(self, request, *args, **kwargs):

        response = super().pre_dispatch(request, *args, **kwargs)
        if response: return response
        
        tpl_layout = GetTemplate(self.request, "layout")
        
        tpl_layout.AssignValue("skin", "s_transparent")
        tpl_layout.AssignValue("timers_enabled", "false")
        tpl_layout.AssignValue("server", universe)
        
        return render(self.request, tpl_layout.template, tpl_layout.data)
