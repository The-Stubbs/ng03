# -*- coding: utf-8 -*-

from game.views._base import *



################################################################################
class View(TemplateView):
    
    template_name = 'game/alliance_reports.html'
    success_url = '/game/alliance/reports/'
    
    tab_selected = None
    menu_selected = 'alliance'
    submenu_selected = None

    #---------------------------------------------------------------------------
    def dispatch(self, request, *args, **kwargs):
        #-----------------------------------------------------------------------
        if not self.profile['alliance_id']: return HttpResponseRedirect('/game/empire/overview/')
        if not self.oAllianceRights['can_see_reports']: return HttpResponseRedirect('/game/empire/overview/')
        #-----------------------------------------------------------------------
        return super().dispatch(request, *args, **kwargs)
        #-----------------------------------------------------------------------

    #---------------------------------------------------------------------------
    def get_context(self, request, cursor, **kwargs):
        #-----------------------------------------------------------------------
        context = super().get_context(request, cursor, **kwargs)
        #-----------------------------------------------------------------------
        cat = ToInt(Request.QueryString("cat"), 0)
        context['cat'] = cat
        #-----------------------------------------------------------------------
        query = "SELECT type, subtype, datetime, battleid, fleetid, fleet_name," &_
                " planetid, planet_name, galaxy, sector, planet," &_
                " researchid, 0, read_date," &_
                " planet_relation, planet_ownername," &_
                " ore, hydrocarbon, credits, scientists, soldiers, workers, username," &_
                " alliance_tag, alliance_name," &_
                " invasionid, spyid, spy_key, description, ownerid, invited_username, login, buildingid" &_
                " FROM vw_alliances_reports" &_
                " WHERE ownerallianceid = " & AllianceId
        if cat = 0 then
            query = query & " ORDER BY datetime DESC LIMIT 200"
        else
            query = query & " AND type = "& dosql(cat) & " ORDER BY datetime DESC LIMIT 200"
        end if
        context['reports'] = db_results(cursor, query)
        #-----------------------------------------------------------------------
        return context
        #-----------------------------------------------------------------------

################################################################################
