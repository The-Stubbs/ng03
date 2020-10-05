# -*- coding: utf-8 -*-

from web_game.game._global import *



class View(GlobalView):

    def dispatch(self, request, *args, **kwargs):

        response = super().pre_dispatch(request, *args, **kwargs)
        if response: return response
        
        return super().dispatch(request, *args, **kwargs)



    def get(self, request, *args, **kwargs):
    
        self.selected_menu = "chat"

        content = GetTemplate(self.request, "chat_view")

        # --- user data

        content.AssignValue("login", self.oPlayerInfo["login"])
        content.AssignValue("now", timezone.now())

        # --- user alliance chat data

        if self.AllianceId:
        
            chatid = request.session.get("alliancechat_" + str(self.AllianceId), "")
            if chatid == "":
            
                query = "SELECT chatid FROM alliances WHERE id=" + str(self.AllianceId)
                oRs = oConnExecute(query)
                if oRs:
                
                    request.session["alliancechat_" + str(self.AllianceId)] = oRs[0]
                    chatid = oRs[0]
                    
            request.session["lastchatmsg_" + str(chatid)] = ""

            content.Parse("alliance")

        # --- user chats data

        list = []
        content.AssignValue("joins", list)
        
        query = "SELECT chat.id, chat.name, chat.topic" + \
                " FROM users_chats" + \
                "    INNER JOIN chat ON (chat.id=users_chats.chatid AND ((chat.password = '') OR (chat.password = users_chats.password)))" + \
                " WHERE userid = " + str(self.UserId) + \
                " ORDER BY users_chats.added"
        oRss = oConnExecuteAll(query)
        if oRss:
        
            for oRs in oRss:
            
                if request.session.get("chat_joined_" + str(oRs[0])) != "1":
                
                    request.session["chat_joined_count"] = ToInt(request.session.get("chat_joined_count"), 0) + 1
                    request.session["chat_joined_" + str(oRs[0])] = "1"
                
                item = {}
                list.append(item)
                
                item["id"] = oRs[0]
                item["name"] = oRs[1]
                item["topic"] = oRs[2]

                request.session["lastchatmsg_" + str(oRs[0])] = ""

        return self.Display(content)
