# -*- coding: utf-8 -*-

from game.views._base import *

#-------------------------------------------------------------------------------
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

        row = dbRow(query)

        if row == None:
            return HttpResponseRedirect("/")

        # check to unlock holidays mode
        action = request.POST.get("unlock","")

        if action != "" and row[1] < 0:
            dbRow("SELECT user_profile_stop_holidays("+str(self.userId)+")")
            return HttpResponseRedirect("/game/overview/")

        # if remaining time is negative, return to overview page
        if row[2] <= 0:
            return HttpResponseRedirect("/game/overview/")

        content.AssignValue("login", row[0])
        content.AssignValue("remaining_time", row[2])

        # only allow to unlock the account after 2 days of holidays
        if row[1] < 0:
            content.Parse("unlock")
        else:
            content.AssignValue("remaining_time_before_unlock", row[1])
            content.Parse("cant_unlock")

        return render(self.request, content.template, content.data)
