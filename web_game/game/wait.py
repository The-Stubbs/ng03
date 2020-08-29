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

        set content = GetTemplate(self.request, "wait")

        # retrieve remaining time
        query = "SELECT login, COALESCE(date_part('epoch', ban_expire-now()), 0) AS remaining_time FROM users WHERE /*privilege=-3 AND*/ id=" + str(self.UserId)

        oRs = oConnExecute(query)

        if oRs == None:
            return HttpResponseRedirect("/")

        # check to unlock holidays mode
        action = request.POST.get("unlock")

        if action != "" and remainingTime < 0:
            oConnDoQuery("UPDATE users SET privilege=0 WHERE ban_expire < now() AND id="+UserId, , 128
            return HttpResponseRedirect("/game/start/")

        content.AssignValue("login", oRs[0]
        content.AssignValue("remaining_time_before_unlock", int(oRs[1])

        if remainingTime < 0:
            content.Parse("unlock"
        else:
            content.Parse("cant_unlock"

        Response.write content.Output

