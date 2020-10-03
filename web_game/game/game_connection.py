# -*- coding: utf-8 -*-

from django.contrib.auth.mixins import LoginRequiredMixin
from django.http import HttpResponseRedirect
from django.views import View

from web_game.lib.exile import *
from web_game.lib.sql import *



class View(LoginRequiredMixin, MaintenanceMixin, View):

    def dispatch(self, request, *args, **kwargs):
        
        response = super().pre_dispatch(request, *args, **kwargs)
        if response: return response
            
        return super().dispatch(request, *args, **kwargs)



    def get(self, request, *args, **kwargs):
    
        if request.user.is_authenticated:

            oConnDoQuery('UPDATE users SET login=' + dosql(request.user.username) + ' WHERE login IS NULL AND id=' + str(request.user.id))
            
            row = oConnRow('SELECT privilege, resets FROM sp_account_connect(' + str(request.user.id) + ', 1036,' + dosql(request.META.get('REMOTE_ADDR', '')) + ',NULL,' + dosql(request.META.get('HTTP_USER_AGENT', '')) + ',0)');
            
            if row['privilege'] == -3 :
                return HttpResponseRedirect("/game/waiting/")
                
            elif row['privilege'] == -2:
                return HttpResponseRedirect("/game/holidays/")
                
            elif row['privilege'] == 100 and row['resets'] == 0:
                return HttpResponseRedirect("/game/starting/")

            return HttpResponseRedirect("/game/empire_view/")
            
        return HttpResponseRedirect(urlNexus)
