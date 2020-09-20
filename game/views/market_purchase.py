# -*- coding: utf-8 -*-

from game.views._base import *

#-------------------------------------------------------------------------------
class View(BaseView):

    def dispatch(self, request, *args, **kwargs):

        response = super().pre_dispatch(request, *args, **kwargs)
        if response: return response

        self.selected_menu = "merchants.buy"

        self.ExecuteOrder()

        return self.DisplayMarket()

    # display market for current player's planets
    def DisplayMarket(self):
        # get market template

        content = self.loadTemplate("market-buy")

        get_planet = self.request.GET.get("planet","").strip()
        if get_planet != "": get_planet = " AND v.id=" + sqlStr(get_planet)

        self.request.session["details"] = "list planets"

        # retrieve ore, hydro, sales quantities on the planet

        query = "SELECT v.id, v.name, v.galaxy, v.sector, v.planet, v.ore, v.hydro, v.ore_capacity, v.hydro_capacity, v.planet_floor," + \
                " v.ore_production, v.hydro_production," + \
                " m.ore, m.hydro, m.ore_price, m.hydro_price," + \
                " int4(date_part('epoch', m.delivery_time-now()))," + \
                " internal_planet_get_blocus_strength(v.id) >= v.space," + \
                " workers, workers_for_maintenance," + \
                " (SELECT has_merchants FROM gm_galaxies WHERE id=v.galaxy) as has_merchants," + \
                " (internal_profile_get_resource_price(" + str(self.userId) + ", v.galaxy)).buy_ore::real AS p_ore," + \
                " (internal_profile_get_resource_price(" + str(self.userId) + ", v.galaxy)).buy_hydro AS p_hydro" + \
                " FROM vw_gm_planets AS v" + \
                "    LEFT JOIN gm_market_purchases AS m ON (m.planetid=v.id)" + \
                " WHERE floor > 0 AND v.ownerid="+str(self.userId) + get_planet + \
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
            item["planet_name"] =  row[1]
            item["g"] = row[2]
            item["s"] = row[3]
            item["p"] = row[4]

            item["planet_ore"] = row[5]
            item["planet_hydro"] = row[6]

            item["planet_ore_capacity"] = row[7]
            item["planet_hydro_capacity"] = row[8]

            item["planet_ore_production"] = row[10]
            item["planet_hydro_production"] = row[11]

            # if ore/hydro quantity reach their capacity in less than 4 hours
            if row[5] > row[7]-4*row[10]: item["high_ore_capacity"] = True
            if row[6] > row[8]-4*row[11]: item["high_hydro_capacity"] = True

            item["ore_max"] = int((row[7]-row[5])/1000)
            item["hydro_max"] = int((row[8]-row[6])/1000)

            item["price_ore"] = str(row[21]).replace(",",".")
            item["price_hydro"] = str(row[22]).replace(",",".")

            if row[12] or row[13]:
                item["buying_ore"] = row[12]
                item["buying_hydro"] = row[13]

                subtotal = row[12]/1000*row[14] + row[13]/1000*row[15]
                total = total + subtotal

                item["buying_price"] = int(subtotal)

                item["buying"] = True
                item["can_buy"] = True
            else:
                item["ore"] = self.request.POST.get("o" + str(row[0]))
                item["hydro"] = self.request.POST.get("h" + str(row[0]))

                item["buying_price"] = 0

                if not row[20]:
                    item["cant_buy_merchants"] = True
                elif row[18] < row[19] / 2:
                    item["cant_buy_workers"] = True
                elif row[17]:
                    item["cant_buy_enemy"] = True
                else:
                    item["buy"] = True
                    item["can_buy"] = True

                    count = count + 1

            if row[0] == self.currentPlanetId: item["highlight"] = True

            i = i + 1

        if get_planet != "":
            self.showHeader = True
            self.selected_menu = "market.buy"

            content.AssignValue("get_planet", self.request.GET.get("planet",""))
        else:
            self.FillHeaderCredits(content)
            content.AssignValue("total", int(total))
            content.Parse("totalprice")

        if count > 0: content.Parse("buy")

        return self.display(content)

    # execute buy orders
    def ExecuteOrder(self):

        if self.request.GET.get("a","") != "buy": return

        self.request.session["details"] = "Execute orders"

        # for each planet owned, check what the player buys
        query = "SELECT id FROM gm_planets WHERE ownerid="+str(self.userId)
        planetsArray = dbRows(query)

        for i in planetsArray:
            planetid = i[0]

            # retrieve ore + hydro quantities
            ore = ToInt(self.request.POST.get("o" + str(planetid)), 0)
            hydro = ToInt(self.request.POST.get("h" + str(planetid)), 0)

            if ore > 0 or hydro > 0:

                query = "SELECT * FROM user_planet_buy_ressources(" + str(self.userId) + "," + str(planetid) + "," + str(ore*1000) + "," + str(hydro*1000) + ")"
                self.request.session["details"] = query
                dbExecute(query)
                self.request.session["details"] = "done:"+query
