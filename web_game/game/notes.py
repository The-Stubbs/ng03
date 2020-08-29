# -*- coding: utf-8 -*-

from web_game.game._global import *

class View(GlobalView):

    def dispatch(self, request, *args, **kwargs):

        response = super().pre_dispatch(request, *args, **kwargs)
        if response: return response

        from web_game.lib.accounts import *

        self.selected_menu = "notes"

        notes_status = ""

        notes = request.POST.get("notes").strip()

        if request.POST.get("submit") != "":

            if len(notes) <= 5100: # ok save info
                oConnDoQuery("UPDATE users SET notes=" + dosql(notes) + " WHERE id = " + userid)
                notes_status = "done"
            else:
                notes_status = "toolong"

        return self.display_notes()

    def display_notes(self):

        content = GetTemplate(self.request, "notes")

        content.AssignValue("maxlength", 5000

        oRs = oConnExecute("SELECT notes FROM users WHERE id = " + str(self.UserId) + " LIMIT 1" )

        content.AssignValue("notes", oRs[0]

        if notes_status != "":
            content.Parse("error." + notes_status
            content.Parse("error"

        return self.Display(content)

