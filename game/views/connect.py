# -*- coding: utf-8 -*-

from game.views._base import *

class View(LoginRequiredMixin, ExileMixin, View):

    def dispatch(self, request, *args, **kwargs):
        
        response = super().pre_dispatch(request, *args, **kwargs)
        if response: return response
        
        return super().dispatch(request, *args, **kwargs)

    def get(self, request, *args, **kwargs):
    
        if request.user.is_authenticated:

            self.ipaddress = request.META.get("REMOTE_ADDR", "")
            self.forwardedfor = request.META.get("HTTP_X_FORWARDED_FOR", "")
            self.useragent = request.META.get("HTTP_USER_AGENT", "")
            
            rs = oConnExecute('SELECT id, lastplanetid, privilege, resets FROM internal_profile_connect(' + str(request.user.id) + ', 1036,' + dosql(self.ipaddress) + ',' + dosql(self.forwardedfor) + ',' + dosql(self.useragent) + ',0)');

            request.session[sUser] = rs[0]
            request.session[sPlanet] = rs[1]
            request.session[sPrivilege] = rs[2]
            request.session[sLogonUserID] = rs[0]
            
            if not request.session.get("isplaying"):
                request.session["isplaying"] = True

            oConnDoQuery('UPDATE gm_profiles SET login=' + dosql(request.user.username) + ' WHERE id=' + str(rs[0]))
            
            if(rs[2] == -3):
                return HttpResponseRedirect("/game/wait/")
            elif(rs[2] == -2):
                return HttpResponseRedirect("/game/holidays/")
            elif(rs[2] < 100 and rs[3] == 0):
                return HttpResponseRedirect("/game/start/")
            else:
                return HttpResponseRedirect("/game/overview/")
                
        return HttpResponseRedirect(urlNexus)
