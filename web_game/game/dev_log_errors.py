# -*- coding: utf-8 -*-

from web_game.game._global import *

class View(GlobalView):

    def dispatch(self, request, *args, **kwargs):

        response = super().pre_dispatch(request, *args, **kwargs)
        if response: return response

        self.selected_menu = "log_errors"

        if self.request.session.get("privilege") < 100:
            response.Redirect "/"

        return self.DisplayForm()

    def DisplayForm(self):

        content = GetTemplate(self.request, "dev-log-errors")

        query = "SELECT id, err_asp_code, err_number, err_source, err_category, err_file, err_line, err_column, err_description, err_aspdescription, datetime, ""user"", details, url" + \
                " FROM log_http_errors" + \
                " WHERE datetime > now()-INTERVAL '3 days# OR id > (SELECT COALESCE(dev_lasterror, 0) FROM users WHERE id=" + self.request.session.get(sLogonself.UserId) + ")" + \
                " ORDER BY datetime DESC" + \
                " LIMIT 400"

        oRss = oConnExecuteAll(query)

        if oRss:
            oConnDoQuery("UPDATE users SET dev_lasterror=" + oRs[0] + " WHERE id=" + self.request.session.get(sLogonself.UserId)

        list = []
        for oRs in oRss:
            item = {}
            list.append(item)
            
            item["err_asp_code", oRs[1]
            item["err_number", oRs[2]
            item["err_source", oRs[3]
            item["err_category", oRs[4]
            item["err_file", oRs[5]
            item["err_line", oRs[6]
            item["err_column", oRs[7]
            item["err_description", oRs[8]
            item["err_aspdescription", oRs[9]
            item["timestamp", oRs[10]
            item["user", oRs[11]
            item["details", oRs[12]
            item["url", oRs[13]

            content.Parse("error"

        return self.Display(content)

