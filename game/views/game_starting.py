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

        if not registration:
            content = self.loadTemplate("start-closed")
            return render(self.request, content.template, content.data)
        
        return super().dispatch(request, *args, **kwargs)

    #---------------------------------------------------------------------------

        result = 0

        self.userId = int(request.session.get("user"))
        galaxy = int(request.POST.get("galaxy", 0))
        if galaxy == None: galaxy = 0

        if not self.userId:
            return HttpResponseRedirect("/")

        # check if it is the first login of the player
        rs = dbRow("SELECT login FROM gm_profiles WHERE resets=0 AND id=" + str(self.userId))
        if not rs:
            return HttpResponseRedirect("/")

        userName = rs[0]

        newName = request.POST.get('name', '')
        if newName != "":
            # try to rename user and catch any error
            try:
                if isValidName(newName):
                    dbExecute("UPDATE gm_profiles SET login=" + sqlStr(newName) + " WHERE id=" + str(self.userId))
                    userName = newName
                else:
                    result = 11
            except e:
                result = 10

        if result == 0:
            orientation = int(request.POST.get("orientation", 0))
            allowed = False

            for i in [1,2,3]:
                if i == orientation:
                    allowed = True
                    break

            if allowed:
                dbExecute("UPDATE gm_profiles SET orientation=" + str(orientation) + " WHERE id=" + str(self.userId))

                rs = dbRow("SELECT user_profile_reset(" + str(self.userId) + "," + str(galaxy) + ")")
                result = rs[0]

                if result == 0:
    
                    if orientation == 1:    # merchant
                        dbExecute("INSERT INTO gm_profile_researches(userid, researchid, level) VALUES(" + str(self.userId) + ",10,1)")
                        dbExecute("INSERT INTO gm_profile_researches(userid, researchid, level) VALUES(" + str(self.userId) + ",11,1)")
                        dbExecute("INSERT INTO gm_profile_researches(userid, researchid, level) VALUES(" + str(self.userId) + ",12,1)")
    
                    elif orientation == 2:    # military
                        dbExecute("INSERT INTO gm_profile_researches(userid, researchid, level) VALUES(" + str(self.userId) + ",20,1)")
                        dbExecute("INSERT INTO gm_profile_researches(userid, researchid, level) VALUES(" + str(self.userId) + ",21,1)")
                        dbExecute("INSERT INTO gm_profile_researches(userid, researchid, level) VALUES(" + str(self.userId) + ",22,1)")
    
                    elif orientation == 3:    # scientist
                        dbExecute("INSERT INTO gm_profile_researches(userid, researchid, level) VALUES(" + str(self.userId) + ",30,1)")
                        dbExecute("INSERT INTO gm_profile_researches(userid, researchid, level) VALUES(" + str(self.userId) + ",31,1)")
                        dbExecute("INSERT INTO gm_profile_researches(userid, researchid, level) VALUES(" + str(self.userId) + ",32,1)")
    
                    elif orientation == 4:    # war lord
                        dbExecute("INSERT INTO gm_profile_researches(userid, researchid, level) VALUES(" + str(self.userId) + ",40,1)")
                        dbExecute("INSERT INTO gm_profile_researches(userid, researchid, level) VALUES(" + str(self.userId) + ",12,1)")
                        dbExecute("INSERT INTO gm_profile_researches(userid, researchid, level) VALUES(" + str(self.userId) + ",32,1)")
    
                    dbRow("SELECT internal_profile_update_modifiers(" + str(self.userId) + ")")
    
                    return HttpResponseRedirect("/game/overview/")

        # display start page
        content = self.loadTemplate("start")
        content.AssignValue("login", userName)

        for i in [1,2,3]:
            content.Parse("orientation_" + str(i))

        rss = dbRows("SELECT id, recommended FROM internal_profile_get_galaxies_info(" + str(self.userId) + ")")

        list = []
        content.AssignValue("galaxies", list)
        for rs in rss:
            item = {}
            list.append(item)
            item["id"] = rs[0]
            item["recommendation"] = rs[1]

        if result != 0:
            content.Parse("error_" + str(result))

        return render(self.request, content.template, content.data)
