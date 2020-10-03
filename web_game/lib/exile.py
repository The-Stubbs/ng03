# -*- coding: utf-8 -*-

from django.http import HttpResponseRedirect

from web_game.lib.config import *
from web_game.lib.sql import *

class MaintenanceMixin:

    def pre_dispatch(self, request, *args, **kwargs):

        if maintenance and not request.user.is_superuser:
            return HttpResponseRedirect('/game/maintenance/')
            
        connectDB()
