# -*- coding: utf-8 -*-

from game.views._base import *

#-------------------------------------------------------------------------------
class View(BaseView):

    template_name = "alliance-reports"
    selected_menu = "alliance.reports"

    #---------------------------------------------------------------------------
    def dispatch(self, request, *args, **kwargs):

        response = super().pre_dispatch(request, *args, **kwargs)
        if response: return response

        if self.allianceId == None: return HttpResponseRedirect("/game/alliance/")
        if not self.hasRight("can_see_reports"): return HttpResponseRedirect("/game/alliance/")
        
        return super().dispatch(request, *args, **kwargs)

    #---------------------------------------------------------------------------
    def fillContent(self, request, data):

        # --- navigation data
        
        cat = ToInt(request.GET.get("cat"), 0)
        data["cat"] = cat
    
        data["tabnav_000"] = True
        data["tabnav_100"] = True
        data["tabnav_200"] = True
        data["tabnav_800"] = True

        # --- reports data
        
        data["reports"] = []
        
        query = "SELECT type, subtype, datetime, battleid, fleetid, fleet_name," + \
                " planetid, planet_name, galaxy, sector, planet," + \
                " researchid, 0, read_date," + \
                " planet_relation, planet_ownername," + \
                " ore, hydrocarbon, credits, scientists, soldiers, workers, username," + \
                " alliance_tag, alliance_name," + \
                " invasionid, spyid, spy_key, description, ownerid, invited_username, login, buildingid" + \
                " FROM vw_gm_alliance_reports" + \
                " WHERE ownerallianceid = " + str(self.allianceId)
        if cat == 0: query = query + " ORDER BY datetime DESC LIMIT 200"
        else: query = query + " AND type = " + str(cat) + " ORDER BY datetime DESC LIMIT 200"
        rows = dbRows(query)
        if rows:
            for row in rows:
            
                type = row[0] * 100 + row[1]
                if type != 133:
                    
                    report = {}
                    data["reports"].append(report)
                    
                    report["ownerid"] = row[29]
                    report["invitedusername"] = row[30]
                    report["nation"] = row[31]
                    report["type"] = type
                    report["date"] = row[2]
                    report["battleid"] = row[3]
                    report["fleetid"] = row[4]
                    report["fleetname"] = row[5]
                    report["planetid"] = row[6]
                    report["g"] = row[8]
                    report["s"] = row[9]
                    report["p"] = row[10]
                    report["researchid"] = row[11]
                    report["ore"] = row[16]
                    report["hydrocarbon"] = row[17]
                    report["credits"] = row[18]
                    report["scientists"] = row[19]
                    report["soldiers"] = row[20]
                    report["workers"] = row[21]
                    report["username"] = row[22]
                    report["alliancetag"] = row[23]
                    report["alliancename"] = row[24]
                    report["invasionid"] = row[25]
                    report["spyid"] = row[26]
                    report["spykey"] = row[27]
                    report["description"] = row[28]
        
                    if row[14] in [rHostile, rWar]: report["planetname"] = row[15]
                    elif row[14] in [rFriend, rAlliance, rSelf]: report["planetname"] = row[7]
                    else: report["planetname"] = ""
        
                    if row[11]: item["researchname"] = getResearchLabel(row[11])
                
                    if row[32]: item["building"] = getBuildingLabel(row[32])
