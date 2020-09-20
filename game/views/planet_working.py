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

        self.showHeader = True

        return self.displayPage(True)
        
    def displayManage(self):

        if self.action == "submit":
            query = "SELECT buildingid, quantity - CASE WHEN destroy_datetime IS NULL THEN 0 ELSE 1 END, disabled" + \
                    " FROM gm_planet_buildings" + \
                    "    INNER JOIN dt_buildings ON (gm_planet_buildings.buildingid=dt_buildings.id)" + \
                    " WHERE can_be_disabled AND planetid=" + str(self.currentPlanetId)
            rows = dbRows(query)
            for row in rows:

                quantity = row[1] - ToInt(self.request.POST.get("enabled" + str(row[0])), 0)

                query = "UPDATE gm_planet_buildings SET" + \
                        " disabled=LEAST(quantity - CASE WHEN destroy_datetime IS NULL THEN 0 ELSE 1 END, " + str(quantity) + ")" + \
                        "WHERE planetid=" + str(self.currentPlanetId) + " AND buildingid =" + str(row[0])
                dbExecute(query)

            return HttpResponseRedirect("/game/production/?cat=" + str(self.cat))

        query = "SELECT buildingid, quantity - CASE WHEN destroy_datetime IS NULL THEN 0 ELSE 1 END, disabled, energy_consumption, int4(workers*maintenance_factor/100.0), upkeep" + \
                " FROM gm_planet_buildings" + \
                "    INNER JOIN dt_buildings ON (gm_planet_buildings.buildingid=dt_buildings.id)" + \
                " WHERE can_be_disabled AND planetid=" + str(self.currentPlanetId) + \
                " ORDER BY buildingid"
        rows = dbRows(query)

        list = []
        self.content.AssignValue("buildings", list)
        for row in rows:
            if row[1] > 0:
                item = {}
                list.append(item)
                
                enabled = row[1] - row[2]
                quantity = row[1] - row[2]*0.95

                item["id"] = row[0]
                item["building"] = getBuildingLabel(row[0])
                item["quantity"] = row[1]
                item["energy"] = row[3]
                item["maintenance"] = row[4]
                item["upkeep"] = row[5]
                item["energy_total"] = round(quantity * row[3])
                item["maintenance_total"] = round(quantity * row[4])
                item["upkeep_total"] = round(quantity * row[5])

                if row[2] > 0: item["not_all_enabled"] = True

                item["counts"] = []
                for i in range(0, row[1] + 1):
                    data = {}
                    data["count"] = i
                    if i == enabled: data["selected"] = True
                    item["enable"] = True
                    item["counts"].append(data)

        self.content.Parse("manage")
