# -*- coding: utf-8 -*-

from game.views._base import *

#-------------------------------------------------------------------------------
class View(BaseMixin, View):

    success_url = ""
    template_name = ""
    selected_menu = ""

    #---------------------------------------------------------------------------
    def dispatch(self, request, *args, **kwargs):

        response = super().pre_dispatch(request, *args, **kwargs)
        if response: return response
        
        query = "SELECT login," + \
                " (SELECT int4(date_part('epoch', min_end_time-now())) FROM gm_profile_holidays WHERE userid=id)," + \
                " (SELECT int4(date_part('epoch', end_time-now())) FROM gm_profile_holidays WHERE userid=id)" + \
                " FROM gm_profiles WHERE privilege=-2 AND id=" + str(self.userId)
        self.row = dbRow(query)
        if self.row == None: return HttpResponseRedirect("/")
        if self.row[2] <= 0: return HttpResponseRedirect("/game/overview/")
        
        return super().dispatch(request, *args, **kwargs)

    #---------------------------------------------------------------------------
    def processAction(self, request, action):

        if action == "unlock":
        
            dbRow("SELECT user_profile_stop_holidays(" + str(self.userId) + ")")
            self.successUrl = "/game/overview/"
            return 0

    #---------------------------------------------------------------------------
    def fillContent(self, request, data):
        
        # --- user data
        
        data["login"] = self.row[0]
        data["remaining_time"] = self.row[2]
        data["remaining_time_before_unlock"] = self.row[1]
