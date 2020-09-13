# -*- coding: utf-8 -*-

import time

from django.http import HttpResponseRedirect

from game.lib.config import *
from game.lib.sql import *
from game.lib.functions import *

class ExileMixin(BaseMixin):

    browserid = ""

    def pre_dispatch(self, request, *args, **kwargs):
        
        response = super().pre_dispatch(request, *args, **kwargs)
        if response: return response

        self.StartTime = time.clock()
        self.scripturl = request.META.get("SCRIPT_NAME") + "?" + request.META.get("QUERY_STRING")
        
        if not maintenance:
            connectDB()
        else:
            return HttpResponseRedirect('/game/maintenance/')
        
        if self.SessionEnabled:
            # retrieve/assign lcid
            if self.lang == "": self.lang = request.COOKIES.get("lcid", "")
            
            if self.lang == "1036":
                request.session['LCID'] = 1036
            elif self.lang == "1033":
                request.session['LCID'] = 1033
                
            self.browserid = ToInt(request.COOKIES.get("id"), "")
        
            request.COOKIES["lcid"] = request.session.get('LCID')

            if self.browserid == "":
                reqRs = oConnExecute("SELECT nextval('stats_requests')")

                self.browserid = int(reqRs[0])
                request.COOKIES["id"] = self.browserid

        '''
        Response.Expires = -60
        Response.Expiresabsolute = Now() - 2
        Response.AddHeader "pragma","no-cache"
        Response.AddHeader "cache-control","private"
        Response.CacheControl = "no-cache"
        '''
