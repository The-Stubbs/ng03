# -*- coding: utf-8 -*-

from web_game.game._global import *

class View(GlobalView):

    def dispatch(self, request, *args, **kwargs):

        response = super().pre_dispatch(request, *args, **kwargs)
        if response: return response

        from web_game.lib.accounts import *

        self.selected_menu = "options"

        if request.GET.get("frame") = "1":
            oConnDoQuery("UPDATE users SET inframe=True WHERE id="+userid)

        holidays_breaktime = 7*24*60*60 # time before being able to set the holidays again

        changes_status = ""
        showSubmit = True

        avatar = request.POST.get("avatar").strip()
        description = request.POST.get("description").strip()

        timers_enabled = cbool(request.POST.get("timers_enabled"))
        display_alliance_planet_name = cbool(request.POST.get("display_alliance_planet_name"))
        score_visibility = ToInt(request.POST.get("score_visibility"), 0)
        if score_visibility < 0 or score_visibility > 2: score_visibility = 0
        skin = ToInt(request.POST.get("skin"), 0)

        deletingaccount = request.POST.get("deleting")
        deleteaccount = request.POST.get("delete")

        autosignature = request.POST.get("autosignature")

        optionCat = ToInt(request.GET.get("cat"), 1)

        DoRedirect = False

        if optionCat < 1 or optionCat > 6: optionCat = 1

        if not allowedHolidays and optionCat = 3: optionCat = 1 # only display holidays formular if it is allowed

        if request.POST.get("submit") != "":

            changes_status = "done"
            query = ""

            if optionCat == 1:
                if avatar != "" and not isValidURL(avatar):
                    #avatar is invalid
                    changes_status = "check_avatar"
                else:
                    # save updated information
                    query = "UPDATE users SET" + \
                            " avatar_url=" + dosql(avatar) + ", description=" + dosql(description) + \
                            " WHERE id=" + str(self.UserId)

            elif optionCat == 2:

                query = "UPDATE users SET" + \
                        " timers_enabled=" + dosql(timers_enabled) + \
                        " ,display_alliance_planet_name=" + dosql(display_alliance_planet_name) + \
                        " ,score_visibility=" + dosql(score_visibility)

                if skin == 0:
                    skin = "s_default"
                else:
                    skin = "s_transparent"

                query = query + ", skin=" + dosql(skin)

                if deletingaccount and not deleteaccount:
                    query = query + ", deletion_date=None"

                if not deletingaccount and deleteaccount:
                    query = query + ", deletion_date=now() + INTERVAL '2 days'"

                query = query + " WHERE id=" + str(self.UserId)
            elif optionCat == 3:
                if request.POST.get("holidays"):
                oRs = oConnExecute("SELECT COALESCE(int4(date_part('epoch', now()-last_holidays)), 10000000) AS holidays_cooldown, (SELECT 1 FROM users_holidays WHERE userid=users.id) FROM users WHERE id="+UserId)

                    if oRs[0] > holidays_breaktime and isnull(oRs[1]):
                        query = "INSERT INTO users_holidays(userid, start_time, min_end_time, end_time) VALUES("+str(self.UserId)+",now()+INTERVAL '24 hours', now()+INTERVAL '72 hours', now()+INTERVAL '22 days')"
                        oConnDoQuery(query)

                        response.redirect "?cat=3"

            elif optionCat == 4:

                oConnDoQuery("DELETE FROM users_reports WHERE userid="+userid)

                for each x in request.POST.get("r")
                    typ = fix(x / 100)
                    subtyp = x mod 100
                    oConnExecute("INSERT INTO users_reports(userid, type, subtype) VALUES("+userid+","+dosql(typ)+","+dosql(subtyp)+")")

            elif optionCat == 5:
                if autosignature != "":
                    query = "UPDATE users SET" + \
                            " autosignature=" + dosql(autosignature) + \
                            " WHERE id=" + str(self.UserId)

                    oConnDoQuery(query)

            if query != "": oConnExecute query)
            DoRedirect = True

        if DoRedirect:
            return HttpResponseRedirect("/game/options/?cat=" + str(optionCat))
        else:
            return self.displayPage()

    def display_general(self, content):

        query = "SELECT avatar_url, regdate, users.description, 0," + \
                " alliance_id, a.tag, a.name, r.label" + \
                " FROM users" + \
                " LEFT JOIN alliances AS a ON (users.alliance_id = a.id)" + \
                " LEFT JOIN alliances_ranks AS r ON (users.alliance_id = r.allianceid AND users.alliance_rank = r.rankid) " + \
                " WHERE users.id = "+userid
        oRs = oConnExecute(query)

        content.AssignValue("regdate", oRs[1]
        content.AssignValue("description", oRs[2]
        content.AssignValue("ip", Request.ServerVariables("remote_addr")

        if oRs[0] == None or oRs[0] == "":
            content.Parse("general.noavatar"
        else:
            content.AssignValue("avatar_url", oRs[0]
            content.Parse("general.avatar"

        if oRs[4]:
            content.AssignValue("alliancename", oRs[6]
            content.AssignValue("alliancetag", oRs[5]
            content.AssignValue("rank_label", oRs[7]

            content.Parse("general.alliance"
        else:
            content.Parse("general.noalliance"

        content.Parse("general"

    def display_options(self, content):

        oRs = oConnExecute("SELECT int4(date_part('epoch', deletion_date-now())), timers_enabled, display_alliance_planet_name, email, score_visibility, skin FROM users WHERE id="+userid)

        if oRs[0] == None:
            content.Parse("options.delete_account"
        else:
            content.AssignValue("remainingtime", oRs[0]
            content.Parse("options.account_deleting"

        if oRs[1]: content.Parse("options.timers_enabled"
        if oRs[2]: content.Parse("options.display_alliance_planet_name"
        content.Parse("options.score_visibility_" + oRs[4]

        content.Parse("options.skin_" + oRs[5]

        content.AssignValue("email", oRs[3]

        content.Parse("options"

    def display_holidays(self, content):

        # check if holidays will be activated soon
        oRs = oConnExecute("SELECT int4(date_part('epoch', start_time-now())) FROM users_holidays WHERE userid="+UserId)

        if oRs:
            remainingtime = oRs[0]
        else:
            remainingtime = 0

        if remainingtime > 0:
            content.AssignValue("remaining_time", remainingtime
            content.Parse("holidays.start_in"
            showSubmit = False
        else:

            # holidays can be activated only if never took any holidays or it was at least 7 days ago
        oRs = oConnExecute("SELECT int4(date_part('epoch', now()-last_holidays)) FROM users WHERE id="+UserId)

            if (oRs[0]) and oRs[0] < holidays_breaktime:
                content.AssignValue("remaining_time", holidays_breaktime-oRs[0]
                content.Parse("holidays.cant_enable"
                showSubmit = False
            else:
                content.Parse("holidays.can_enable"
                content.Parse("submit.holidays"

        content.Parse("holidays"

    def display_reports(self, content):

        oRss = oConnExecuteAll("SELECT type*100+subtype FROM users_reports WHERE userid="+userid)
        for oRs in oRss:
            content.Parse("reports.c"+oRs[0]

        content.Parse("reports"

    def display_mail(self, content):

        oRs = oConnExecute("SELECT autosignature FROM users WHERE id="+userid)
        if oRs:
            content.AssignValue("autosignature", oRs[0]
        else:
            content.AssignValue("autosignature", ""

        content.Parse("mail"

    def display_signature(self, content):

        content.Parse("signature"
        showSubmit = False

    def displayPage(self):
        content = GetTemplate(self.request, "options")

        content.AssignValue("cat", optionCat
        content.AssignValue("name", self.oPlayerInfo["login")
        content.AssignValue("universe", universe

        if optionCat == 2:
            display_options content
        elif optionCat == 3:
            display_holidays content
        elif optionCat == 4:
            display_reports content
        elif optionCat == 5:
            display_mail content
        elif optionCat == 6:
            display_signature content
        else:
            display_general content

        if changes_status != "":
            content.Parse("changes." + changes_status
            content.Parse("changes"

        content.Parse("nav.cat"+optionCat+".selected"
        content.Parse("nav.cat1"
        content.Parse("nav.cat2"
        if allowedHolidays: content.Parse("nav.cat3"
        content.Parse("nav.cat5"
        content.Parse("nav.cat6"
        content.Parse("nav"

        if showSubmit: content.Parse("submit"

        return self.Display(content)

