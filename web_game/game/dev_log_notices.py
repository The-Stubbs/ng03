# -*- coding: utf-8 -*-

from web_game.game._global import *

class View(GlobalView):

    def dispatch(self, request, *args, **kwargs):

        response = super().pre_dispatch(request, *args, **kwargs)
        if response: return response

        self.selected_menu = "log_notices"

        if self.request.session.get("privilege") < 100:
            response.Redirect "/"

        return self.DisplayForm(True)

    def DisplayForm(self, showall):

        content = GetTemplate(self.request, "dev-log-notices")

        query = "SELECT id, datetime, username, title, details, url, repeats, level" + \
                " FROM log_notices" + \
                " WHERE datetime > now()-INTERVAL '3 days# OR id > (SELECT COALESCE(dev_lastnotice, 0) FROM users WHERE id=" + self.request.session.get(sLogonself.UserId) + ")" + \
                " ORDER BY datetime DESC" + \
                " LIMIT 400"

        oRss = oConnExecuteAll(query)

        if oRss: oConnDoQuery("UPDATE users SET dev_lastnotice=" + oRs[0] + " WHERE id=" + self.request.session.get(sLogonself.UserId)

        list = []
        for oRs in oRss:
            item = {}
            list.append(item)
            
            item["timestamp", oRs[1]
            item["username", oRs[2]
            item["title", oRs[3]
            item["details", oRs[4]
            item["url", oRs[5]

            if oRs[6] > 1:
                item["repeats", oRs[6]
                content.Parse("notice.repeats"

            if oRs[7] = 1:
                content.Parse("notice.level1"
                show = True
            elif oRs[7] = 2:
                content.Parse("notice.level2"
                show = True
            elif oRs[6] > 1:
                content.Parse("notice.level1"
                show = True

            if showall or show: content.Parse("notice"

        return self.Display(content)

