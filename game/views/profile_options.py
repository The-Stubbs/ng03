# -*- coding: utf-8 -*-

from game.views._base import *

#-------------------------------------------------------------------------------
class View(BaseView):

    success_url = ""
    template_name = ""
    selected_menu = ""

    #---------------------------------------------------------------------------
    def dispatch(self, request, *args, **kwargs):

        response = super().pre_dispatch(request, *args, **kwargs)
        if response: return response
        
        return super().dispatch(request, *args, **kwargs)

    #---------------------------------------------------------------------------

        if request.GET.get("frame") == "1":
            dbExecute("UPDATE gm_profiles SET inframe=True WHERE id="+ str(self.userId))

        holidays_breaktime = 7*24*60*60 # time before being able to set the holidays again

        self.changes_status = ""
        self.showSubmit = True

        avatar = request.POST.get("avatar","").strip()
        description = request.POST.get("description","").strip()

        timers_enabled = ToInt(request.POST.get("timers_enabled"), 0)
        if timers_enabled == 1: timers_enabled = True
        else: timers_enabled = False

        display_alliance_planet_name = ToInt(request.POST.get("display_alliance_planet_name"), 0)
        if display_alliance_planet_name == 1: display_alliance_planet_name = True
        else: display_alliance_planet_name = False
        
        score_visibility = ToInt(request.POST.get("score_visibility"), 0)
        if score_visibility < 0 or score_visibility > 2: score_visibility = 0

        skin = ToInt(request.POST.get("skin"), 0)

        deletingaccount = request.POST.get("deleting")
        deleteaccount = request.POST.get("delete")

        autosignature = request.POST.get("autosignature")

        self.optionCat = ToInt(request.GET.get("cat"), 1)

        DoRedirect = False

        if self.optionCat < 1 or self.optionCat > 6:
            self.optionCat = 1

        if request.POST.get("submit","") != "":

            self.changes_status = "done"
            query = ""

            if self.optionCat == 1:
                if avatar != "" and not isValidURL(avatar):
                    #avatar is invalid
                    self.changes_status = "check_avatar"
                else:
                    # save updated information
                    query = "UPDATE gm_profiles SET" + \
                            " avatar_url=" + sqlStr(avatar) + ", description=" + sqlStr(description) + \
                            " WHERE id=" + str(self.userId)

            elif self.optionCat == 2:

                query = "UPDATE gm_profiles SET" + \
                        " timers_enabled=" + str(timers_enabled) + \
                        " ,display_alliance_planet_name=" + str(display_alliance_planet_name) + \
                        " ,score_visibility=" + str(score_visibility)

                if skin == 0:
                    skin = "s_default"
                else:
                    skin = "s_transparent"

                query = query + ", skin=" + sqlStr(skin)

                if deletingaccount and not deleteaccount:
                    query = query + ", deletion_date=NULL"

                if not deletingaccount and deleteaccount:
                    query = query + ", deletion_date=now() + INTERVAL '2 days'"

                query = query + " WHERE id=" + str(self.userId)
            elif self.optionCat == 3:
                if request.POST.get("holidays"):
                    row = dbRow("SELECT COALESCE(int4(date_part('epoch', now()-last_holidays)), 10000000) AS holidays_cooldown, (SELECT 1 FROM gm_profile_holidays WHERE userid=gm_profiles.id) FROM gm_profiles WHERE id="+ str(self.userId))

                    if row[0] > holidays_breaktime and row[1] == None:
                        query = "INSERT INTO gm_profile_holidays(userid, start_time, min_end_time, end_time) VALUES("+str(self.userId)+",now()+INTERVAL '24 hours', now()+INTERVAL '72 hours', now()+INTERVAL '22 days')"
                        dbExecute(query)

                        return HttpResponseRedirect("?cat=3")

            elif self.optionCat == 4:

                dbExecute("DELETE FROM gm_profile_reports WHERE userid="+str(self.userId))

                for x in request.POST.getlist("r"):
                    typ = int(x / 100)
                    subtyp = x % 100
                    dbRow("INSERT INTO gm_profile_reports(userid, type, subtype) VALUES("+str(self.userId)+","+sqlStr(typ)+","+sqlStr(subtyp)+")")

            elif self.optionCat == 5:
                if autosignature != "":
                    query = "UPDATE gm_profiles SET" + \
                            " autosignature=" + sqlStr(autosignature) + \
                            " WHERE id=" + str(self.userId)

                    dbExecute(query)

            if query != "": dbExecute(query)
            DoRedirect = True

        if DoRedirect:
            return HttpResponseRedirect("/game/options/?cat=" + str(self.optionCat))
        else:
            return self.displayPage()

    def display_general(self, content):

        query = "SELECT avatar_url, regdate, gm_profiles.description, 0," + \
                " alliance_id, a.tag, a.name, r.label" + \
                " FROM gm_profiles" + \
                " LEFT JOIN gm_alliances AS a ON (gm_profiles.alliance_id = a.id)" + \
                " LEFT JOIN gm_alliance_ranks AS r ON (gm_profiles.alliance_id = r.allianceid AND gm_profiles.alliance_rank = r.rankid)" + \
                " WHERE gm_profiles.id = "+str(self.userId)
        row = dbRow(query)

        content.AssignValue("regdate", row[1])
        content.AssignValue("description", row[2])
        content.AssignValue("ip", self.request.META.get("remote_addr"))

        if row[0] == None or row[0] == "":
            content.Parse("noavatar")
        else:
            content.AssignValue("avatar_url", row[0])
            content.Parse("avatar")

        if row[4]:
            content.AssignValue("alliancename", row[6])
            content.AssignValue("alliancetag", row[5])
            content.AssignValue("rank_label", row[7])

            content.Parse("alliance")
        else:
            content.Parse("noalliance")

        content.Parse("general")

    def display_options(self, content):

        row = dbRow("SELECT int4(date_part('epoch', deletion_date-now())), timers_enabled, display_alliance_planet_name, email, score_visibility, skin FROM gm_profiles WHERE id="+str(self.userId))

        if row[0] == None:
            content.Parse("delete_account")
        else:
            content.AssignValue("remainingtime", row[0])
            content.Parse("account_deleting")

        if row[1]: content.Parse("timers_enabled")
        if row[2]: content.Parse("display_alliance_planet_name")
        content.Parse("score_visibility_" + str(row[4]))

        content.Parse("skin_" + str(row[5]))

        content.AssignValue("email", str(row[3]))

        content.Parse("options")

    def display_holidays(self, content):

        # check if holidays will be activated soon
        row = dbRow("SELECT int4(date_part('epoch', start_time-now())) FROM gm_profile_holidays WHERE userid="+str(self.userId))

        if row:
            remainingtime = row[0]
        else:
            remainingtime = 0

        if remainingtime > 0:
            content.AssignValue("remaining_time", remainingtime)
            content.Parse("start_in")
            self.showSubmit = False
        else:

            # holidays can be activated only if never took any holidays or it was at least 7 days ago
            row = dbRow("SELECT int4(date_part('epoch', now()-last_holidays)) FROM gm_profiles WHERE id="+str(self.userId))

            if (row[0]) and row[0] < holidays_breaktime:
                content.AssignValue("remaining_time", holidays_breaktime-row[0])
                content.Parse("cant_enable")
                self.showSubmit = False
            else:
                content.Parse("can_enable")

        content.Parse("holidays")

    def display_reports(self, content):

        oRss = dbRows("SELECT type*100+subtype FROM gm_profile_reports WHERE userid="+str(self.userId))
        for row in rows:
            content.Parse("c"+str(row[0]))

        content.Parse("gm_profile_reports")

    def display_mail(self, content):

        row = dbRow("SELECT autosignature FROM gm_profiles WHERE id="+str(self.userId))
        if row:
            content.AssignValue("autosignature", row[0])
        else:
            content.AssignValue("autosignature","")

        content.Parse("mail")

    def display_signature(self, content):

        content.Parse("signature")
        self.showSubmit = False

    def displayPage(self):
        content = self.loadTemplate("options")

        content.AssignValue("cat", self.optionCat)
        content.AssignValue("name", self.userInfo["login"])
        content.AssignValue("universe", universe)

        if self.optionCat == 2:
            self.display_options(content)
        elif self.optionCat == 3:
            self.display_holidays(content)
        elif self.optionCat == 4:
            self.display_reports(content)
        elif self.optionCat == 5:
            self.display_mail(content)
        elif self.optionCat == 6:
            self.display_signature(content)
        else:
            self.display_general(content)

        if self.changes_status != "":
            content.Parse(self.changes_status)
            content.Parse("changes")

        content.Parse("cat"+str(self.optionCat)+"_selected")
        content.Parse("cat1")
        content.Parse("cat2")
        content.Parse("cat3")
        content.Parse("cat5")
        content.Parse("cat6")
        content.Parse("nav")

        if self.showSubmit: content.Parse("submit")
