# -*- coding: utf-8 -*-

from django.contrib import messages
from django.contrib.auth.mixins import LoginRequiredMixin
from django.db import connection
from django.http import HttpResponseRedirect
from django.shortcuts import render
from django.views import View

from misc.functions import *

from game.config import *



################################################################################
class ExileMixin:

    profile = None

    #---------------------------------------------------------------------------
    def dispatch(self, request, *args, **kwargs):
        #-----------------------------------------------------------------------
        if MAINTENANCE: return HttpResponseRedirect('/game/maintenance/')
        #-----------------------------------------------------------------------
        cursor = connection.cursor()
        profile = db_row(cursor, 'SELECT * FROM gm_profiles WHERE user_id=' + str(request.user.id) + ' LIMIT 1')
        if not profile: return HttpResponseRedirect('/game/welcome/')
        #-----------------------------------------------------------------------
        self.profile = profile
        #-----------------------------------------------------------------------
        if self.profile['privilege'] == 'locked': return HttpResponseRedirect('/game/locked/')
        elif self.profile['privilege'] == 'holidays': return HttpResponseRedirect('/game/holidays/')
        elif self.profile['privilege'] == 'new': return HttpResponseRedirect('/game/starting/')
        elif self.profile['bankruptcy'] <= 0: return HttpResponseRedirect('/game/gameover/')
        #-----------------------------------------------------------------------
        planet = db_row(cursor, 'SELECT * FROM gm_planets WHERE profile_id=' + str(self.profile['id']) + ' LIMIT 1')
        if not planet: return HttpResponseRedirect('/game/gameover/')
        #-----------------------------------------------------------------------
        return super().dispatch(request, *args, **kwargs)
        #-----------------------------------------------------------------------
   
################################################################################



################################################################################
class RestView(LoginRequiredMixin, ExileMixin, View):

    #---------------------------------------------------------------------------
    def post(self, request, *args, **kwargs):
        action = request.POST.get('action', '')
        return process_action(request, connection.cursor(), action)
    #---------------------------------------------------------------------------
    
    #---------------------------------------------------------------------------
    def process_action(self, request, cursor, action):
        return None
    #---------------------------------------------------------------------------
    
################################################################################



################################################################################
class TemplateView(LoginRequiredMixin, View):
    
    template_name = None
        
    #---------------------------------------------------------------------------
    def get(self, request, *args, **kwargs):
        context = self.get_context(request, connection.cursor(), **kwargs)
        return render(request, self.template_name, context)
    #---------------------------------------------------------------------------

    #---------------------------------------------------------------------------
    def get_context(self, request, cursor, **kwargs):
        kwargs.setdefault('view', self)
        return kwargs
    #---------------------------------------------------------------------------
    
################################################################################



################################################################################
class ActionView(TemplateView):
    
    success_url = None
    
    #---------------------------------------------------------------------------
    def post(self, request, *args, **kwargs):
        action = request.POST.get('action', '')
        return self.process_action(request, connection.cursor(), action)
    #---------------------------------------------------------------------------
    
    #---------------------------------------------------------------------------
    def process_action(self, request, cursor, action):
        return self.failed()
    #---------------------------------------------------------------------------
    
    #---------------------------------------------------------------------------
    def success(self):
        return HttpResponseRedirect(self.success_url)
    #---------------------------------------------------------------------------
    
    #---------------------------------------------------------------------------
    def failed(self, request, cursor, **kwargs):
        context = self.get_context(request, cursor, **kwargs)
        return render(request, self.template_name, context)
    #---------------------------------------------------------------------------

################################################################################
