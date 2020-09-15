# -*- coding: utf-8 -*-

from game.views.lib._global import *

class View(GlobalView):

    def dispatch(self, request, *args, **kwargs):

        response = super().pre_dispatch(request, *args, **kwargs)
        if response: return response

        self.selected_menu = "notes"

        self.notes_status = ""

        notes = request.POST.get("notes", "").strip()

        if request.POST.get("submit", "") != "":

            if len(notes) <= 5100: # ok save info
                oConnDoQuery("UPDATE gm_profiles SET notes=" + dosql(notes) + " WHERE id = " + str(self.UserId))
                self.notes_status = "done"
            else:
                self.notes_status = "toolong"

        return self.display_notes()

    def display_notes(self):

        content = GetTemplate(self.request, "notes")

        content.AssignValue("maxlength", 5000)

        oRs = oConnExecute("SELECT notes FROM gm_profiles WHERE id = " + str(self.UserId) + " LIMIT 1" )

        content.AssignValue("data_notes", oRs[0])

        if self.notes_status != "":
            content.Parse(self.notes_status)
            content.Parse("error")

        return self.Display(content)
