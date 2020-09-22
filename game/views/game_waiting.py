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

        self.userId = ToInt(self.request.session.get("user"), "")

        if self.userId == "":
            return HttpResponseRedirect("/")
        
        return super().dispatch(request, *args, **kwargs)

    #---------------------------------------------------------------------------
    def fillContent(self, request, data):

        # retrieve remaining time
        query = "SELECT login, COALESCE(date_part('epoch', ban_expire-now()), 0) AS remaining_time FROM gm_profiles WHERE /*privilege=-3 AND*/ id=" + str(self.userId)

        row = dbRow(query)

        if row == None:
            return HttpResponseRedirect("/")

        remainingTime = row[1]
        
        # check to unlock holidays mode
        action = request.POST.get("unlock","")

        if action != "" and remainingTime < 0:
            dbExecute("UPDATE gm_profiles SET privilege=0 WHERE ban_expire < now() AND id="+str(self.userId))
            return HttpResponseRedirect("/game/start/")

        content.AssignValue("login", row[0])
        content.AssignValue("remaining_time_before_unlock", int(row[1]))

        if remainingTime < 0:
            content.Parse("unlock")
        else:
            content.Parse("cant_unlock")

        return render(self.request, content.template, content.data)
