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
    def fillContent(self, request, data):

        # --- upkeep data
        
        hours = 24 - timezone.now().hour

        query = "SELECT scientists,soldiers,planets,ships_signature,ships_in_position_signature,ships_parked_signature," + \
                " cost_planets2,cost_scientists,cost_soldiers,cost_ships,cost_ships_in_position,cost_ships_parked," + \
                " int4(upkeep_scientists + scientists*cost_scientists/24*" + str(hours) + ")," + \
                " int4(upkeep_soldiers + soldiers*cost_soldiers/24*" + str(hours) + ")," + \
                " int4(upkeep_planets + cost_planets2/24*" + str(hours) + ")," + \
                " int4(upkeep_ships + ships_signature*cost_ships/24*" + str(hours) + ")," + \
                " int4(upkeep_ships_in_position + ships_in_position_signature*cost_ships_in_position/24*" + str(hours) + ")," + \
                " int4(upkeep_ships_parked + ships_parked_signature*cost_ships_parked/24*" + str(hours) + ")," + \
                " gm_commanders, commanders_salary, cost_commanders, upkeep_commanders + int4(commanders_salary*cost_commanders/24*" + str(hours) + ")" + \
                " FROM vw_gm_profile_upkeeps" + \
                " WHERE userid=" + str(self.userId)
        row = dbRow(query)

        data["commanders_quantity"] = row[18]
        data["commanders_salary"] = row[19]
        data["commanders_cost"] = row[20]
        data["commanders_estimated_cost"] = row[21]

        data["scientists_quantity"] = row[0]
        data["soldiers_quantity"] = row[1]
        data["planets_quantity"] = row[2]
        data["ships_signature"] = row[3]
        data["ships_in_position_signature"] = row[4]
        data["ships_parked_signature"] = row[5]

        data["planets_cost"] = row[6]
        data["scientists_cost"] = row[7]
        data["soldiers_cost"] = row[8]
        data["ships_cost"] = row[9]
        data["ships_in_position_cost"] = row[10]
        data["ships_parked_cost"] = row[11]

        data["scientists_estimated_cost"] = row[12]
        data["soldiers_estimated_cost"] = row[13]
        data["planets_estimated_cost"] = row[14]
        data["ships_estimated_cost"] = row[15]
        data["ships_in_position_estimated_cost"] = row[16]
        data["ships_parked_estimated_cost"] = row[17]

        data["total_estimation"] = row[12] + row[13] + row[14] + row[15] + row[16] + row[17] + row[21]
