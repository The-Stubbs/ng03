# -*- coding: utf-8 -*-

from game.views._base import *

class View(BaseMixin, View):

    def dispatch(self, request, *args, **kwargs):

        response = super().pre_dispatch(request, *args, **kwargs)
        if response: return response

        self.userId = ToInt(self.request.session.get("user"), "")

        if self.userId == "":
            return HttpResponseRedirect("/")

        content = self.loadTemplate("holidays")

        # retrieve remaining time
        query = "SELECT login," + \
                " (SELECT int4(date_part('epoch', min_end_time-now())) FROM gm_profile_holidays WHERE userid=id)," + \
                " (SELECT int4(date_part('epoch', end_time-now())) FROM gm_profile_holidays WHERE userid=id)" + \
                " FROM gm_profiles WHERE privilege=-2 AND id=" + str(self.userId)

        oRs = dbRow(query)

        if oRs == None:
            return HttpResponseRedirect("/")

        # check to unlock holidays mode
        action = request.POST.get("unlock", "")

        if action != "" and oRs[1] < 0:
            dbRow("SELECT user_profile_stop_holidays("+str(self.userId)+")")
            return HttpResponseRedirect("/game/overview/")

        # if remaining time is negative, return to overview page
        if oRs[2] <= 0:
            return HttpResponseRedirect("/game/overview/")

        content.AssignValue("login", oRs[0])
        content.AssignValue("remaining_time", oRs[2])

        # only allow to unlock the account after 2 days of holidays
        if oRs[1] < 0:
            content.Parse("unlock")
        else:
            content.AssignValue("remaining_time_before_unlock", oRs[1])
            content.Parse("cant_unlock")

        return render(self.request, content.template, content.data)
