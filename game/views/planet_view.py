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

        e_no_error = 0
        self.e_rename_bad_name = 1

        self.planet_error = e_no_error

        if request.POST.get("action") == "assigncommander":
            if ToInt(request.POST.get("commander"), 0) != 0: # assign selected commander
                query = "SELECT * FROM user_commander_assign(" + str(self.userId) + "," + str(ToInt(request.POST.get("commander"), 0)) + "," + str(self.currentPlanetId) + ",null)"
                dbExecute(query)
            else:
                # unassign current planet commander
                query = "UPDATE gm_planets SET commanderid=null WHERE ownerid=" + str(self.userId) + " AND id=" + str(self.currentPlanetId)
                dbExecute(query)

        elif request.POST.get("action") == "rename":
            if not isValidObjectName(request.POST.get("name")):
                self.planet_error = self.e_rename_bad_name
            else:
                query = "UPDATE gm_planets SET name=" + sqlStr(request.POST.get("name")) + \
                        " WHERE ownerid=" + str(self.userId) + " AND id=" + str(self.currentPlanetId)

                dbExecute(query)

                

        elif request.POST.get("action") == "firescientists":
            amount = ToInt(request.POST.get("amount"), 0)
            dbRow("SELECT user_planet_dismiss_staff(" + str(self.userId) + "," + str(self.currentPlanetId) + "," + str(amount) + ",0,0)")
        elif request.POST.get("action") == "firesoldiers":
            amount = ToInt(request.POST.get("amount"), 0)
            dbRow("SELECT user_planet_dismiss_staff(" + str(self.userId) + "," + str(self.currentPlanetId) + "," + "0," + str(amount) + ",0)")
        elif request.POST.get("action") == "fireworkers":
            amount = ToInt(request.POST.get("amount"), 0)
            dbRow("SELECT user_planet_dismiss_staff(" + str(self.userId) + "," + str(self.currentPlanetId) + "," + "0,0," + str(amount) + ")")

        elif request.POST.get("action") == "abandon":
            dbRow("SELECT sp_abandon_planet(" + str(self.userId) + "," + str(self.currentPlanetId) + ")")
            
            return HttpResponseRedirect("/game/overview/")

        elif request.POST.get("action") == "resources_price":
            query = "UPDATE gm_planets SET" + \
                    " buy_ore = GREATEST(0, LEAST(1000, " + str(ToInt(request.POST.get("buy_ore"), 0)) + "))" + \
                    " ,buy_hydro = GREATEST(0, LEAST(1000, " + str(ToInt(request.POST.get("buy_hydro"), 0)) + "))" + \
                    " WHERE ownerid=" + str(self.userId) + " AND id=" + str(self.currentPlanetId)
            dbExecute(query)

        if request.GET.get("a") == "suspend":
            dbRow("SELECT internal_planet_update_production_date(" + str(self.currentPlanetId) + ")")
            dbExecute("UPDATE gm_planets SET mod_production_workers=0, recruit_workers=False WHERE ownerid=" + str(self.userId) + " AND id=" + str(self.currentPlanetId) )
        elif request.GET.get("a")== "resume":
            dbExecute("UPDATE gm_planets SET recruit_workers=True WHERE ownerid=" + str(self.userId) + " AND id=" + str(self.currentPlanetId) )
            dbRow("SELECT internal_planet_update_data(" + str(self.currentPlanetId) + ")")

        return self.DisplayPlanet()

    def DisplayPlanet(self):

        content = self.loadTemplate("planet")

        CmdReq=""

        query = "SELECT id, name, galaxy, sector, planet, " + \
                "floor_occupied, floor, space_occupied, space, workers, workers_capacity, mod_production_workers," + \
                "scientists, scientists_capacity, soldiers, soldiers_capacity, commanderid, recruit_workers," + \
                "planet_floor, COALESCE(buy_ore, 0), COALESCE(buy_hydro, 0)" + \
                " FROM vw_gm_planets WHERE id=" + str(self.currentPlanetId)

        row = dbRow(query)

        if row:
            content.AssignValue("planet_id", row[0])
            content.AssignValue("planet_name", row[1])
            content.AssignValue("planet_img", self.getPlanetImg(row[0], row[18]))

            content.AssignValue("pla_g", row[2])
            content.AssignValue("pla_s", row[3])
            content.AssignValue("pla_p", row[4])

            content.AssignValue("floor_occupied", row[5])
            content.AssignValue("floor", row[6])

            content.AssignValue("space_occupied", row[7])
            content.AssignValue("space", row[8])

            content.AssignValue("workers", row[9])
            content.AssignValue("workers_capacity", row[10])

            content.AssignValue("scientists", row[12])
            content.AssignValue("scientists_capacity", row[13])

            content.AssignValue("soldiers", row[14])
            content.AssignValue("soldiers_capacity", row[15])

            content.AssignValue("growth", row[11]/10)

            if row[17]:
                content.Parse("suspend")
            else:
                content.Parse("resume")

            content.AssignValue("buy_ore", row[19])
            content.AssignValue("buy_hydro", row[20])

            # retrieve commander assigned to this planet
            if row[16]:
                oCmdRs = dbRow("SELECT name FROM gm_commanders WHERE ownerid="+str(self.userId)+" AND id="+str(row[16]))
                content.AssignValue("commandername", oCmdRs[0])
                CmdId = row[16]
                content.Parse("commander")
            else:
                content.Parse("nocommander")
                CmdId = 0

        if CmdId == 0: # display "no commander" or "fire commander"
            content.Parse("none")
        else:
            content.Parse("unassign")

        # display commmanders

        query = " SELECT id, name, fleetname, planetname, fleetid " + \
                " FROM vw_gm_profile_commanders" + \
                " WHERE ownerid="+str(self.userId) + \
                " ORDER BY fleetid IS NOT NULL, planetid IS NOT NULL, fleetid, planetid "
        rows = dbRows(query)

        lastItem = ""
        item = ""
        ShowGroup = False

        cmd_groups = []
        content.AssignValue("optgroups", cmd_groups)
        
        cmd_nones = {'typ':'none', 'cmds':[]}
        cmd_fleets = {'typ':'fleet', 'cmds':[]}
        cmd_planets = {'typ':'planet', 'cmds':[]}
        
        for row in rows:
            item = {}

            if row[2] == None and row[3] == None:
                typ = "none"
                cmd_nones['cmds'].append(item)
            elif row[2] == None:
                typ = "planet"
                cmd_planets['cmds'].append(item)
            else:
                typ = "fleet"
                cmd_fleets['cmds'].append(item)

            if CmdId == row[0]: item["selected"] = True
            item["cmd_id"] = row[0]
            item["cmd_name"] = row[1]
            if typ == "planet":
                item["name"] = row[3]
                item["assigned"] = True

            if item == "fleet":
                item["name"] = row[2]
                activityRs = dbRow("SELECT dest_planetid, engaged, action FROM gm_fleets WHERE ownerid="+str(self.userId)+" AND id="+str(row[4]))
                if activityRs[0] == None and (not activityRs[1]) and activityRs[2]==0:
                    item["assigned"] = True
                else:
                    item["unavailable"] = True
                    
        if len(cmd_nones['cmds']) > 0: cmd_groups.append(cmd_nones)
        if len(cmd_fleets['cmds']) > 0: cmd_groups.append(cmd_fleets)
        if len(cmd_planets['cmds']) > 0: cmd_groups.append(cmd_planets)

        # view current buildings constructions
        query = "SELECT buildingid, remaining_time, destroying" + \
                " FROM vw_gm_planet_building_pendings WHERE planetid="+str(self.currentPlanetId) + \
                " ORDER BY remaining_time DESC"

        rows = dbRows(query)

        i = 0
        list = []
        content.AssignValue("buildings", list)
        for row in rows:
            item = {}
            list.append(item)
            
            item["buildingid"] = row[0]
            item["building"] = getBuildingLabel(row[0])
            item["time"] = row[1]

            if row[2]: item["destroy"] = True

            i = i + 1

        if i==0: content.Parse("nobuilding")

        query = "SELECT shipid, remaining_time, recycle" + \
                " FROM vw_gm_planet_ship_pendings" + \
                " WHERE ownerid=" + str(self.userId) + " AND planetid=" + str(self.currentPlanetId) + " AND end_time IS NOT NULL" + \
                " ORDER BY remaining_time DESC"

        # view current ships constructions
        rows = dbRows(query)

        i = 0

        list = []
        content.AssignValue("ships", list)
        for row in rows:
            item = {}
            list.append(item)
            
            item["shipid"] = row[0]
            item["ship"] = getShipLabel(row[0])
            item["time"] = row[1]

            if row[2]: item["recycle"] = True

            i = i + 1

        if i==0: content.Parse("noship")

        # list the gm_fleets near the planet
        query = "SELECT id, name, attackonsight, engaged, size, signature, commanderid, (SELECT name FROM gm_commanders WHERE id=commanderid) as commandername," + \
                " action, internal_profile_get_relation(ownerid, " + str(self.userId) + ") AS relation, internal_profile_get_name(ownerid) AS ownername" + \
                " FROM gm_fleets" + \
                " WHERE action != -1 AND action != 1 AND planetid=" + str(self.currentPlanetId) + \
                " ORDER BY upper(name)"

        rows = dbRows(query)

        i = 0

        list = []
        content.AssignValue("gm_fleets", list)
        for row in rows:
            item = {}
            list.append(item)
            
            item["id"] = row[0]
            item["size"] = row[4]
            item["signature"] = row[5]

            if row[9] > rFriend:
                item["name"] = row[1]
            else:
                item["name"] = row[10]

            if row[6]:
                item["commanderid"] = row[6]
                item["commandername"] = row[7]
                item["commander"] = True
            else:
                item["nocommander"] = True

            if row[3]:
                item["fighting"] = True
            elif row[8] == 2:
                item["recycling"] = True
            else:
                item["patrolling"] = True

            if row[9] in [rHostile, rWar]:
                item["enemy"] = True
            elif row[9] == rFriend:
                item["friend"] = True
            elif row[9] == rAlliance:
                item["ally"] = True
            elif row[9] == rSelf:
                item["owner"] = True

            i = i + 1

        if i==0: content.Parse("nofleet")

        if self.planet_error == self.e_rename_bad_name:
                content.Parse("rename_bad_name")

        content.Parse("ondev")
