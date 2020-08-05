# -*- coding: utf-8 -*-

from game.views._base import *



################################################################################
class View(ActionView):
    
    template_name = 'game/alliance_members.html'
    success_url = '/game/alliance/members/'
    
    tab_selected = None
    menu_selected = 'alliance'
    submenu_selected = None

    #---------------------------------------------------------------------------
    def dispatch(self, request, *args, **kwargs):
        #-----------------------------------------------------------------------
        if not self.profile['alliance_id']: return HttpResponseRedirect('/game/empire/overview/')
        #-----------------------------------------------------------------------
        return super().dispatch(request, *args, **kwargs)
        #-----------------------------------------------------------------------

    #---------------------------------------------------------------------------
    def get_context(self, request, cursor, **kwargs):
        #-----------------------------------------------------------------------
        context = super().get_context(request, cursor, **kwargs)
        #-----------------------------------------------------------------------
        col = get_int(Request.QueryString("col"), 1)
        if col < 1 or col > 7 then col = 1
        select case col
            case 1
                orderby = "upper(login)"
            case 2
                orderby = "score"
                reversed = true
            case 3
                orderby = "colonies"
                reversed = true
            case 4
                orderby = "credits"
                reversed = true
            case 5
                orderby = "lastactivity"
                reversed = true
            case 6
                orderby = "alliance_joined"
                reversed = true
            case 7
                orderby = "alliance_rank"
                reversed = false
        #-----------------------------------------------------------------------
        if Request.QueryString("r") <> "" then
            reversed = not reversed
        #-----------------------------------------------------------------------
        if reversed then orderby = orderby & " DESC"
        orderby = orderby & ", upper(login)"
        #-----------------------------------------------------------------------
        query = "SELECT rankid, label" &_
                " FROM alliances_ranks" &_
                " WHERE enabled AND allianceid=" & AllianceId &_
                " ORDER BY rankid"
        context['ranks'] = db_results(cursor, query)
        #-----------------------------------------------------------------------
        query = "SELECT login, CASE WHEN id="&UserId&" OR score_visibility >=1 THEN score ELSE 0 END AS score, int4((SELECT count(1) FROM nav_planet WHERE ownerid=users.id)) AS colonies," &_
                " date_part('epoch', now()-lastactivity) / 3600, alliance_joined, alliance_rank, privilege, score-previous_score AS score_delta, id," &_
                " sp_alliance_get_leave_cost(id), credits, score_visibility, orientation, COALESCE(date_part('epoch', leave_alliance_datetime-now()), 0)" &_
                " FROM users" &_
                " WHERE alliance_id=" & AllianceId &_
                " ORDER BY " & orderby
        context['members'] = db_results(cursor, query)
        #-----------------------------------------------------------------------
        content.AssignValue "total_colonies", totalColonies
        content.AssignValue "total_credits", totalCredits
        content.AssignValue "total_score", totalScore
        content.AssignValue "total_score_delta", totalScoreDelta
        #-----------------------------------------------------------------------
        context['can_kick'] = oAllianceRights("can_kick_player")
        context['can_manage'] = oAllianceRights("leader")
        #-----------------------------------------------------------------------
        return context
        #-----------------------------------------------------------------------
    
    #---------------------------------------------------------------------------
    def process_action(self, request, cursor, action):
        #-----------------------------------------------------------------------
        if action == 'save':
            #-------------------------------------------------------------------
            result = do_action('ua_profile_update_alliance_rank', cursor, 'SELECT ua_profile_update_alliance_rank(' + ')')
            if result == 0: return self.success()
            else: messages.error(request, 'error_' + str(result))
        #-----------------------------------------------------------------------
        elif action == 'kick':
            #-------------------------------------------------------------------
            result = do_action('ua_profile_kick_alliance', cursor, 'SELECT ua_profile_kick_alliance(' + ')')
            if result == 0: return self.success()
            else: messages.error(request, 'error_' + str(result))
        #-----------------------------------------------------------------------
        return self.failed()
        #-----------------------------------------------------------------------

################################################################################
