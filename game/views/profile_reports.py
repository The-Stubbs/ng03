# -*- coding: utf-8 -*-

from game.views._base import *

#-------------------------------------------------------------------------------
class View(BaseView):
    
    success_url = ""
    template_name = ""
    selected_menu = ""

    #---------------------------------------------------------------------------
    def dispatch(self, request, *args, **kwargs):

        response = super().pre_dispatch(request, *args, **kwargs)
        if response: return response
        
        return super().dispatch(request, *args, **kwargs)

    #---------------------------------------------------------------------------
    def display_mails(self, cat):
        
        content = self.loadTemplate("gm_profile_reports")

        query = "SELECT type, subtype, datetime, battleid, fleetid, fleet_name," + \
                " planetid, planet_name, galaxy, sector, planet," + \
                " researchid, 0, read_date," + \
                " planet_relation, planet_ownername," + \
                " ore, hydro, credits, scientists, soldiers, workers, username," + \
                " alliance_tag, alliance_name," + \
                " invasionid, spyid, spy_key, description, buildingid," + \
                " upkeep_commanders, upkeep_planets, upkeep_scientists, upkeep_ships, upkeep_ships_in_position, upkeep_ships_parked, upkeep_soldiers," + \
                " name" + \
                " FROM vw_gm_profile_reports" + \
                " WHERE ownerid = " + str(self.userId)

        #
        # Limit the list to the current category or only display 100 gm_profile_reports if no categories specified
        #
        if cat == 0:
            query = query + " ORDER BY datetime DESC LIMIT 100"
        else:
            query = query + " AND type = "+ str(cat) + " ORDER BY datetime DESC LIMIT 1000"

        content.AssignValue("ownerid", self.userId)
        
        rows = dbRows(query)
        content.Parse("tabnav_"+str(cat)+"00_selected")
        if oRss == None: content.Parse("noreports")
        else:
            #
            # List the gm_profile_reports returned by the query
            #
            gm_profile_reports = []
            for row in rows:

                reportType = row[0]*100+row[1]

                if reportType != 140 and reportType != 141 and reportType != 142 and reportType != 133:
                    report = {}

                    report["type"] = reportType
                    report["date"] = row[2]

                    report["battleid"] = row[3]
                    report["fleetid"] = row[4]
                    report["fleetname"] = row[5]
                    report["planetid"] = row[6]

                    if row[14] in [rHostile, rWar, rFriend]:
                        report["planetname"] = row[15]
                    elif row[14] in [rAlliance, rSelf]:
                        report["planetname"] = row[7]
                    else:
                        report["planetname"] = ""

                    # assign planet coordinates
                    if row[8]:
                        report["g"] = row[8]
                        report["s"] = row[9]
                        report["p"] = row[10]

                    report["researchid"] = row[11]

                    if row[11]: report["researchname"] = getResearchLabel(row[11])

                    if row[13] == None: report["new"] = True

                    report["ore"] = row[16]
                    report["hydro"] = row[17]
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

                    if row[29]: report["building"] = getBuildingLabel(row[29])

                    report["upkeep_commanders"] = row[30]
                    report["upkeep_planets"] = row[31]
                    report["upkeep_scientists"] = row[32]
                    report["upkeep_ships"] = row[33]
                    report["upkeep_ships_in_position"] = row[34]
                    report["upkeep_ships_parked"] = row[35]
                    report["upkeep_soldiers"] = row[36]

                    report["commandername"] = row[37]

                    gm_profile_reports.append(report)
                    
            content.AssignValue("gm_mails", gm_profile_reports)

            #
            # List how many new gm_profile_reports there are for each category
            #
            query = "SELECT r.type, int4(COUNT(1))" + \
                    " FROM gm_profile_reports AS r" + \
                    " WHERE datetime <= now()" + \
                    " GROUP BY r.type, r.ownerid, r.read_date" + \
                    " HAVING r.ownerid = " + str(self.userId) + " AND read_date is null"
            rows = dbRows(query)
            
            total_newreports = 0
            for row in rows:
                content.AssignValue("tabnav_"+str(row[0])+"00_newreports", row[1])
                content.Parse("tabnav_"+str(row[0])+"00_new")

                total_newreports = total_newreports + row[1]

            if total_newreports != 0:
                content.AssignValue("total_newreports", total_newreports)
                content.Parse("tabnav_000_new")
            
            if not self.IsImpersonating():
                # flag only the current category of gm_profile_reports as read
                if cat != 0:
                    dbExecute("UPDATE gm_profile_reports SET read_date = now() WHERE ownerid = " + str(self.userId) + " AND type = "+str(cat)+ " AND read_date is null AND datetime <= now()")

                # flag all gm_profile_reports as read
                if self.request.GET.get("cat","") == "0":
                    dbExecute("UPDATE gm_profile_reports SET read_date = now() WHERE ownerid = " + str(self.userId) + " AND read_date is null AND datetime <= now()")
            
        content.Parse("tabnav_000")
        content.Parse("tabnav_100")
        content.Parse("tabnav_200")
        content.Parse("tabnav_300")
        content.Parse("tabnav_400")
        content.Parse("tabnav_500")
        content.Parse("tabnav_600")
        content.Parse("tabnav_700")
        content.Parse("tabnav_800")
        content.Parse("tabnav")
