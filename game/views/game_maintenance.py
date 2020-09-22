# -*- coding: utf-8 -*-

from game.views._base import *

#-------------------------------------------------------------------------------
class View(View):

    #---------------------------------------------------------------------------
    def get(self, request, *args, **kwargs):

        data["skin"] = "s_transparent"

        return render(request, "maintenance.html", data)
