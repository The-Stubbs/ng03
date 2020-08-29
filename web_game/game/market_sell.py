# -*- coding: utf-8 -*-

from web_game.game._global import *

class View(GlobalView):

    def dispatch(self, request, *args, **kwargs):

        response = super().pre_dispatch(request, *args, **kwargs)
        if response: return response

        self.selected_menu = "merchants.sell"

        ExecuteOrder()

        DisplayMarket()

    # display market for current player's planets
    def DisplayMarket(self):

        self.request.session.get("details") = "Display market : retrieve prices"

        # get market template

        content = GetTemplate(self.request, "market-sell")

        planet = request.GET.get("planet").strip()
        if planet != "": planet = " AND v.id=" + dosql(planet)

        self.request.session.get("details") = "list planets"

        # retrieve ore, hydrocarbon, sales quantities on the planet

        query = "SELECT id, name, galaxy, sector, planet, ore, hydrocarbon, ore_capacity, hydrocarbon_capacity, planet_floor," + \
                " ore_production, hydrocarbon_production," + \
                " (sp_market_price((sp_get_resource_price(0, galaxy)).sell_ore, planet_stock_ore))," + \
                " (sp_market_price((sp_get_resource_price(0, galaxy)).sell_hydrocarbon, planet_stock_hydrocarbon))" + \
                " FROM vw_planets AS v" + \
                " WHERE floor > 0 AND v.ownerid="+UserId + planet + \
                " ORDER BY v.id"
        oRss = oConnExecuteAll(query)

        total = 0
        count = 0
        i = 1
        list = []
        for oRs in oRss:
            item = {}
            list.append(item)
            
            p_img = 1+(oRs[9] + oRs[0]) mod 21
            if p_img < 10: p_img = "0" + p_img

            item["index", i

            item["planet_img", p_img

            item["planet_id", oRs[0]
            item["planet_name", oRs[1]
            item["g", oRs[2]
            item["s", oRs[3]
            item["p", oRs[4]

            item["planet_ore", oRs[5]
            item["planet_hydrocarbon", oRs[6]

            item["planet_ore_capacity", oRs[7]
            item["planet_hydrocarbon_capacity", oRs[8]

            item["planet_ore_production", oRs[10]
            item["planet_hydrocarbon_production", oRs[11]

            item["ore_price", oRs[12]
            item["hydrocarbon_price", oRs[13]

            item["ore_price2", Replace(oRs[12], ",", ".")
            item["hydrocarbon_price2", Replace(oRs[13], ",", ".")

            # if ore/hydrocarbon quantity reach their capacity in less than 4 hours
            if oRs[5] > oRs[7]-4*oRs[10]: content.Parse("planet.high_ore_capacity"
            if oRs[6] > oRs[8]-4*oRs[11]: content.Parse("planet.high_hydrocarbon_capacity"

            item["ore_max", min(10000, fix(oRs[5]/1000))
            item["hydrocarbon_max", min(10000, fix(oRs[6]/1000))

            content.AssignValue("selling_price", 0

            count = count + 1

            if oRs[0] = str(self.CurrentPlanet): content.Parse("planet.highlight"

            content.Parse("planet"

            i = i + 1

        if planet != "":
            self.showHeader = True
            self.selected_menu = "market.sell"

            content.Parse("planetid"
        else:
            self.FillHeaderCredits(content)
            content.AssignValue("total", total
            content.Parse("totalprice"

        if count > 0: content.Parse("sell"

        return self.Display(content)

    # execute sell orders
    def ExecuteOrder(self):

        if request.GET.get("a") != "sell": return

        self.request.session.get("details") = "Execute orders"

        # retrieve the prices given when we last asked for the market prices
        #RetrievePrices()

        # for each planet owned, check what the player sells
        query = "SELECT id FROM nav_planet WHERE ownerid="+UserId
        oRs = oConnExecute(query)

        planetsArray = oRs.GetRows()
        planetsCount = UBound(planetsArray, 2)

        # set the timeout : 2 seconds per planet
        Server.ScriptTimeout = Server.ScriptTimeout + planetsCount*2

        for i = 0 to planetsCount
            planetid = planetsArray(0, i)

            # retrieve ore + hydrocarbon quantities
            ore = ToInt(request.POST.get("o" + planetid), 0)
            hydrocarbon = ToInt(request.POST.get("h" + planetid), 0)

            if ore > 0 or hydrocarbon > 0:
                query = "SELECT sp_market_sell(" + str(self.UserId) + "," + planetid + "," + ore*1000 + "," + hydrocarbon*1000 + ")"
                self.request.session.get("details") = query
                oConnDoQuery(query)
                self.request.session.get("details") = "done:"+query

        if request.POST.get("rel") != 1: log_notice "market-sell.asp", "hidden value is missing from form data", 1

