# -*- coding: utf-8 -*-

from game.views._base import *

#-------------------------------------------------------------------------------
class View(BaseView):

    #---------------------------------------------------------------------------
    def dispatch(self, request, *args, **kwargs):
        
        response = super().pre_dispatch(request, *args, **kwargs)
        if response: return response
        
        return super().dispatch(request, *args, **kwargs)

    #---------------------------------------------------------------------------
    def get(self, request, *args, **kwargs):
    
        row = dbRow('SELECT id, lastplanetid, privilege, resets FROM internal_profile_connect(' + str(request.user.id) + ')');

        if row[2] == -3: return HttpResponseRedirect("/game/wait/")
        elif row[2] == -2: return HttpResponseRedirect("/game/holidays/")
        elif row[2] < 100 and row[3] == 0: return HttpResponseRedirect("/game/start/")
        else: return HttpResponseRedirect("/game/overview/")
