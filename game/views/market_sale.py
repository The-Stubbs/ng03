# -*- coding: utf-8 -*-

from game.views._base import *

#-------------------------------------------------------------------------------
class View(BaseView):

    def dispatch(self, request, *args, **kwargs):

        response = super().pre_dispatch(request, *args, **kwargs)
        if response: return response

        self.selected_menu = "merchants.sell"

        self.ExecuteOrder()

        return self.DisplayMarket()

    # display market for current player's planets
    def DisplayMarket(self):

        self.request.session["details"] = "Display market : retrieve prices"

        # get market template

        content = self.loadTemplate("market-sell")

        planet = ToInt(self.request.GET.get("planet","").strip(), 0)
        if planet != 0:
            planet_query = " AND v.id=" + str(planet)
            content.AssignValue("get_planet", planet)
        else: planet_query = ""

        self.request.session["details"] = "list planets"

        # retrieve ore, hydro, sales quantities on the planet

        query = "SELECT id, name, galaxy, sector, planet, ore, hydro, ore_capacity, hydro_capacity, planet_floor," + \
                " ore_production, hydro_production," + \
                " (tool_compute_market_price((internal_profile_get_resource_price(0, galaxy)).sell_ore, planet_stock_ore))," + \
                " (tool_compute_market_price((internal_profile_get_resource_price(0, galaxy)).sell_hydro, planet_stock_hydro))" + \
                " FROM vw_gm_planets AS v" + \
                " WHERE floor > 0 AND v.ownerid="+str(self.userId) + planet_query + \
                " ORDER BY v.id"
        rows = dbRows(query)

        total = 0
        count = 0
        i = 1
        list = []
        content.AssignValue("m_planets", list)
        for row in rows:
            item = {}
            list.append(item)
            
            p_img = 1+(row[9] + row[0]) % 21
            if p_img < 10: p_img = "0" + str(p_img)

            item["index"] = i

            item["planet_img"] = p_img

            item["planet_id"] = row[0]
            item["planet_name"] = row[1]
            item["g"] = row[2]
            item["s"] = row[3]
            item["p"] = row[4]

            item["planet_ore"] = row[5]
            item["planet_hydro"] = row[6]

            item["planet_ore_capacity"] = row[7]
            item["planet_hydro_capacity"] = row[8]

            item["planet_ore_production"] = row[10]
            item["planet_hydro_production"] = row[11]

            item["ore_price"] = row[12]
            item["hydro_price"] = row[13]

            item["ore_price2"] = str(row[12]).replace( ",",".")
            item["hydro_price2"] = str(row[13]).replace(",",".")

            # if ore/hydro quantity reach their capacity in less than 4 hours
            if row[5] > row[7]-4*row[10]: item["high_ore_capacity"] = True
            if row[6] > row[8]-4*row[11]: item["high_hydro_capacity"] = True

            item["ore_max"] = min(10000, int(row[5]/1000))
            item["hydro_max"] = min(10000, int(row[6]/1000))

            item["selling_price"] = 0

            count = count + 1

            if row[0] == self.currentPlanetId: item["highlight"] = True

            i = i + 1

        if planet_query != "":
            self.showHeader = True
            self.selected_menu = "market.sell"

            content.Parse("planetid")
        else:
            self.FillHeaderCredits(content)
            content.AssignValue("total", total)
            content.Parse("totalprice")

        if count > 0: content.Parse("sell")

        return self.display(content)

    # execute sell orders
    def ExecuteOrder(self):

        if self.request.GET.get("a") != "sell": return

        self.request.session["details"] = "Execute orders"

        # retrieve the prices given when we last asked for the market prices
        #RetrievePrices()

        # for each planet owned, check what the player sells
        query = "SELECT id FROM gm_planets WHERE ownerid="+str(self.userId)
        planetsArray = dbRows(query)

        for i in planetsArray:
            planetid = i[0]

            # retrieve ore + hydro quantities
            ore = ToInt(self.request.POST.get("o" + str(planetid)), 0)
            hydro = ToInt(self.request.POST.get("h" + str(planetid)), 0)

            if ore > 0 or hydro > 0:
                query = "SELECT user_planet_sell_resources(" + str(self.userId) + "," + str(planetid) + "," + str(ore*1000) + "," + str(hydro*1000) + ")"
                self.request.session["details"] = query
                row = dbRow(query)
                self.request.session["details"] = "done:"+query
