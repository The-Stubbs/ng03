# -*- coding: utf-8 -*-

from web_game.game._global import *

class View(GlobalView):

    def dispatch(self, request, *args, **kwargs):

        response = super().pre_dispatch(request, *args, **kwargs)
        if response: return response

        <!--#include virtual="/lib/exile.asp"-->
        <!--#include virtual="/lib/template.asp"-->
        from web_game.lib.accounts import *

        reset_error = 0

        UserId = ToInt(Session("user"), "")

        if self.UserId == "":
            return HttpResponseRedirect("/")

        # check that the player has no more planets
        oRs = oConnExecute("SELECT int4(count(1)) FROM nav_planet WHERE ownerid=" + str(self.UserId))
        if oRs == None:
            return HttpResponseRedirect("/")

        planets = oRs[0]

        # retreive player username and number of resets

        query = "SELECT login, resets, credits_bankruptcy, int4(score_research) FROM users WHERE id=" + str(self.UserId)
        oRs = oConnExecute(query)

        username = oRs[0]
        resets = oRs[1]
        bankruptcy = oRs[2]
        research_done = oRs[3]

        # still have planets
        if planets > 0 and bankruptcy > 0:
            return HttpResponseRedirect("/")

        if resets == 0:
            response.redirect "start.asp"

        changeNameError = ""

        if allowedRetry:
            action = request.POST.get("action")

            if action = "retry":
                # check if user wants to change name
                if request.POST.get("login") != username:

                    # check that the login is not banned
                    oRs = oConnExecute("SELECT 1 FROM banned_logins WHERE " + dosql(username) + " ~* login LIMIT 1;")
                    if oRs == None:

                        # check that the username is correct
                        if not isValidName(request.POST.get("login")):
                            changeNameError = "check_username"
                        else:
                            # try to rename user and catch any error
                            on error resume next

                            oConnDoQuery("UPDATE users SET alliance_id=None WHERE id=" + str(self.UserId)

                            oConnDoQuery("UPDATE users SET login=" + dosql(request.POST.get("login")) + " WHERE id=" + str(self.UserId)

                            if err.Number != 0:
                                changeNameError = "username_exists"
                            else:
                                # update the commander name
                                oConnDoQuery("UPDATE commanders SET name=" + dosql(request.POST.get("login")) + " WHERE name=" + dosql(username) + " AND ownerid=" + str(self.UserId)

                            on error goto 0

                if changeNameError == "":
                oRs = oConnExecute("SELECT sp_reset_account(" + str(self.UserId) + "," + ToInt(request.POST.get("galaxy"), 1) + ")")
                    if oRs[0] == 0:
                        return HttpResponseRedirect("/game/overview/")

                    else:
                        reset_error = oRs[0]

            elif action = "abandon":
                oConnDoQuery("UPDATE users SET deletion_date=now()/*+INTERVAL '2 days'*/ WHERE id=" + str(self.UserId), , 128
                return HttpResponseRedirect("/")

        # display Game Over page
        set content = GetTemplate(self.request, "game-over")
        content.AssignValue("login", username

        if changeNameError != "": action = "continue"

        if action = "continue":
            oRss = oConnExecuteAll("SELECT id, recommended FROM sp_get_galaxy_info(" + str(self.UserId) + ")")

            list = []
            for oRs in oRss:
                item = {}
                list.append(item)
                
                item["id", oRs[0]
                item["recommendation", oRs[1]
                content.Parse("changename.galaxies.galaxy"

            content.Parse("changename.galaxies"

            if changeNameError != "":
                content.Parse("changename.error." + changeNameError
                content.Parse("changename.error"

            content.Parse("changename"
        else:
            if allowedRetry: content.Parse("choice.retry"
            content.Parse("choice"

            if bankruptcy > 0:
                content.Parse("gameover"
            else:
                content.Parse("bankrupt"

        if reset_error != 0:
            if reset_error = 4:
                content.Parse("no_free_planet"
            else:
                content.AssignValue("userid", self.UserId
                content.AssignValue("reset_error", reset_error
                content.Parse("reset_error"

        Response.write content.Output

