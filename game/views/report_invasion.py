# -*- coding: utf-8 -*-

from game.views._base import *

#-------------------------------------------------------------------------------
class View(BaseView):

    def dispatch(self, request, *args, **kwargs):

        response = super().pre_dispatch(request, *args, **kwargs)
        if response: return response

        self.selected_menu = "invasion"

        invasionid = ToInt(request.GET.get("id"), 0)

        if invasionid == 0:
            return HttpResponseRedirect("/game/overview/")

        self.fleetid = ToInt(request.GET.get("fleetid"), 0)

        return self.DisplayReport(invasionid, self.userId)

    def DisplayReport(self, invasionid, readerid):

        content = self.loadTemplate("invasion")

        query = "SELECT i.id, i.time, i.planet_id, i.planet_name, i.attacker_name, i.defender_name, " + \
                "i.attacker_succeeded, i.soldiers_total, i.soldiers_lost, i.def_soldiers_total, " + \
                "i.def_soldiers_lost, i.def_scientists_total, i.def_scientists_lost, i.def_workers_total, " + \
                "i.def_workers_lost, galaxy, sector, planet, internal_profile_get_name("+str(readerid)+") " + \
                "FROM gm_invasions AS i INNER JOIN gm_planets ON gm_planets.id = i.planet_id WHERE i.id = "+str(invasionid)
        row = dbRow(query)

        if row == None:
            return HttpResponseRedirect("/game/overview/")

        viewername = row[18]

        # compare the attacker name and defender name with the name of who is reading this report
        if row[4] != viewername and row[5] != viewername and self.allianceId:
            # if we are not the attacker or defender, check if we can view this invasion as a member of our alliance of we are ambassador
            if self.allianceRights["can_see_reports"]:
                # find the name of the member that did this invasion, either the attacker or the defender
                query = "SELECT login" + \
                        " FROM gm_profiles" + \
                        " WHERE (login="+sqlStr(row[4])+" OR login="+sqlStr(row[5])+") AND alliance_id="+str(self.allianceId)+" AND alliance_joined <= (SELECT time FROM gm_invasions WHERE id="+str(invasionid)+")"
                oRs2 = dbRow(query)
                if oRs2 == None:
                    return HttpResponseRedirect("/game/overview/")
                viewername = oRs2(0)
            else:
                return HttpResponseRedirect("/game/overview/")

        content.AssignValue("planetid", row[2])
        content.AssignValue("planetname", row[3])
        content.AssignValue("g", row[15])
        content.AssignValue("s", row[16])
        content.AssignValue("p", row[17])
        content.AssignValue("planet_owner", row[5])
        content.AssignValue("fleet_owner", row[4])
        content.AssignValue("date", row[1])
        content.AssignValue("soldiers_total", row[7])
        content.AssignValue("soldiers_lost", row[8])
        content.AssignValue("soldiers_alive", row[7] - row[8])
        content.AssignValue("def_soldiers_total", row[9])
        content.AssignValue("def_soldiers_lost", row[10])
        content.AssignValue("def_soldiers_alive", row[9] - row[10])
        def_total = row[9]
        def_losts = row[10]

        if row[4] == viewername: #we are the attacker
            content.AssignValue("relation", rWar)
            # display only troops encountered by the attacker's soldiers
            if row[9]-row[10] == 0:
                # if no workers remain, display the scientists
                if row[13]-row[14] == 0:
                    def_total = def_total + row[11]
                    def_losts = def_losts + row[12]
                    content.AssignValue("def_scientists_total", row[11])
                    content.AssignValue("def_scientists_lost", row[12])
                    content.AssignValue("def_scientists_alive", row[11] - row[12])
                    content.Parse("scientists")

                # if no soldiers remain, display the workers
                def_total = def_total + row[13]
                def_losts = def_losts + row[14]
                content.AssignValue("def_workers_total", row[13])
                content.AssignValue("def_workers_lost", row[14])
                content.AssignValue("def_workers_alive", row[13] - row[14])
                content.Parse("workers")

            content.AssignValue("planetname", row[5])

            content.AssignValue("def_alive", def_total - def_losts)
            content.AssignValue("def_total", def_total)
            content.AssignValue("def_losts", def_losts)

            content.Parse("ally")
            content.Parse("attacker")
            content.Parse("enemy")
            content.Parse("defender")
        else: # ...we are the defender
            content.AssignValue("relation", rFriend)
            def_total = def_total + row[11]
            def_losts = def_losts + row[12]
            content.AssignValue("def_scientists_total", row[11])
            content.AssignValue("def_scientists_lost", row[12])
            content.AssignValue("def_scientists_alive", row[11] - row[12])
            content.Parse("scientists")
            def_total = def_total + row[13]
            def_losts = def_losts + row[14]
            content.AssignValue("def_workers_total", row[13])
            content.AssignValue("def_workers_lost", row[14])
            content.AssignValue("def_workers_alive", row[13] - row[14])
            content.Parse("workers")

            content.AssignValue("def_alive", def_total - def_losts)
            content.AssignValue("def_total", def_total)
            content.AssignValue("def_losts", def_losts)

            content.Parse("ally")
            content.Parse("defender")
            content.Parse("enemy")
            content.Parse("attacker")

        if self.fleetid != 0:
            # if a fleetid is specified, parse a link to redirect the user to the fleet
            content.AssignValue("fleetid", self.fleetid)
            content.Parse("justdone")

        if row[6]:
            content.Parse("succeeded")
        else:
            content.Parse("not_succeeded")

        content.Parse("report")
        content.Parse("invasion_report")

        return self.display(content)
