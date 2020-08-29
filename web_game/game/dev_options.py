# -*- coding: utf-8 -*-

from web_game.game._global import *

class View(GlobalView):

    def dispatch(self, request, *args, **kwargs):

        response = super().pre_dispatch(request, *args, **kwargs)
        if response: return response

        self.selected_menu = "player_penalty"

        if self.request.session.get("privilege") < 100: return HttpResponseRedirect("/")

        action = request.GET.get("action").strip()
        newname = request.GET.get("newname").strip()
        reason = request.GET.get("reason").strip()
        reasonpublic = request.GET.get("reasonpublic").strip()
        notes = request.GET.get("notes").strip()
        redirecturl = ""

        user = request.GET.get("userid").strip()

        typ = ""

        if action == "penalty":
            typ = request.GET.get("type").strip()
            if typ == 0:    # electromagnetic storms on all the player planets
                query = "SELECT sp_catastrophe_electromagnetic_storm(Ownerid,id, 24) FROM nav_planet WHERE ownerid="+User
            elif typ == 1:    # account locked for 1 day
                query = "UPDATE users SET privilege=-1," + \
                        " ban_reason="+dosql(reason)+", ban_reason_public="+dosql(reasonpublic)+", ban_datetime=now()," + \
                        " ban_expire=now()+INTERVAL '1 day', ban_adminuserid=" + self.request.session.get(sLogonself.UserId) + \
                        " WHERE id="+User
            elif typ == 2:    # account locked for 2 days
                query = "UPDATE users SET privilege=-1," + \
                        " ban_reason="+dosql(reason)+", ban_reason_public="+dosql(reasonpublic)+", ban_datetime=now()," + \
                        " ban_expire=now()+INTERVAL '2 days', ban_adminuserid=" + self.request.session.get(sLogonself.UserId) + \
                        " WHERE id="+User
            elif typ == 3:    # account locked for 4 days
                query = "UPDATE users SET privilege=-1," + \
                        " ban_reason="+dosql(reason)+", ban_reason_public="+dosql(reasonpublic)+", ban_datetime=now()," + \
                        " ban_expire=now()+INTERVAL '4 days', ban_adminuserid=" + self.request.session.get(sLogonself.UserId) + \
                        " WHERE id="+User
            elif typ == 4:    # account locked for 7 days
                query = "UPDATE users SET privilege=-1," + \
                        " ban_reason="+dosql(reason)+", ban_reason_public="+dosql(reasonpublic)+", ban_datetime=now()," + \
                        " ban_expire=now()+INTERVAL '7 days', ban_adminuserid=" + self.request.session.get(sLogonself.UserId) + \
                        " WHERE id="+User
            elif typ == 5:    # holidays for 2 weeks immediately
                if self.oPlayerInfo["privilege") == 0:
                    query = "INSERT INTO users_holidays(userid, start_time, min_end_time, end_time) VALUES("+User+",now(), now()+INTERVAL '48 hours', now()+INTERVAL '2 weeks')"

            elif typ == 6:    # holidays for 3 weeks immediately
                if self.oPlayerInfo["privilege") == 0:
                    query = "INSERT INTO users_holidays(userid, start_time, min_end_time, end_time) VALUES("+User+",now(), now()+INTERVAL '48 hours', now()+INTERVAL '3 weeks')"

            oConnExecute query,, adExecuteNoRecords

        elif action == "rename":
            query = "UPDATE users SET login="+dosql(newname)+" WHERE id="+User
            oConnExecute query,, adExecuteNoRecords

            query = "UPDATE commanders SET name="+dosql(newname)+" WHERE ownerid="+User+" AND NOT can_be_fired"
            oConnExecute query,, adExecuteNoRecords

            typ = -1

            redirecturl = "dev-playas.asp?player="+newname
            reason = self.oPlayerInfo["login")
            reasonpublic = newname

        elif action == "ban":    # account locked forever : banned
            query = "UPDATE users SET privilege=-1," + \
                    " ban_reason="+dosql(reason)+", ban_reason_public="+dosql(reasonpublic)+", ban_datetime=now()," + \
                    " ban_expire=None, ban_adminuserid=" + self.request.session.get(sLogonself.UserId) + \
                    " WHERE id="+User
            oConnExecute query,, adExecuteNoRecords

            typ = -2

        elif action == "unban":
            query = "UPDATE users SET privilege=0 WHERE id="+User
            oConnExecute query,, adExecuteNoRecords

            typ = -3

        elif action == "stopholidays":
            query = "UPDATE users_holidays SET min_end_time=now(), end_time=now() WHERE userid="+User
            oConnExecute query,, adExecuteNoRecords

            typ = -4

        elif action == "notes":
            typ = -5

        if typ != "":
            # update admin notes
            query = "UPDATE users SET admin_notes=" + dosql(notes) + " WHERE id="+User
            oConnExecute query,, adExecuteNoRecords

            query = "INSERT INTO log_admin_actions(adminuserid, userid, action, reason, reason_public, admin_notes)" + \
                    "VALUES(" + self.request.session.get(sLogonself.UserId) + "," + User + "," + typ + "," + dosql(reason) + "," + dosql(reasonpublic) + "," + dosql(notes) + ")"
            oConnExecute query,, adExecuteNoRecords

            if redirecturl != "": RedirectTo redirecturl

        if request.GET.get("close") == "": return self.DisplayForm()

    def DisplayForm(self):

        content = GetTemplate(self.request, "dev-options")

        content.AssignValue("name", self.oPlayerInfo["login")

        oRs = oConnExecute("SELECT privilege, ban_reason, ban_reason_public, admin_notes FROM users WHERE id="+UserId)
        if oRs[0] = -1: content.Parse("unban"
        if oRs[0] = -2: content.Parse("stopholidays"

        content.AssignValue("userid", self.UserId

        content.AssignValue("reason", oRs[1]
        content.AssignValue("reasonpublic", oRs[2]
        content.AssignValue("notes", oRs[3]

        query = "SELECT action, reason, reason_public, admin_notes, datetime FROM log_admin_actions WHERE userid=" + str(self.UserId)
        oRss = oConnExecuteAll(query)
        list = []
        for oRs in oRss:
            item = {}
            list.append(item)
            
            item["h_reason", oRs[1]
            item["h_reason_public", oRs[2]
            item["h_admin_notes", oRs[3]
            item["h_date", oRs[4].value

            content.Parse("history.action" + oRs[0]
            content.Parse("history"

        return self.Display(content)

    def sqlValue(self, val):
        if val = "" or IsNull(val):
            sqlValue = "None"
        else:
            sqlValue = val

