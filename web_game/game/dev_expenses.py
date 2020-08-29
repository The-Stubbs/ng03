# -*- coding: utf-8 -*-

from web_game.game._global import *

class View(GlobalView):

    def dispatch(self, request, *args, **kwargs):

        response = super().pre_dispatch(request, *args, **kwargs)
        if response: return response

        self.selected_menu = "player_expenses"

        if self.request.session.get("privilege") < 100:
            response.Redirect "/"

        DisplayForm()

    def DisplayForm(self):

        content = GetTemplate(self.request, "dev-expenses")

        query = "SELECT datetime, e.credits, credits_delta," + \
                " buildingid, shipid, researchid, quantity, fleetid, fleets.name AS fleetname," + \
                " e.planetid, nav_planet.name AS planetname, nav_planet.galaxy, nav_planet.sector, nav_planet.planet," + \
                " e.ore, e.hydrocarbon, to_alliance, to_user, users.login, leave_alliance, spyid, e.scientists, e.soldiers" + \
                " FROM users_expenses e" + \
                "    LEFT JOIN nav_planet ON e.planetid=nav_planet.id" + \
                "    LEFT JOIN fleets ON fleetid=fleets.id" + \
                "    LEFT JOIN users ON to_user=users.id" + \
                " WHERE userid=" + str(self.UserId) + \
                " ORDER BY datetime DESC"
        oRss = oConnExecuteAll(query)

        list = []
        for oRs in oRss:
            item = {}
            list.append(item)
            
            item["timestamp", oRs[0]
            item["credits", oRs[1]
            item["credits_delta", oRs[2]

            item["planetname", oRs["planetname")
            item["g", oRs["galaxy")
            item["s", oRs["sector")
            item["p", oRs["planet")

            if (oRs["quantity")): item["quantity", oRs["quantity")

            if (oRs["buildingid")):
                item["building", GetBuildingLabel(oRs["buildingid"))
                content.Parse("expense.build_building"

            if (oRs["shipid")):
                item["ship", GetShipLabel(oRs["shipid"))
                content.Parse("expense.build_ship"

            if (oRs["researchid")):
                item["research", getResearchLabel(oRs["researchid"))
                content.Parse("expense.research"

            if (oRs["spyid")):
                item["spyid", oRs["spyid")
                content.Parse("expense.spy"

            if (oRs["to_user")):
                item["to_user", oRs["to_user")
                item["username", oRs["login")
                content.Parse("expense.sent"

            if (oRs["leave_alliance")):
                content.Parse("expense.leave_alliance"

            if (oRs["scientists")):
                item["scientists", oRs["scientists")
                item["soldiers", oRs["soldiers")
                content.Parse("expense.train"

            if (oRs["to_alliance")):
                content.Parse("expense.to_alliance"

            if (oRs["ore")):
                item["ore", oRs["ore")
                item["hydrocarbon", oRs["hydrocarbon")
                content.Parse("expense.buy"

            if (oRs["fleetid")):
                item["fleetname", oRs["fleetname")
                content.Parse("expense.movefleet"

            content.Parse("expense"

        self.FillHeaderCredits(content)

        return self.Display(content)

