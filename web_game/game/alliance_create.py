# -*- coding: utf-8 -*-

from web_game.game._global import *

class View(GlobalView):

    def dispatch(self, request, *args, **kwargs):

        response = super().pre_dispatch(request, *args, **kwargs)
        if response: return response

        self.selected_menu = "noalliance.create"

        name = ""
        tag = ""
        description = ""

        valid_name = True
        valid_tag = True
        valid_description = True
        create_result = 0

        if request.GET.get("a") == "new":
            name = request.POST.get("alliancename").stip()
            tag = request.POST.get("alliancetag").stip()
            description = request.POST.get("description").stip()

            valid_name = self.isValidAllianceName(name)
            valid_tag = (request.session.get(sPrivilege) > 100) or self.isValidAllianceTag(tag)
            valid_description = self.isValidDescription(description)

            if valid_name and valid_tag:

                oRs = oConnExecute("SELECT sp_create_alliance(" + str(self.UserId) + "," + dosql(name) + "," + dosql(tag) + "," + dosql(description) + ")")

                create_result = oRs[0]
                if create_result >= -1:
                    return HttpResponseRedirect("/game/alliance/")

        return self.DisplayAllianceCreate()

    #
    # return if the given name is valid for an alliance
    #
    def isValidAllianceName(self, myName):

        if myName == "" or len(myName) < 4 or len(myName) > 32:
            return False
        else:
            p = re.compile("^[a-zA-Z0-9]+([ ]?[.]?[\-]?[ ]?[a-zA-Z0-9]+)*$")
            return p.matching(myName)

    #
    # return if the given tag is valid
    #
    def isValidAllianceTag(self, tag):

        if tag == "" or len(tag) < 2 or len(tag) > 4:
            return False
        else:
            p = re.compile("^[a-zA-Z0-9]+$")
            return p.matching(tag)

    def isValidDescription(self, description):
        return len(description) < 8192

    def DisplayAllianceCreate(self):

        content = GetTemplate(self.request, "alliance-create")

        if self.oPlayerInfo["can_join_alliance"]:
            if create_result == -2: content.Parse("name_already_used")
            if create_result == -3: content.Parse("tag_already_used")

            if not valid_name: content.Parse("invalid_name")

            if not valid_tag: content.Parse("invalid_tag")

            content.AssignValue("name", name)
            content.AssignValue("tag", tag)
            content.AssignValue("description", description)

            content.Parse("create")
        else:
            content.Parse("cant_create")

        return self.Display(content)
