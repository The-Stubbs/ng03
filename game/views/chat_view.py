# -*- coding: utf-8 -*-

from game.views._base import *

#-------------------------------------------------------------------------------
class View(BaseView):

    template_name = "chat-view"
    selected_menu = "chats"

    #---------------------------------------------------------------------------
    def dispatch(self, request, *args, **kwargs):

        response = super().pre_dispatch(request, *args, **kwargs)
        if response: return response
        
        return super().dispatch(request, *args, **kwargs)

    #---------------------------------------------------------------------------
    def processAction(self, request, action):
    
        # --- user data
        
        data["now"] = timezone.now()
        data["login"] = self.userInfo["login"]
        
        # --- chat instance data
        
        request.session["chatinstance"] = ToInt(request.session.get("chatinstance"), 0) + 1
        data["chatinstance"] = ToInt(request.session.get("chatinstance"), 0)
        
        # --- alliance chat data
        
        if self.allianceId:
        
            chatid = request.session.get("alliancechat_" + str(self.allianceId))
            if chatid == None or chatid == "":
            
                query = "SELECT chatid FROM gm_alliances WHERE id=" + str(self.allianceId)
                row = dbRow(query)
                if row:
                
                    request.session["alliancechat_" + str(self.allianceId)] = row[0]
                    chatid = row[0]
            
            request.session["lastchatmsg_" + str(chatid)] = ""

            data["alliance"] = True
        
        # --- chats data
        
        data["chats"] = []
        
        query = "SELECT gm_chats.id, gm_chats.name, gm_chats.topic" + \
                " FROM gm_profile_chats" + \
                "    INNER JOIN gm_chats ON (gm_chats.id=gm_profile_chats.chatid AND ((gm_chats.password = '') OR (gm_chats.password = gm_profile_chats.password)))" + \
                " WHERE userid = " + str(self.userId) + \
                " ORDER BY gm_profile_chats.added"
        rows = dbRows(query)
        if rows:
            for row in rows:
                if self.addChat(row[0]):
                    
                    chat = {}
                    data["chats"].append(chat)
                    
                    item["id"] = row[0]
                    item["name"] = row[1]
                    item["topic"] = row[2]
                    
                    request.session["lastchatmsg_" + str(row[0])] = ""
