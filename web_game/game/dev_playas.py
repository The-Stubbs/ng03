# -*- coding: utf-8 -*-

from web_game.game._global import *

class View(GlobalView):

    def dispatch(self, request, *args, **kwargs):

        response = super().pre_dispatch(request, *args, **kwargs)
        if response: return response

        self.selected_menu = "playas"

        if self.request.session.get("privilege") < 100:
            response.Redirect "/"

        player = request.GET.get("player").strip()

        if player != "":
        oRs = oConnExecute("SELECT id FROM users WHERE upper(login)=upper(" + dosql(player) + ")")
            if oRs: Impersonate oRs[0]

        return self.DisplayForm()

    def DisplayForm(self):

        content = GetTemplate(self.request, "dev-playas")

        return self.Display(content)

