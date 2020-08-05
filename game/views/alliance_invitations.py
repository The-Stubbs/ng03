# -*- coding: utf-8 -*-

from game.views._base import *



################################################################################
class View(ActionView):
    
    template_name = 'game/alliance_invitations.html'
    success_url = '/game/alliance/invitations/'
    
    menu_selected = 'alliance'
    submenu_selected = 'alliance_invitations'

    #---------------------------------------------------------------------------
    def get_context(self, request, cursor, **kwargs):
        #-----------------------------------------------------------------------
        context = super().get_context(request, cursor, **kwargs)
        #-----------------------------------------------------------------------
        set oRs = oConn.Execute("SELECT date_part('epoch', const_interval_before_join_new_alliance()) / 3600")
        content.AssignValue "hours_before_rejoin", oRs(0)
        #-----------------------------------------------------------------------
        query = "SELECT alliances.tag, alliances.name, alliances_invitations.created, users.login" &_
                " FROM alliances_invitations" &_
                "		INNER JOIN alliances ON alliances.id = alliances_invitations.allianceid"&_
                "		LEFT JOIN users ON users.id = alliances_invitations.recruiterid"&_
                " WHERE userid=" & UserId & " AND NOT declined" &_
                " ORDER BY created DESC"
        context['invitations'] = 
        #-----------------------------------------------------------------------
        if not oPlayerInfo("can_join_alliance") then content.Parse "cant_join"
        #-----------------------------------------------------------------------
		set oRs = oConn.Execute("SELECT sp_alliance_get_leave_cost(" & UserId & ")")
        content.AssignValue "credits", Session(sLeaveCost)
        #-----------------------------------------------------------------------
        return context
        #-----------------------------------------------------------------------
    
    #---------------------------------------------------------------------------
    def process_action(self, request, cursor, action):
        #-----------------------------------------------------------------------
        if action == 'accept':
            #-------------------------------------------------------------------
            alliance_tag = Trim(Request.QueryString("tag"))
            #-------------------------------------------------------------------
            result = db_result(cursor, 'SELECT ua_alliance_invitation_accept(' + ')')
            if result == 0: return self.success()
            else: messages.error(request, 'error_' + str(result))
        #-----------------------------------------------------------------------
        elif action == 'decline':
            #-------------------------------------------------------------------
            alliance_tag = Trim(Request.QueryString("tag"))
            #-------------------------------------------------------------------
            result = db_result(cursor, 'SELECT ua_alliance_invitation_decline(' + ')')
            if result == 0: return self.success()
            else: messages.error(request, 'error_' + str(result))
        #-----------------------------------------------------------------------
        elif action == 'leave':
            #-------------------------------------------------------------------
            result = db_result(cursor, 'SELECT ua_alliance_leave(' + ')')
            if result == 0: return self.success()
            else: messages.error(request, 'error_' + str(result))
        #-----------------------------------------------------------------------
        return self.failed()
        #-----------------------------------------------------------------------

################################################################################
