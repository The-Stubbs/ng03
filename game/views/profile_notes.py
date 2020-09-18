# -*- coding: utf-8 -*-

from game.views._base import *

#-------------------------------------------------------------------------------
class View(BaseView):

    def dispatch(self, request, *args, **kwargs):

        response = super().pre_dispatch(request, *args, **kwargs)
        if response: return response

        self.selected_menu = "notes"

        self.notes_status = ""

        notes = request.POST.get("notes", "").strip()

        if request.POST.get("submit", "") != "":

            if len(notes) <= 5100: # ok save info
                dbExecute("UPDATE gm_profiles SET notes=" + sqlStr(notes) + " WHERE id = " + str(self.userId))
                self.notes_status = "done"
            else:
                self.notes_status = "toolong"

        return self.display_notes()

    def display_notes(self):

        content = self.loadTemplate("notes")

        content.AssignValue("maxlength", 5000)

        row = dbRow("SELECT notes FROM gm_profiles WHERE id = " + str(self.userId) + " LIMIT 1" )

        content.AssignValue("data_notes", row[0])

        if self.notes_status != "":
            content.Parse(self.notes_status)
            content.Parse("error")

        return self.display(content)
