# -*- coding: utf-8 -*-

from game.views._base import *

class View(BaseView):

    def dispatch(self, request, *args, **kwargs):
        
        response = super().pre_dispatch(request, *args, **kwargs)
        if response: return response
        
        return super().dispatch(request, *args, **kwargs)

    def get(self, request, *args, **kwargs):
    
        self.ipaddress = request.META.get("REMOTE_ADDR", "")
        self.forwardedfor = request.META.get("HTTP_X_FORWARDED_FOR", "")
        self.useragent = request.META.get("HTTP_USER_AGENT", "")
        
        rs = dbRow('SELECT id, lastplanetid, privilege, resets FROM internal_profile_connect(' + str(request.user.id) + ', 1036,' + sqlStr(self.ipaddress) + ',' + sqlStr(self.forwardedfor) + ',' + sqlStr(self.useragent) + ',0)');

        request.session[sPlanet] = rs[1]
        request.session[sPrivilege] = rs[2]
        
        if not request.session.get("isplaying"):
            request.session["isplaying"] = True

        dbExecute('UPDATE gm_profiles SET login=' + sqlStr(request.user.username) + ' WHERE id=' + str(rs[0]))
        
        if(rs[2] == -3):
            return HttpResponseRedirect("/game/wait/")
        elif(rs[2] == -2):
            return HttpResponseRedirect("/game/holidays/")
        elif(rs[2] < 100 and rs[3] == 0):
            return HttpResponseRedirect("/game/start/")
        else:
            return HttpResponseRedirect("/game/overview/")
