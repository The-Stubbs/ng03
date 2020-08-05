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
        planet = db_row(cursor, 'SELECT * FROM gm_planets WHERE floor > 0 AND space > 0 AND profile_id=' + str(self.profile['id']) + ' LIMIT 1')
        if not planet: return HttpResponseRedirect('/game/gameover/')
        #-----------------------------------------------------------------------
        if not self.profile['last_planet_id']:
            db_execute(cursor, 'UPDATE gm_profiles SET last_planet_id=' + str(planet['id']) + ' WHERE id=' + str(self.profile['id']))
            self.profile['last_planet_id'] = planet['id']
        #-----------------------------------------------------------------------
        db_execute(cursor, 'UPDATE gm_profiles SET last_activity_date=now() WHERE id=' + str(self.profile['id']))
        #-----------------------------------------------------------------------
        if self.profile['alliance_rank_id']:
            self.alliance_rights = db_row(cursor, 'SELECT * FROM gm_alliance_ranks WHERE id=' + str(self.profile['alliance_rank_id']))
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
class TemplateView(LoginRequiredMixin, ExileMixin, View):
    
    template_name = None
    
    tab_selected = None
    menu_selected = None
    submenu_selected = None

    #---------------------------------------------------------------------------
    def get(self, request, *args, **kwargs):
        #-----------------------------------------------------------------------
        planet_id = get_int(request.POST.get('planet_id', 0))
        if planet_id != 0 and planet_id != self.profile['last_planet_id'] and not request.user.is_impersonate:
            planet = db_row(cursor, 'SELECT * FROM gm_planets WHERE floor > 0 AND space > 0 AND profile_id=' + str(self.profile['id']) + ' AND id=' + str(planet_id) + 'LIMIT 1')
            if planet:
                db_execute(cursor, 'UPDATE gm_profiles SET last_planet_id=' + str(planet['id']) + ' WHERE id=' + str(self.profile['id']))
                self.profile['last_planet_id'] = planet['id']
        #-----------------------------------------------------------------------
        context = self.get_context(request, connection.cursor(), **kwargs)
        return render(request, self.template_name, context)
        #-----------------------------------------------------------------------

    #---------------------------------------------------------------------------
    def get_context(self, request, cursor, **kwargs):
        #-----------------------------------------------------------------------
        kwargs.setdefault('view', self)
        context = kwargs
        #-----------------------------------------------------------------------
        if self.tab_selected: context['tab_selected'] = self.tab_selected
        if self.menu_selected: context['menu_selected'] = self.menu_selected
        if self.submenu_selected: context['submenu_selected'] = self.submenu_selected
        #-----------------------------------------------------------------------
        context['profile'] = db_row(cursor, 'SELECT * FROM vw_layout_profile WHERE id=' + str(self.profile['id']))
        #-----------------------------------------------------------------------
        return context
        #-----------------------------------------------------------------------

    #---------------------------------------------------------------------------
    def fill_header_planet(self, context, request, cursor):
        #-----------------------------------------------------------------------
        context['header'] = db_row(cursor, 'SELECT * FROM vw_header_planet WHERE id=' + str(self.profile['last_planet_id']))
        context['header']['planets'] = db_rows(cursor, 'SELECT * FROM vw_header_planets WHERE profile_id=' + str(self.profile['id']))
        #-----------------------------------------------------------------------
        return context
        #-----------------------------------------------------------------------
        
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
    def do_action(self, action, cursor, query):
        result = db_result(cursor, query)
        db_execute(cursor, 'INSERT INTO log_actions(profile_id, action, result) VALUES(' + str(self.profile['id']) + ',' + str(action) + ',' + str(result) + ')')
        return result
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
