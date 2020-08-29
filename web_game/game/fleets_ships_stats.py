# -*- coding: utf-8 -*-

from web_game.game._global import *

class View(GlobalView):

    def dispatch(self, request, *args, **kwargs):

        response = super().pre_dispatch(request, *args, **kwargs)
        if response: return response

        self.selected_menu = "fleets_ships_stats"

        retrieveShipsCache

        ListShips()

    # List all the available ships for construction
    def ListShips(self):

        # list ships that can be built on the planet
        query = "SELECT category, shipid, killed, lost" + \
                " FROM users_ships_kills" + \
                "    INNER JOIN db_ships ON (db_ships.id = users_ships_kills.shipid)" + \
                " WHERE userid=" + str(self.UserId) + \
                " ORDER BY shipid"
        oRss = oConnExecuteAll(query)

        content = GetTemplate(self.request, "fleets-ships-stats")

        # number of items in category
        itemCount = 0

        if oRs:
            category = oRs["category")
            lastCategory = category

        count = 0
        total_killed = 0
        total_lost = 0
        list = []
        for oRs in oRss:
            item = {}
            list.append(item)
            
            category = oRs["category")

            if category != lastCategory:
                if itemCount > 0:
                    content.Parse("category.category" + lastcategory
                    content.Parse("category"

                lastCategory = category

                itemCount = 0

            ShipId = oRs["shipid")

            item["id", ShipId
            item["name", getShipLabel(ShipId)
            item["killed", oRs[2]
            item["lost", oRs[3]

            content.Parse("category.ship"

            total_killed = total_killed + oRs[2]
            total_lost = total_lost + oRs[3]
            count = count + 1
            itemCount = itemCount + 1

        if itemCount > 0: content.Parse("category.category" + category

        if count > 0:
            content.Parse("category"

            item["kills", total_killed
            item["losses", total_lost
            content.Parse("total"

        if count == 0: content.Parse("no_ship"

        return self.Display(content)
