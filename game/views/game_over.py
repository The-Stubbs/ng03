# -*- coding: utf-8 -*-

from game.views._base import *

#-------------------------------------------------------------------------------
class View(BaseMixin, View):

    def dispatch(self, request, *args, **kwargs):

        response = super().pre_dispatch(request, *args, **kwargs)
        if response: return response

        reset_error = 0

        self.userId = ToInt(self.request.session.get("user"), "")

        if self.userId == "":
            return HttpResponseRedirect("/")

        # check that the player has no more planets
        row = dbRow("SELECT int4(count(1)) FROM gm_planets WHERE ownerid=" + str(self.userId))
        if row == None:
            return HttpResponseRedirect("/")

        planets = row[0]

        # retreive player username and number of resets

        query = "SELECT login, resets, credits_bankruptcy, int4(score_research) FROM gm_profiles WHERE id=" + str(self.userId)
        row = dbRow(query)

        username = row[0]
        resets = row[1]
        bankruptcy = row[2]
        research_done = row[3]

        # still have planets
        if planets > 0 and bankruptcy > 0:
            return HttpResponseRedirect("/")

        if resets == 0:
            return HttpResponseRedirect("/game/start/")

        changeNameError = ""

        action = request.POST.get("action")

        if action == "retry":
            # check if user wants to change name
            if request.POST.get("login") != username:

                # check that the login is not banned
                row = dbRow("SELECT 1 FROM dt_banned_usernames WHERE " + sqlStr(username) + " ~* login LIMIT 1;")
                if row == None:

                    # check that the username is correct
                    if not isValidName(request.POST.get("login")):
                        changeNameError = "check_username"
                    else:
                        # try to rename user and catch any error
                        dbExecute("UPDATE gm_profiles SET alliance_id=None WHERE id=" + str(self.userId))

                        dbExecute("UPDATE gm_profiles SET login=" + sqlStr(request.POST.get("login")) + " WHERE id=" + str(self.userId))

                        if err.Number != 0:
                            changeNameError = "username_exists"
                        else:
                            # update the commander name
                            dbExecute("UPDATE gm_commanders SET name=" + sqlStr(request.POST.get("login")) + " WHERE name=" + sqlStr(username) + " AND ownerid=" + str(self.userId))

            if changeNameError == "":
                row = dbRow("SELECT user_profile_reset(" + str(self.userId) + "," + str(ToInt(request.POST.get("galaxy"), 1)) + ")")
                if row[0] == 0:
                    return HttpResponseRedirect("/game/overview/")

                else:
                    reset_error = row[0]

        elif action == "abandon":
            dbExecute("UPDATE gm_profiles SET deletion_date=now()/*+INTERVAL '2 days'*/ WHERE id=" + str(self.userId))
            return HttpResponseRedirect("/")

        # display Game Over page
        content = self.loadTemplate("game-over")
        content.AssignValue("login", username)

        if changeNameError != "": action = "continue"

        if action == "continue":
            oRss = dbRows("SELECT id, recommended FROM internal_profile_get_galaxies_info(" + str(self.userId) + ")")

            list = []
            for row in oRss:
                item = {}
                list.append(item)
                
                item["id"] = row[0]
                item["recommendation"] = row[1]

            content.AssignValue("galaxies", list)

            if changeNameError != "":
                content.Parse(changeNameError)
                content.Parse("error")

            content.Parse("changename")
        else:
            content.Parse("retry")
            content.Parse("choice")

            if bankruptcy > 0:
                content.Parse("gameover")
            else:
                content.Parse("bankrupt")

        if reset_error != 0:
            if reset_error == 4:
                content.Parse("no_free_planet")
            else:
                content.AssignValue("userid", self.userId)
                content.AssignValue("reset_error", reset_error)
                content.Parse("reset_error")

        return render(self.request, content.template, content.data)
