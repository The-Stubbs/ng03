# -*- coding: utf-8 -*-

from game.views._base import *



################################################################################
class View(TemplateView):
    
    template_name = 'game/alliance_displaying.html'
    
    tab_selected = None
    menu_selected = 'alliance'
    submenu_selected = None

    #---------------------------------------------------------------------------
    def dispatch(self, request, *args, **kwargs):
        #-----------------------------------------------------------------------
        self.tag = request.GET.get('tag', '')
        if self.tag == '' and not self.profile['alliance_id']: return HttpResponseRedirect('/game/alliance/invitations/')
        #-----------------------------------------------------------------------
        return super().dispatch(request, *args, **kwargs)
        #-----------------------------------------------------------------------
    
    #---------------------------------------------------------------------------
    def get_context(self, request, cursor, **kwargs):
        #-----------------------------------------------------------------------
        context = super().get_context(request, cursor, **kwargs)
        #-----------------------------------------------------------------------
        query = 'SELECT name, tag, description, created, (SELECT count(*) FROM gm_profiles WHERE alliance_id=gm_alliances.id) AS members, logo_url, max_members FROM gm_alliances'
        if self.tag == '': context['alliance'] = db_result(cursor, query + ' WHERE id=' + str(self.profile['alliance_id']))
        else: context['alliance'] = db_result(cursor, query + ' WHERE tag=UPPER(' + sql_str(self.tag) + ') LIMIT 1')
        #-----------------------------------------------------------------------
        query = "SELECT tag, name" &_
        " FROM alliances_naps INNER JOIN alliances ON (alliances_naps.allianceid1=alliances.id)" &_
        " WHERE allianceid2=" & alliance_id
        context['naps'] = db_results(cursor, query)
        #-----------------------------------------------------------------------
        query = "SELECT alliances.tag, alliances.name"&_
                " FROM alliances_wars" &_
                "	INNER JOIN alliances ON (allianceid2 = alliances.id)" &_
                " WHERE allianceid1=" & alliance_id &_
                " UNION " &_
                "SELECT alliances.tag, alliances.name"&_
                " FROM alliances_wars" &_
                "	INNER JOIN alliances ON (allianceid1 = alliances.id)" &_
                " WHERE allianceid2=" & alliance_id
        context['wars'] = db_results(cursor, query)
        #-----------------------------------------------------------------------
		query = "SELECT rankid, label" &_
				" FROM alliances_ranks" &_
				" WHERE members_displayed AND allianceid=" & alliance_id &_
				" ORDER BY rankid"
        context['ranks'] = db_results(cursor, query)
        #-----------------------------------------------------------------------
        for rank in context['ranks']:
			query = "SELECT login" &_
					" FROM users" &_
					" WHERE alliance_id=" & alliance_id & " AND alliance_rank = " & dosql(rank['rankid']) &_
					" ORDER BY upper(login)"
            rank['members'] = db_results(cursor, query)
        #-----------------------------------------------------------------------
        return context
        #-----------------------------------------------------------------------

################################################################################
