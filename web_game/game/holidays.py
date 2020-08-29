# -*- coding: utf-8 -*-

from web_game.game._global import *

class View(GlobalView):

    def dispatch(self, request, *args, **kwargs):

        response = super().pre_dispatch(request, *args, **kwargs)
        if response: return response

        <!--#include virtual="/lib/exile.asp"-->
        <!--#include virtual="/lib/template.asp"-->

        UserId = ToInt(Session("user"), "")

        if self.UserId == "":
            return HttpResponseRedirect("/")

        set content = GetTemplate(self.request, "holidays")

        # retrieve remaining time
        query = "SELECT login," + \
                " (SELECT int4(date_part('epoch', min_end_time-now())) FROM users_holidays WHERE userid=id)," + \
                " (SELECT int4(date_part('epoch', end_time-now())) FROM users_holidays WHERE userid=id)" + \
                " FROM users WHERE privilege=-2 AND id=" + str(self.UserId)

        oRs = oConnExecute(query)

        if oRs == None:
            return HttpResponseRedirect("/")

        # check to unlock holidays mode
        action = request.POST.get("unlock")

        if action != "" and oRs[1] < 0:
            oConnExecute("SELECT sp_stop_holidays("+str(self.UserId)+")", , 128
            return HttpResponseRedirect("/game/overview/")

        # if remaining time is negative, return to overview page
        if oRs[2] <= 0:
            response.redirect "/game/overview.asp"

        content.AssignValue("login", oRs[0]
        content.AssignValue("remaining_time", oRs[2]

        # only allow to unlock the account after 2 days of holidays
        if oRs[1] < 0:
            content.Parse("unlock"
        else:
            content.AssignValue("remaining_time_before_unlock", oRs[1]
            content.Parse("cant_unlock"

        Response.write content.Output

