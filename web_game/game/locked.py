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

        # retrieve remaining time
        query = "SELECT login, int4(date_part('epoch', ban_expire-now())), ban_reason_public, (SELECT email FROM users WHERE id=u.ban_adminuserid)" + \
                " FROM users AS u" + \
                " WHERE privilege=-1 AND id=" + str(self.UserId)

        oRs = oConnExecute(query)

        if oRs == None:
            return HttpResponseRedirect("/")

        set content = GetTemplate(self.request, "locked")

        # check to unlock holidays mode
        action = request.POST.get("unlock")

        if action != "" and oRs[1] <= 0:
            oConnDoQuery("UPDATE users SET privilege=0, ban_expire=None WHERE ban_expire <= now() AND privilege=-1 AND id="+UserId, , 128
            return HttpResponseRedirect("/game/overview/")

        content.AssignValue("login", oRs[0]
        content.AssignValue("remaining_time_before_unlock", oRs[1]

        'content.AssignValue("admin_email", oRs[3]
        content.AssignValue("admin_email", supportMail

        content.AssignValue("universe", Universe

        if (oRs[2]) and oRs[2] != "":
            content.AssignValue("reason", oRs[2]
            content.Parse("reason"

        if (oRs[1]):
            if oRs[1] < 0:
                content.Parse("unlock"
            else:
                content.AssignValue("remaining_time_before_unlock", oRs[1]
                content.Parse("cant_unlock"

        Response.write content.Output

