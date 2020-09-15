# -*- coding: utf-8 -*-

from game.views._base import *

class View(ExileMixin, View):

    def dispatch(self, request, *args, **kwargs):

        response = super().pre_dispatch(request, *args, **kwargs)
        if response: return response

        self.UserId = ToInt(self.request.session.get("user"), "")

        if self.UserId == "":
            return HttpResponseRedirect("/")

        content = GetTemplate(self.request, "wait")

        # retrieve remaining time
        query = "SELECT login, COALESCE(date_part('epoch', ban_expire-now()), 0) AS remaining_time FROM gm_profiles WHERE /*privilege=-3 AND*/ id=" + str(self.UserId)

        oRs = oConnExecute(query)

        if oRs == None:
            return HttpResponseRedirect("/")

        remainingTime = oRs[1]
        
        # check to unlock holidays mode
        action = request.POST.get("unlock", "")

        if action != "" and remainingTime < 0:
            oConnDoQuery("UPDATE gm_profiles SET privilege=0 WHERE ban_expire < now() AND id="+str(self.UserId))
            return HttpResponseRedirect("/game/start/")

        content.AssignValue("login", oRs[0])
        content.AssignValue("remaining_time_before_unlock", int(oRs[1]))

        if remainingTime < 0:
            content.Parse("unlock")
        else:
            content.Parse("cant_unlock")

        return render(self.request, content.template, content.data)
