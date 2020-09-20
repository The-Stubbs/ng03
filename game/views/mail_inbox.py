# -*- coding: utf-8 -*-

from game.views._base import *

#-------------------------------------------------------------------------------
class View(BaseView):

    def dispatch(self, request, *args, **kwargs):

        response = super().pre_dispatch(request, *args, **kwargs)
        if response: return response

        self.selected_menu = "mails"

        self.compose = False
        self.mailto = ""
        self.mailsubject = ""
        self.mailbody = ""
        self.moneyamount = 0
        self.bbcode = False
        self.sendmail_status = ""

        # new email
        if request.POST.get("compose","") != "":
            self.compose = True
        elif request.GET.get("to","") != "":
            self.mailto = request.GET.get("to","")
            self.mailsubject = request.GET.get("subject","")
            self.compose = True
        elif request.GET.get("a","") == "new":

            self.mailto = request.GET.get("b","")
            if self.mailto == "": self.mailto = request.GET.get("to","")
            self.mailsubject = request.GET.get("subject","")
            self.compose = True

        # reply
        elif request.GET.get("a","") == "reply":

            Id = ToInt(request.GET.get("mailid"), 0)

            query = "SELECT sender, subject, body FROM gm_mails WHERE ownerid=" + str(self.userId) + " AND id=" + str(Id) + " LIMIT 1"
            self.request.session["details"] = query
            row = dbRow(query)

            if row:

                self.mailto = row[0]

                # adds 'Re: # to new reply

                if "Re:" in row[1]:
                    self.mailsubject = row[1]
                else:
                    self.mailsubject = "Re: " + row[1]

                self.mailbody = self.quote_mail("> " + row[2] + "\n")

                self.compose = True

        # send email
        elif request.POST.get("sendmail","") != "" and not self.IsImpersonating():

            self.compose = True

            self.mailto = request.POST.get("to","").strip()
            self.mailsubject = request.POST.get("subject","").strip()
            self.mailbody = request.POST.get("message","").strip()

            if ToInt(request.POST.get("sendcredits"), 0) == 1:
                self.moneyamount = ToInt(request.POST.get("amount"), 0)
            else:
                self.moneyamount = 0

            self.bbcode = request.POST.get("self.bbcode") == 1

            if self.mailbody == "":
                self.sendmail_status = "mail_empty"
            else:
                if request.POST.get("type") == "admins":
                    self.mailto = ":admins"
                    self.moneyamount = 0
                elif request.POST.get("type") == "alliance":
                    # send the mail to all members of the alliance except
                    self.mailto = ":alliance"
                    self.moneyamount = 0

                if self.mailto == "":
                    self.sendmail_status = "mail_missing_to"
                else:
                    row = dbRow("SELECT user_mail_send("+ str(self.userId) + "," + sqlStr(self.mailto) + "," + sqlStr(self.mailsubject) + "," + sqlStr(self.mailbody) + "," + str(self.moneyamount) + "," + str(self.bbcode) + ")")

                    if row[0] != 0:
                        if row[0] == 1:
                            self.sendmail_status = "mail_unknown_from" # from not found
                        elif row[0] == 2:
                            self.sendmail_status = "mail_unknown_to" # to not found
                        elif row[0] == 3:
                            self.sendmail_status = "mail_same" # send to same person
                        elif row[0] == 4:
                            self.sendmail_status = "not_enough_credits" # not enough credits
                        elif row[0] == 9:
                            self.sendmail_status = "blocked" # gm_mails are blocked

                    else:
                        self.sendmail_status = "mail_sent"

                        self.mailsubject = ""
                        self.mailbody = ""
                        self.moneyamount = 0

        # delete selected emails
        elif request.POST.get("delete","") != "":

            # build the query of which mails to delete
            query = "False"

            for mailid in request.POST.getlist("checked_mails"):
                query = query + " OR id=" + mailid

            if query != "False":
                dbExecute("UPDATE gm_mails SET deleted=True WHERE (" + query + ") AND ownerid = " + str(self.userId))

        if request.GET.get("a","") == "ignore":
            dbRow("SELECT user_mail_ignore(" + str(self.userId) + "," + sqlStr(request.GET.get("user")) + ")")

            return self.return_ignored_users

        if request.GET.get("a","") == "unignore":
            dbExecute("DELETE FROM gm_mail_ignorees WHERE userid=" + str(self.userId) + " AND ignored_userid=(SELECT id FROM gm_profiles WHERE lower(login)=lower(" + sqlStr(request.GET.get("user")) + "))")

            return self.return_ignored_users()

        if self.compose:
            return self.display_compose_form(self.mailto, self.mailsubject, self.mailbody, self.moneyamount)
        elif request.GET.get("a") == "ignorelist":
            return self.display_ignore_list()
        elif request.GET.get("a") == "unignorelist":
            for self.mailto in request.POST.getlist("unignore"):
                dbExecute("DELETE FROM gm_mail_ignorees WHERE userid=" + str(self.userId) + " AND ignored_userid=" + sqlStr(self.mailto))

            return self.display_ignore_list()
        elif request.GET.get("a") == "sent":
            return self.display_mails_sent()
        else:
            return self.display_mails()
    #
    # display mails received by the player
    #
    def display_mails(self):

        self.selected_menu = "mails.inbox"

        content = self.loadTemplate("mail-list")

        displayed = 30 # number of gm_mails displayed per page

        #
        # Retrieve the offset from where to begin the display
        #
        offset = ToInt(self.request.GET.get("start"), 0)
        if offset > 50: offset=50

        search_cond = ""
        if self.request.session.get(sPrivilege) < 100: search_cond = "not deleted AND "

        # get total number of mails that could be displayed
        query = "SELECT count(1) FROM gm_mails WHERE "+search_cond+" ownerid = " + str(self.userId)
        row = dbRow(query)
        size = int(row[0])
        nb_pages = int(size/displayed)
        if nb_pages*displayed < size: nb_pages = nb_pages + 1
        if offset >= nb_pages: offset = nb_pages-1

        content.AssignValue("offset", offset)

        if nb_pages > 50: nb_pages=50

        #display all links only if there are a few pages
        list = []
        content.AssignValue("ps", list)
        for i in range(1, nb_pages+1):
            item = {}
            list.append(item)
            
            item["page_id"] = i
            item["page_link"] = i-1

            if i != offset+1:
                item["link"] = True
            else:
                item["selected"] = True

            item["offset"] = offset

        content.AssignValue("min", offset*displayed+1)
        if offset+1 == nb_pages:
            content.AssignValue("max", size)
        else:
            content.AssignValue("max", (offset+1)*displayed)

        content.AssignValue("page_display", offset+1)

        #display only if there are more than 1 page
        if nb_pages > 1: content.Parse("nav")

        query = "SELECT sender, subject, body, datetime, gm_mails.id, read_date, avatar_url, gm_profiles.id, gm_mails.credits," + \
                " gm_profiles.privilege, bbcode, owner, gm_mail_ignorees.added, gm_alliances.tag" + \
                " FROM gm_mails" + \
                "    LEFT JOIN gm_profiles ON (upper(gm_profiles.login) = upper(gm_mails.sender) AND gm_mails.datetime >= gm_profiles.game_started)" + \
                "    LEFT JOIN gm_alliances ON (gm_profiles.alliance_id = gm_alliances.id)" + \
                "    LEFT JOIN gm_mail_ignorees ON (userid=" + str(self.userId) + " AND ignored_userid = gm_profiles.id)" + \
                " WHERE " + search_cond + " ownerid = " + str(self.userId) + \
                " ORDER BY datetime DESC, gm_mails.id DESC" + \
                " OFFSET " + str(offset*displayed) + " LIMIT "+str(displayed)
        rows = dbRows(query)

        i = 0
        list = []
        content.AssignValue("mails", list)
        for row in rows:
            item = {}
            list.append(item)
            
            item["index"] = i
            item["from"] = row[0]
            item["subject"] = row[1]
            item["date"] = row[3]

            if row[10]:
                item["bodybb"] = row[2]
                item["bbcode"] = True
            else:
                item["body"] = row[2].replace("\n","<br/>")
                item["html"] = True

            item["mailid"] = row[4]
            item["moneyamount"] = row[8]

            if row[8] > 0: item["money"] = True # sender has given money

            if row[9] and row[9] >= 500: item["from_admin"] = True

            if row[6] == None or row[6] == "":
                item["noavatar"] = True
            else:
                item["avatar_url"] = row[6]
                item["avatar"] = True

            if row[5] == None: item["new_mail"] = True # if there is no value for read_date: it is a new mail

            if row[7]:
                # allow the player to block/ignore another player
                if row[12]:
                    item["ignored"] = True
                else:
                    item["ignore"] = True

                if row[13]:
                    item["alliancetag"] = row[13]
                    item["alliance"] = True

                item["reply"] = True

            if row[11] == ":admins":
                item["to_admins"] = True
            elif row[11] == ":alliance":
                item["to_alliance"] = True

            if self.request.session.get(sPrivilege) > 100: item["admin"] = True

            i = i + 1

        if i == 0: content.Parse("nomails")

        if not self.IsImpersonating():
            row = dbExecute("UPDATE gm_mails SET read_date = now() WHERE ownerid = " + str(self.userId) + " AND read_date IS NULL" )

        return self.display(content)

    #
    # display mails sent by the player
    #
    def display_mails_sent(self):

        self.selected_menu = "mails.sent"

        content = self.loadTemplate("mail-sent")

        displayed = 30 # number of nations displayed per page

        #
        # Retrieve the offset from where to begin the display
        #
        offset = ToInt(self.request.GET.get("start"), 0)
        if offset > 50: offset=50

        messages_filter = "datetime > now()-INTERVAL '2 weeks' AND "

        # get total number of mails that could be displayed
        query = "SELECT count(1) FROM gm_mails WHERE "+messages_filter+"senderid = " + str(self.userId)
        row = dbRow(query)
        size = int(row[0])
        nb_pages = int(size/displayed)
        if nb_pages*displayed < size: nb_pages = nb_pages + 1

        if nb_pages > 50: nb_pages=50

        #display all links only if there are a few pages
        list = []
        content.AssignValue("ps", list)
        for i in range(1, nb_pages+1):
            item = {}
            list.append(item)
            
            item["page_id"] = i
            item["page_link"] = i-1

            if i != offset+1:
                item["link"] = True
            else:
                item["selected"] = True

            item["offset"] = offset

        content.AssignValue("min", offset*displayed+1)
        if offset+1 == nb_pages:
            content.AssignValue("max", size)
        else:
            content.AssignValue("max", (offset+1)*displayed)

        content.AssignValue("page_display", offset+1)

        #display only if there are more than 1 page
        if nb_pages > 1: content.Parse("nav")

        query = "SELECT gm_mails.id, owner, avatar_url, datetime, subject, body, gm_mails.credits, gm_profiles.id, bbcode, gm_alliances.tag" + \
                " FROM gm_mails" + \
                "    LEFT JOIN gm_profiles ON (/*upper(gm_profiles.login) = upper(gm_mails.owner)*/ gm_profiles.id = gm_mails.ownerid AND gm_mails.datetime >= gm_profiles.game_started)" + \
                "    LEFT JOIN gm_alliances ON (gm_profiles.alliance_id = gm_alliances.id)" + \
                " WHERE "+messages_filter+"senderid = " + str(self.userId) + \
                " ORDER BY datetime DESC"

        query = query + " OFFSET "+str(offset*displayed)+" LIMIT "+str(displayed)

        rows = dbRows(query)

        i = 0
        list = []
        content.AssignValue("mails", list)
        for row in rows:
            item = {}
            list.append(item)
            
            item["index"] = i
            item["sent_to"] = row[1]

            if row[1] == ":admins":
                item["admins"] = True
            elif row[1] == ":alliance":
                item["to_alliance"] = True
            else:
                item["nation"] = True

            item["date"] = row[3]
            item["subject"] = row[4]

            if row[8]:
                item["bodybb"] = row[5]
                item["bbcode"] = True
            else:
                item["body"] = row[5].replace("\n","<br/>")
                item["html"] = True

            item["mailid"] = row[0]
            item["moneyamount"] = row[6]

            if row[6] > 0: # sender has given money
                item["money"] = True

            if row[2] == None or row[2] == "":
                item["noavatar"] = True
            else:
                item["avatar_url"] = row[2]
                item["avatar"] = True

            if row[7]:
                if row[9]:
                    item["alliancetag"] = row[9]
                    item["alliance"] = True

                item["reply"] = True

            i = i + 1

        if i == 0: content.Parse("nomails")

        return self.display(content)

    def display_ignore_list(self):
        self.selected_menu = "mails.ignorelist"

        content = self.loadTemplate("mail-ignorelist")

        oRss = dbRows("SELECT ignored_userid, internal_profile_get_name(ignored_userid), added, blocked FROM gm_mail_ignorees WHERE userid=" + str(self.userId))

        i = 0
        list = []
        content.AssignValue("ignorednations", list)
        for row in rows:
            item = {}
            list.append(item)
            
            item["index"] = i
            item["userid"] = row[0]
            item["name"] = row[1]
            item["added"] = row[2]
            item["blocked"] = row[3]

            i = i + 1

        if i == 0: content.Parse("noignorednations")

        return self.display(content)

    def return_ignored_users(self):

        content = self.loadTemplate("mails")

        oRss = dbRows("SELECT internal_profile_get_name(ignored_userid) FROM gm_mail_ignorees WHERE userid=" + userid)
        list = []
        for row in rows:
            item = {}
            list.append(item)
            
            item["user"] = row[0]
            content.Parse("ignored_user")

        response.write(content.Output)

    # quote reply
    def quote_mail(self, body):

        self.sendmail_status=""
        return body.replace("\n","\n" + "> ") + "\n\n"

    # fill combobox with previously sent to
    def display_compose_form(self, mailto, subject, body, credits):

        self.selected_menu = "mails.compose"

        content = self.loadTemplate("mail-compose")

        # fill the recent addressee list

        oRss = dbRows("SELECT * FROM internal_profile_get_addressees(" + str(self.userId) + ")")

        list = []
        content.AssignValue("tos", list)
        for row in rows:
            item = {}
            list.append(item)
            
            item["to_user"] = row[0]

        if self.mailto == ":admins":
            content.Parse("sendadmins_selected")

            content.Parse("hidenation")
            content.Parse("send_credits_hide")
            self.mailto = ""
        elif self.mailto == ":alliance":
            content.Parse("sendalliance_selected")

            content.Parse("hidenation")
            content.Parse("send_credits_hide")
            self.mailto = ""
        else:
            content.Parse("nation_selected")

        if (self.allianceRights):
            if self.allianceRights["can_mail_alliance"]: content.Parse("sendalliance")

        # if is a payed account, append the autosignature text to message body
        if self.userInfo["paid"]:
            row = dbRow("SELECT autosignature FROM gm_profiles WHERE id="+userid)
            if row:
                body = body  + row[0]

        # re-assign previous values
        content.AssignValue("mailto", mailto)
        content.AssignValue("subject", subject)
        content.AssignValue("message", body)
        content.AssignValue("mail_credits", credits)

        #retrieve player's credits
        row = dbRow("SELECT credits, now()-game_started > INTERVAL '2 weeks' AND security_level >= 3 FROM gm_profiles WHERE id="+str(self.userId))
        content.AssignValue("player_credits", row[0])
        if row[1]: content.Parse("send_credits")

        if self.sendmail_status != "":
            content.Parse(self.sendmail_status)
            content.Parse("error")

        if self.bbcode: content.Parse("bbcode")

        self.FillHeaderCredits(content)

        return self.display(content)
