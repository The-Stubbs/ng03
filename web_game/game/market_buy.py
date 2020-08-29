# -*- coding: utf-8 -*-

from web_game.game._global import *

class View(GlobalView):

    def dispatch(self, request, *args, **kwargs):

        response = super().pre_dispatch(request, *args, **kwargs)
        if response: return response

        self.selected_menu = "merchants.buy"

        ExecuteOrder()

        DisplayMarket()

    # display market for current player's planets
    def DisplayMarket(self):
        # get market template

        content = GetTemplate(self.request, "market-buy")

        planet = request.GET.get("planet").strip()
        if planet != "": planet = " AND v.id=" + dosql(planet)

        self.request.session.get("details") = "list planets"

        # retrieve ore, hydrocarbon, sales quantities on the planet

        query = "SELECT v.id, v.name, v.galaxy, v.sector, v.planet, v.ore, v.hydrocarbon, v.ore_capacity, v.hydrocarbon_capacity, v.planet_floor," + \
                " v.ore_production, v.hydrocarbon_production," + \
                " m.ore, m.hydrocarbon, m.ore_price, m.hydrocarbon_price," + \
                " int4(date_part('epoch', m.delivery_time-now()))," + \
                " sp_get_planet_blocus_strength(v.id) >= v.space," + \
                " workers, workers_for_maintenance," + \
                " (SELECT has_merchants FROM nav_galaxies WHERE id=v.galaxy) as has_merchants," + \
                " (sp_get_resource_price(" + str(self.UserId) + ", v.galaxy)).buy_ore::real AS p_ore," + \
                " (sp_get_resource_price(" + str(self.UserId) + ", v.galaxy)).buy_hydrocarbon AS p_hydrocarbon" + \
                " FROM vw_planets AS v" + \
                "    LEFT JOIN market_purchases AS m ON (m.planetid=v.id)" + \
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

            # if ore/hydrocarbon quantity reach their capacity in less than 4 hours
            if oRs[5] > oRs[7]-4*oRs[10]: content.Parse("planet.high_ore_capacity"
            if oRs[6] > oRs[8]-4*oRs[11]: content.Parse("planet.high_hydrocarbon_capacity"

            item["ore_max", fix((oRs[7]-oRs[5])/1000)
            item["hydrocarbon_max", fix((oRs[8]-oRs[6])/1000)

            item["price_ore", Replace(oRs["p_ore"), ",", ".")
            item["price_hydrocarbon", Replace(oRs["p_hydrocarbon"), ",", ".")

            if (oRs[12]):
                item["buying_ore", oRs[12]
                item["buying_hydrocarbon", oRs[13]

                subtotal = oRs[12]/1000*oRs[14] + oRs[13]/1000*oRs[15]
                total = total + subtotal

                item["buying_price", subtotal

                content.Parse("planet.can_buy.buying"
                content.Parse("planet.can_buy"
            else:
                item["ore", request.POST.get("o" + oRs[0])
                item["hydrocarbon", request.POST.get("h" + oRs[0])

                item["buying_price", 0

                if not oRs["has_merchants"):
                    content.Parse("planet.cant_buy_merchants"
                elif oRs[18] < oRs[19] / 2:
                    content.Parse("planet.cant_buy_workers"
                elif oRs[17]:
                    content.Parse("planet.cant_buy_enemy"
                else:
                    content.Parse("planet.can_buy.buy"
                    content.Parse("planet.can_buy"

                    count = count + 1

            if oRs[0] = str(self.CurrentPlanet): content.Parse("planet.highlight"

            content.Parse("planet"

            i = i + 1

        if planet != "":
            self.showHeader = True
            self.selected_menu = "market.buy"

            content.Parse("planetid"
        else:
            self.FillHeaderCredits(content)
            content.AssignValue("total", total
            content.Parse("totalprice"

        if count > 0: content.Parse("buy"

        return self.Display(content)

    # execute buy orders
    def ExecuteOrder(self):

        if request.GET.get("a") != "buy": return

        self.request.session.get("details") = "Execute orders"

        # for each planet owned, check what the player buys
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

                query = "SELECT * FROM sp_buy_resources(" + str(self.UserId) + "," + planetid + "," + ore*1000 + "," + hydrocarbon*1000 + ")"
                self.request.session.get("details") = query
                oConnDoQuery(query)
                self.request.session.get("details") = "done:"+query

