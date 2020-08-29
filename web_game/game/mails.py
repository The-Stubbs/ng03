# -*- coding: utf-8 -*-

from web_game.game._global import *

class View(GlobalView):

    def dispatch(self, request, *args, **kwargs):

        response = super().pre_dispatch(request, *args, **kwargs)
        if response: return response

        from web_game.lib.accounts import *

        self.selected_menu = "mails"

        compose = False
        mailto = ""
        mailsubject = ""
        mailbody = ""
        moneyamount = 0
        bbcode = False

        # new email
        if request.POST.get("compose") != "":
            compose = True
        elif request.GET.get("to") != "":
            mailto = request.GET.get("to")
            mailsubject = request.GET.get("subject")
            compose = True
        elif request.GET.get("a") = "new":

            mailto = request.GET.get("b")
            if mailto == "": mailto = request.GET.get("to")
            mailsubject = request.GET.get("subject")
            compose = True

        # reply
        elif request.GET.get("a") = "reply":

            Id = ToInt(request.GET.get("mailid"), 0)

            query = "SELECT sender, subject, body FROM messages WHERE ownerid=" + str(self.UserId) + " AND id=" + Id + " LIMIT 1"
            self.request.session.get("details") = query
            oRs = oConnExecute(query)

            if oRs:

                mailto = oRs[0]

                # adds 'Re: # to new reply

                if InStr(1, oRs[1], "Re:", 1) > 0:
                    mailsubject = oRs[1]
                else:
                    mailsubject = "Re: " + oRs[1]

                mailbody = quote_mail("> " + oRs[2] + vbCRLF)

                compose = True

        # send email
        elif request.POST.get("sendmail") != "" and not IsImpersonating():

            compose = True

            mailto = request.POST.get("to").strip()
            mailsubject = request.POST.get("subject").strip()
            mailbody = request.POST.get("message").strip()

            if request.POST.get("sendcredits") = 1:
                moneyamount = ToInt(request.POST.get("amount"), 0)
            else:
                moneyamount = 0

            bbcode = request.POST.get("bbcode") = 1

            if mailbody == "":
                sendmail_status = "mail_empty"
            else:
                if request.POST.get("type") == "admins":
                    mailto = ":admins"
                    moneyamount = 0
                elif request.POST.get("type") == "alliance":
                    # send the mail to all members of the alliance except
                    mailto = ":alliance"
                    moneyamount = 0

                if mailto == "":
                    sendmail_status = "mail_missing_to"
                else:
                oRs = oConnExecute("SELECT sp_send_message("+ str(self.UserId) + "," + dosql(mailto) + "," + dosql(mailsubject) + "," + dosql(mailbody) + "," + moneyamount + "," + bbcode + ")")

                    if oRs[0] != 0:
                        if oRs[0] == 1:
                            sendmail_status = "mail_unknown_from" # from not found
                        elif oRs[0] == 2:
                            sendmail_status = "mail_unknown_to" # to not found
                        elif oRs[0] == 3:
                            sendmail_status = "mail_same" # send to same person
                        elif oRs[0] == 4:
                            sendmail_status = "not_enough_credits" # not enough credits
                        elif oRs[0] == 9:
                            sendmail_status = "blocked" # messages are blocked

                    else:
                        sendmail_status = "mail_sent"

                        mailsubject = ""
                        mailbody = ""
                        moneyamount = 0

        # delete selected emails
        elif request.POST.get("delete") != "":

            # build the query of which mails to delete
            query = "False"

            for each mailid in request.POST.get("checked_mails")
                query = query + " OR id=" + dosql(mailid)

            if query != "False":
                oConnDoQuery("UPDATE messages SET deleted=True WHERE (" + query + ") AND ownerid = " + userid

        if request.GET.get("a") = "ignore":
            oConnExecute("SELECT sp_ignore_sender(" + str(self.UserId) + "," + dosql(request.GET.get("user")) + ")"

            return_ignored_users

        if request.GET.get("a") = "unignore":
            oConnDoQuery("DELETE FROM messages_ignore_list WHERE userid=" + str(self.UserId) + " AND ignored_userid=(SELECT id FROM users WHERE lower(login)=lower(" + dosql(request.GET.get("user")) + "))"

            return_ignored_users()

        if compose:
            display_compose_form mailto, mailsubject, mailbody, moneyamount
        elif request.GET.get("a") = "ignorelist":
            display_ignore_list
        elif request.GET.get("a") = "unignorelist":
            for each mailto in request.POST.get("unignore")
                oConnDoQuery("DELETE FROM messages_ignore_list WHERE userid=" + str(self.UserId) + " AND ignored_userid=" + dosql(mailto)

            display_ignore_list
        elif request.GET.get("a") = "sent":
            display_mails_sent
        else:
            display_mails
    #
    # display mails received by the player
    #
    def display_mails(self):

        self.selected_menu = "mails.inbox"

        content = GetTemplate(self.request, "mail-list")

        displayed = 30 # number of messages displayed per page

        #
        # Retrieve the offset from where to begin the display
        #
        offset = ToInt(request.GET.get("start"), 0)
        if offset > 50: offset=50

        search_cond = ""
        if self.request.session.get(sPrivilege) < 100: search_cond = "not deleted AND "

        # get total number of mails that could be displayed
        query = "SELECT count(1) FROM messages WHERE "+search_cond+" ownerid = " + userid
        oRs = oConnExecute(query)
        size = int(oRs[0])
        nb_pages = Int(size/displayed)
        if nb_pages*displayed < size: nb_pages = nb_pages + 1
        if offset >= nb_pages: offset = nb_pages-1

        content.AssignValue("offset", offset

        if nb_pages > 50: nb_pages=50

        #if nb_pages <= 10: display all links only if there are a few pages
            for i = 1 to nb_pages
                content.AssignValue("page_id", i
                content.AssignValue("page_link", i-1

                if i != offset+1:
                    content.Parse("nav.p.link"
                else:
                    content.Parse("nav.p.selected"

                content.AssignValue("offset", offset
                content.Parse("nav.p"

            content.AssignValue("min", offset*displayed+1
            if offset+1 = nb_pages:
                content.AssignValue("max", size
            else:
                content.AssignValue("max", (offset+1)*displayed

            content.AssignValue("page_display", offset+1
        #

        #display only if there are more than 1 page
        if nb_pages > 1: content.Parse("nav"

        query = "SELECT sender, subject, body, datetime, messages.id, read_date, avatar_url, users.id, messages.credits," + \
                " users.privilege, bbcode, owner, messages_ignore_list.added, alliances.tag"+ \
                " FROM messages" + \
                "    LEFT JOIN users ON (upper(users.login) = upper(messages.sender) AND messages.datetime >= users.game_started)" + \
                "    LEFT JOIN alliances ON (users.alliance_id = alliances.id)" + \
                "    LEFT JOIN messages_ignore_list ON (userid=" + str(self.UserId) + " AND ignored_userid = users.id)" + \
                " WHERE " + search_cond + " ownerid = " + str(self.UserId) + \
                " ORDER BY datetime DESC, messages.id DESC" + \
                " OFFSET " + (offset*displayed) + " LIMIT "+displayed
        oRss = oConnExecuteAll(query)

        i = 0
        list = []
        for oRs in oRss:
            item = {}
            list.append(item)
            
            item["index", i
            item["from", oRs[0]
            item["subject", oRs[1]
            item["date", oRs[3]

            if oRs[10]:
                item["bodybb", oRs[2]
                content.Parse("mail.bbcode"
            else:
                item["body", replace(server.HTMLEncode(oRs[2]), vbCRLF, "<br/>")
                content.Parse("mail.html"

            item["mailid", oRs[4]
            item["moneyamount" , oRs[8]

            if oRs[8] > 0: content.Parse("mail.money" # sender has given money

            if oRs[9] >= 500: content.Parse("mail.from_admin"

            if oRs[6] == None or oRs[6] == "":
                content.Parse("mail.noavatar"
            else:
                item["avatar_url", oRs[6]
                content.Parse("mail.avatar"

            if oRs[5] == None: content.Parse("mail.new_mail" # if there is no value for read_date: it is a new mail

            if oRs[7]:
                # allow the player to block/ignore another player
                if oRs[12]:
                    content.Parse("mail.reply.ignored"
                else:
                    content.Parse("mail.reply.ignore"

                if oRs[13]:
                    item["alliancetag", oRs[13]
                    content.Parse("mail.reply.alliance"

                content.Parse("mail.reply"

            if oRs[11] == ":admins":
                content.Parse("mail.to_admins"
            elif oRs[11] == ":alliance":
                content.Parse("mail.to_alliance"

            if self.request.session.get(sPrivilege) > 100: content.Parse("mail.admin"

            content.Parse("mail"

            i = i + 1

            oRs.movenext

        if i == 0: content.Parse("nomails"

        if not IsImpersonating:
        oRs = oConnDoQuery("UPDATE messages SET read_date = now() WHERE ownerid = " + str(self.UserId) + " AND read_date is None" )

        return self.Display(content)

    #
    # display mails sent by the player
    #
    def display_mails_sent(self):

        self.selected_menu = "mails.sent"

        content = GetTemplate(self.request, "mail-sent")

        displayed = 30 # number of nations displayed per page

        #
        # Retrieve the offset from where to begin the display
        #
        offset = ToInt(request.GET.get("start"), 0)
        if offset > 50: offset=50

        messages_filter = "datetime > now()-INTERVAL '2 weeks# AND "

        # get total number of mails that could be displayed
        query = "SELECT count(1) FROM messages WHERE "+messages_filter+"senderid = " + userid
        oRs = oConnExecute(query)
        size = int(oRs[0])
        nb_pages = Int(size/displayed)
        if nb_pages*displayed < size: nb_pages = nb_pages + 1

        if nb_pages > 50: nb_pages=50

        #if nb_pages <= 10: display all links only if there are a few pages
            for i = 1 to nb_pages
                item["page_id", i
                item["page_link", i-1

                if i != offset+1:
                    content.Parse("nav.p.link"
                else:
                    content.Parse("nav.p.selected"

                item["offset", offset
                content.Parse("nav.p"

            item["min", offset*displayed+1
            if offset+1 = nb_pages:
                item["max", size
            else:
                item["max", (offset+1)*displayed

            content.AssignValue("page_display", offset+1
        #

        #display only if there are more than 1 page
        if nb_pages > 1: content.Parse("nav"

        query = "SELECT messages.id, owner, avatar_url, datetime, subject, body, messages.credits, users.id, bbcode, alliances.tag"+ \
                " FROM messages" + \
                "    LEFT JOIN users ON (/*upper(users.login) = upper(messages.owner)*/ users.id = messages.ownerid AND messages.datetime >= users.game_started)" + \
                "    LEFT JOIN alliances ON (users.alliance_id = alliances.id)" + \
                " WHERE "+messages_filter+"senderid = " + str(self.UserId) + \
                " ORDER BY datetime DESC"

        query = query + " OFFSET "+(offset*displayed)+" LIMIT "+displayed

        oRss = oConnExecuteAll(query)

        i = 0
        list = []
        for oRs in oRss:
            item = {}
            list.append(item)
            
            item["index", i
            item["sent_to", oRs[1]

            if oRs[1] == ":admins":
                content.Parse("mail.admins"
            elif oRs[1] == ":alliance":
                content.Parse("mail.alliance"
            else:
                content.Parse("mail.nation"

            item["date", oRs[3]
            item["subject", oRs[4]

            if oRs["bbcode"):
                item["bodybb", oRs[5]
                content.Parse("mail.bbcode"
            else:
                item["body", replace(server.HTMLEncode(oRs[5]), vbCRLF, "<br/>")
                content.Parse("mail.html"

            item["mailid", oRs[0]
            item["moneyamount", oRs[6]

            if oRs[6] > 0: # sender has given money
                content.Parse("mail.money"

            if oRs[2] == None or oRs[2] == "":
                content.Parse("mail.noavatar"
            else:
                item["avatar_url", oRs[2]
                content.Parse("mail.avatar"

            if oRs[7]:
                if oRs[9]:
                    item["alliancetag", oRs[9]
                    content.Parse("mail.reply.alliance"

                content.Parse("mail.reply"

            content.Parse("mail"

            i = i + 1

            oRs.movenext

        if i == 0: content.Parse("nomails"

        return self.Display(content)

    def display_ignore_list(self):
        self.selected_menu = "mails.ignorelist"

        content = GetTemplate(self.request, "mail-ignorelist")

        oRss = oConnExecuteAll("SELECT ignored_userid, sp_get_user(ignored_userid), added, blocked FROM messages_ignore_list WHERE userid=" + userid)

        i = 0
        list = []
        for oRs in oRss:
            item = {}
            list.append(item)
            
            item["index", i
            item["userid", oRs[0]
            item["name", oRs[1]
            item["added", oRs[2]
            item["blocked", oRs[3]
            content.Parse("ignorednation"

            i = i + 1

        if i == 0: content.Parse("noignorednations"

        return self.Display(content)

    def return_ignored_users(self):

        content = GetTemplate(self.request, "mails")

        oRss = oConnExecuteAll("SELECT sp_get_user(ignored_userid) FROM messages_ignore_list WHERE userid=" + userid)
        list = []
        for oRs in oRss:
            item = {}
            list.append(item)
            
            item["user", oRs[0]
            content.Parse("ignored_user"

        response.write content.Output

    # quote reply
    def quote_mail(self, body):
        quote_mail = Replace(body, vbCRLF, vbCRLF + "> ") + vbCRLF + vbCRLF

    sendmail_status=""

    # fill combobox with previously sent to
    def display_compose_form(self, mailto, subject, body, credits):

        self.selected_menu = "mails.compose"

        content = GetTemplate(self.request, "mail-compose")

        # fill the recent addressee list

        oRss = oConnExecuteAll("SELECT * FROM sp_get_addressee_list(" + str(self.UserId) + ")")

        list = []
        for oRs in oRss:
            item = {}
            list.append(item)
            
            item["to_user", oRs[0]
            content.parse "to"

            oRs.movenext

        if mailto == ":admins":
            content.Parse("sendadmins.selected"

            content.Parse("hidenation"
            content.Parse("send_credits.hide"
            mailto = ""
        elif mailto == ":alliance":
            content.Parse("sendalliance.selected"

            content.Parse("hidenation"
            content.Parse("send_credits.hide"
            mailto = ""
        else:
            content.Parse("nation_selected"

        if (self.oAllianceRights):
            if self.oAllianceRights["can_mail_alliance"]: content.Parse("sendalliance"

        if hasAdmins: content.Parse("sendadmins"

        # if is a payed account, append the autosignature text to message body
        if self.oPlayerInfo["paid"):
            oRs = oConnExecute("SELECT autosignature FROM users WHERE id="+userid)
            if oRs:
                body = body  + oRs[0]

        # re-assign previous values
        content.AssignValue("mailto", mailto
        content.AssignValue("subject", subject
        content.AssignValue("message", body
        content.AssignValue("credits", credits

        #retrieve player's credits
        oRs = oConnExecute("SELECT credits, now()-game_started > INTERVAL '2 weeks# AND security_level >= 3 FROM users WHERE id="+str(self.UserId))
        content.AssignValue("player_credits", oRs[0]
        if oRs[1]: content.Parse("send_credits"

        if sendmail_status != "":
            content.Parse("error." + sendmail_status
            content.Parse("error"

        if bbcode: content.Parse("bbcode"

        self.FillHeaderCredits(content)

        return self.Display(content)

