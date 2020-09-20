# -*- coding: utf-8 -*-

from game.views._base import *

#-------------------------------------------------------------------------------
class View(BaseMixin, View):

    def dispatch(self, request, *args, **kwargs):

        response = super().pre_dispatch(request, *args, **kwargs)
        if response: return response
        
        battlekey = request.GET.get("key","")
        if battlekey == "": return HttpResponseRedirect("/game/gm_profile_reports/")
        
        creator = request.GET.get("by","")
        if creator == "": return HttpResponseRedirect("/game/gm_profile_reports/")
        
        fromview = request.GET.get("v","")
        if fromview == "": return HttpResponseRedirect("/game/gm_profile_reports/")
        
        id = request.GET.get("id","")
        if id == "": return HttpResponseRedirect("/game/gm_profile_reports/")

        oKeyRs = dbRow(" SELECT 1 FROM gm_battles WHERE id="+str(id)+" AND "+sqlStr(battlekey)+"=MD5(key||"+sqlStr(creator)+")")
        if oKeyRs == None: return HttpResponseRedirect("/game/gm_profile_reports/")
        
        content = formatBattle(self, id, creator, fromview, True)
        
        content.AssignValue("skin","s_transparent")
        content.AssignValue("timers_enabled","false")
        content.AssignValue("server", universe)
        
        return render(self.request, content.template, content.data)
