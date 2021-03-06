# -*- coding: utf-8 -*-

from math import sqrt

from django.contrib.auth.mixins import LoginRequiredMixin
from django.http import HttpResponse, HttpResponseRedirect
from django.utils import timezone
from django.shortcuts import render
from django.views import View

from web_game.lib.exile import *
from web_game.lib.template import *
from web_game.lib.accounts import *



class GlobalView(LoginRequiredMixin, MaintenanceMixin, View):

    CurrentPlanet = None
    CurrentGalaxyId = None
    CurrentSectorId = None
    scrollY = 0 # how much will be scrolled in vertical after the page is loaded
    showHeader = False
    url_extra_params = ""
    pageTerminated = False
    displayAlliancePlanetName = True
    pagelogged = False
    selected_tab = ""
    selected_menu = ""
    
    def pre_dispatch(self, request, *args, **kwargs):
        
        response = super().pre_dispatch(request, *args, **kwargs)
        if response: return response
        
        # Check that this session is still valid
        response = self.CheckSessionValidity()
        if response: return response
        
        # Check for the planet querystring parameter and if the current planet belongs to the player
        response = self.CheckCurrentPlanetValidity()
        if response: return response
        
    def hasRight(self, right):
        if self.oAllianceRights == None:
            return True
        else:
            return self.oAllianceRights["leader"] or self.oAllianceRights[right]
    
    def getPlanetName(self, relation, radar_strength, ownerName, planetName):
        if relation == rSelf:
            return planetName if planetName else ""
        elif relation == rAlliance:
            if self.displayAlliancePlanetName:
                return planetName if planetName else ""
            else:
                return ownerName if ownerName else ""
        elif relation == rFriend:
            return ownerName if ownerName else ""
        else:
            if radar_strength > 0:
                return ownerName if ownerName else ""
            else:
                return ""

    def IsPlayerAccount(self):
        return self.request.session.get(sPrivilege) > -50 and self.request.session.get(sPrivilege) < 50

    def IsImpersonating(self):
        return self.request.user.is_impersonate

    # return image of a planet according to its it and its floor
    def planetimg(self,id,floor):
        img = 1+(floor + id) % 21
        if img < 10: img = "0" + str(img)
        return str(img)

    # return the percentage of the current value compared to max value
    def getpercent(self, current, max, slice):
        if (current >= max) or (max == 0):
            return 100
        else:
            return slice*int(100 * current / max / slice)

    #
    # Parse the header, list the planets owned by the player and show the resources of the current planet
    #
    def FillHeader(self, tpl):
        if self.CurrentPlanet == 0:
            return

        # Initialize the header
        tpl_header = tpl

        # retrieve player credits and assign the value, don't use oPlayerInfo as the info may be outdated
        query = "SELECT credits, prestige_points FROM users WHERE id=" + str(self.UserId) + " LIMIT 1"
        oRs = oConnExecute(query)
        tpl_header.AssignValue("money", oRs[0])
        tpl_header.AssignValue("pp", oRs[1])
    
        # assign current planet ore, hydrocarbon, workers and energy
        query = "SELECT ore, ore_production, ore_capacity," + \
                "hydrocarbon, hydrocarbon_production, hydrocarbon_capacity," + \
                "workers, workers_busy, workers_capacity," + \
                "energy_consumption, energy_production," + \
                "floor_occupied, floor," + \
                "space_occupied, space, workers_for_maintenance," + \
                "mod_production_ore, mod_production_hydrocarbon, energy, energy_capacity, soldiers, soldiers_capacity, scientists, scientists_capacity" +\
                " FROM vw_planets WHERE id="+str(self.CurrentPlanet)
        oRs = oConnExecute(query)
    
        tpl_header.AssignValue("ore", oRs[0])
        tpl_header.AssignValue("ore_production", oRs[1])
        tpl_header.AssignValue("ore_capacity", oRs[2])
    
        # compute ore level : ore / capacity
        ore_level = self.getpercent(oRs[0], oRs[2], 10)
    
        if ore_level >= 90:
            tpl_header.Parse("high_ore")
        elif ore_level >= 70:
            tpl_header.Parse("medium_ore")
        else:
            tpl_header.Parse("normal_ore")
    
        tpl_header.AssignValue("hydrocarbon", oRs[3])
        tpl_header.AssignValue("hydrocarbon_production", oRs[4])
        tpl_header.AssignValue("hydrocarbon_capacity", oRs[5])
    
        hydrocarbon_level = self.getpercent(oRs[3], oRs[5], 10)
    
        if hydrocarbon_level >= 90:
            tpl_header.Parse("high_hydrocarbon")
        elif hydrocarbon_level >= 70:
            tpl_header.Parse("medium_hydrocarbon")
        else:
            tpl_header.Parse("normal_hydrocarbon")
    
        tpl_header.AssignValue("workers", oRs[6])
        tpl_header.AssignValue("workers_capacity", oRs[8])
        tpl_header.AssignValue("workers_idle", oRs[6] - oRs[7])
    
        if oRs[6] < oRs[15]: tpl_header.Parse("workers_low")
    
        tpl_header.AssignValue("soldiers", oRs[20])
        tpl_header.AssignValue("soldiers_capacity", oRs[21])
    
        if oRs[20]*250 < oRs[6]+oRs[22]: tpl_header.Parse("soldiers_low")
    
        tpl_header.AssignValue("scientists", oRs[22])
        tpl_header.AssignValue("scientists_capacity", oRs[23])
    
        tpl_header.AssignValue("energy_consumption", oRs[9])
        tpl_header.AssignValue("energy_totalproduction", oRs[10])
        tpl_header.AssignValue("energy_production", oRs[10]-oRs[9])
    
        tpl_header.AssignValue("energy", oRs[18])
        tpl_header.AssignValue("energy_capacity", oRs[19])
    
        if oRs[9] > oRs[10]: tpl_header.Parse("energy_low")
    
        if oRs[9] > oRs[10]: tpl_header.Parse("energy_production_minus")
        else: tpl_header.Parse("energy_production_normal")
    
        tpl_header.AssignValue("floor_occupied", oRs[11])
        tpl_header.AssignValue("floor", oRs[12])
    
        tpl_header.AssignValue("space_occupied", oRs[13])
        tpl_header.AssignValue("space", oRs[14])
    
        # ore/hydro production colors
        if oRs[16] >= 0 and oRs[6] >= oRs[15]:
            tpl_header.Parse("normal_ore_production")
        else:
            tpl_header.Parse("medium_ore_production")

        if oRs[17] >= 0 and oRs[6] >= oRs[15]:
            tpl_header.Parse("normal_hydrocarbon_production")
        else:
            tpl_header.Parse("medium_hydrocarbon_production")

        #
        # Fill the planet list
        #
        if self.url_extra_params != "":
            tpl_header.AssignValue("url", "?" + url_extra_params + "&planet=")
        else:
            tpl_header.AssignValue("url", "?planet=")

        # cache the list of planets as they are not supposed to change unless a colonization occurs
        # in case of colonization, let the colonize script reset the session value
        # retrieve planet list
        query = "SELECT id, name, galaxy, sector, planet" + \
                " FROM nav_planet" + \
                " WHERE planet_floor > 0 AND planet_space > 0 AND ownerid=" + str(self.UserId) + \
                " ORDER BY id"
        oRs = oConnExecuteAll(query)

        if oRs == None:
            planetListCount = -1
        else:
            planetListArray = oRs
            planetListCount = len(oRs)

        self.request.session[sPlanetList] = planetListArray
        self.request.session[sPlanetListCount] = planetListCount

        planets = []
        for item in planetListArray:
            id = item[0]
    
            planet = {}
            planets.append(planet)
            
            planet["id"] = id
            planet["name"] = item[1]
            planet["g"] = item[2]
            planet["s"] = item[3]
            planet["p"] = item[4]
    
            if id == self.CurrentPlanet: planet["selected"] = True
    
        tpl_header.AssignValue("planets", planets)
    
        query = "SELECT buildingid, db_buildings.label" +\
                " FROM planet_buildings INNER JOIN db_buildings ON (db_buildings.id=buildingid AND db_buildings.is_planet_element)" +\
                " WHERE planetid="+str(self.CurrentPlanet)+\
                " ORDER BY upper(db_buildings.label)"
        oRs = oConnExecuteAll(query)
    
        i = 0
        if oRs:
            for item in oRs:

                if i % 3 == 0:
                    tpl_header.AssignValue("special1", item[1])
                elif i % 3 == 1:
                    tpl_header.AssignValue("special2", item[1])
                else:
                    tpl_header.AssignValue("special3", item[1])
                    tpl_header.AssignValue("special")
        
                i = i + 1
    
        if i % 3 != 0: tpl_header.Parse("special")

    def FillHeaderCredits(self, tpl_header):
        oRs = oConnExecute("SELECT credits FROM users WHERE id="+str(self.UserId))
        tpl_header.AssignValue("credits", oRs[0])
    
    #
    # Parse the menu
    #
    def FillMenu(self, tpl_layout):
        # Initialize the menu template

        tpl = tpl_layout
    
        # retrieve number of new messages & reports
        query = "SELECT (SELECT int4(COUNT(*)) FROM messages WHERE ownerid=" + str(self.UserId) + " AND read_date is NULL)," + \
                "(SELECT int4(COUNT(*)) FROM reports WHERE ownerid=" + str(self.UserId) + " AND read_date is NULL AND datetime <= now());"
        oRs = oConnExecute(query)
    
        tpl.AssignValue("new_mail", oRs[0])
        tpl.AssignValue("new_report", oRs[1])

        if self.oAllianceRights:
            tpl.Parse("show_alliance")
            if self.oAllianceRights["leader"] or self.oAllianceRights["can_manage_description"] or self.oAllianceRights["can_manage_announce"]: tpl.Parse("show_management")
            if self.oAllianceRights["leader"] or self.oAllianceRights["can_see_reports"]: tpl.Parse("show_reports")
            if self.oAllianceRights["leader"] or self.oAllianceRights["can_see_members_info"]: tpl.Parse("show_members")
        
        tpl.AssignValue("top_credits", self.oPlayerInfo["credits"])
        tpl.AssignValue("top_prestiges", self.oPlayerInfo["prestige_points"])
        
        tpl.AssignValue("cur_planetid", self.CurrentPlanet)
        tpl.AssignValue("cur_g", self.CurrentGalaxyId)
        tpl.AssignValue("cur_s", self.CurrentSectorId)
        tpl.AssignValue("cur_p", ((self.CurrentPlanet-1) % 25) + 1)
    
        tpl.AssignValue("selected_tab", self.selected_tab)
        tpl.AssignValue("selected_menu", self.selected_menu)
        
        tpl.AssignValue("menu_avatar", self.oPlayerInfo["avatar_url"])
        tpl.AssignValue("menu_username", self.oPlayerInfo["login"])
        tpl.AssignValue("menu_orientation", self.oPlayerInfo["orientation"])

        tpl.AssignValue("right_planet_count", self.oPlayerInfo["planets"])
        tpl.AssignValue("right_planet_max", int(self.oPlayerInfo["mod_planets"]))

        planets = []
        tpl.AssignValue("menu_planets", planets)
        
        query = "SELECT id, galaxy, sector, planet, name, planet_floor FROM nav_planet WHERE planet_floor > 0 AND planet_space > 0 AND ownerid=" + str(self.UserId)
        rows = oConnRows(query)
        for row in rows:
            
            planet = {}
            planets.append(planet)
            
            planet["id"] = row["id"]
            planet["g"] = row["galaxy"]
            planet["s"] = row["sector"]
            planet["p"] = row["planet"]
            planet["name"] = row["name"]
            planet["img"] = self.planetimg(row["id"], row["planet_floor"])
        
    def logpage(self):
        self.pagelogged = True

    #
    # Display the tpl content with the default layout template
    #
    def Display(self, tpl):
        
        if self.request.GET.get("xml") == "1":
            return self.displayXML(tpl)
        else:
            tpl_layout = tpl
    
            # Initialize the layout
            if self.oPlayerInfo["skin"]:
                tpl_layout.AssignValue("skin", self.oPlayerInfo["skin"])
            else:
                tpl_layout.AssignValue("skin", "s_transparent")

            #
            # Fill and parse the header template
            #
            if self.showHeader == True: self.FillHeader(tpl_layout)
    
            #
            # Fill and parse the menu template
            #
            self.FillMenu(tpl_layout)
    
            #
            # Fill and parse the layout template
            #
            if self.oPlayerInfo["timers_enabled"]: tpl_layout.AssignValue("timers_enabled", "true")
            else: tpl_layout.AssignValue("timers_enabled", "false")
    
            #Assign the context/header
            if self.showHeader == True:
                tpl_layout.Parse("context")

            # Assign the scroll value if is assigned
            tpl_layout.AssignValue("scrolly", self.scrollY)
            if self.scrollY != 0: tpl_layout.Parse("scroll")
            
            if self.oPlayerInfo["deletion_date"]:
                tpl_layout.AssignValue("delete_datetime", self.oPlayerInfo["deletion_date"])
                tpl_layout.Parse("deleting")

            if self.oPlayerInfo["credits"] < 0:
                bankrupt_hours = self.oPlayerInfo["credits_bankruptcy"]
    
                tpl_layout.AssignValue("bankruptcy_hours", bankrupt_hours)
                tpl_layout.Parse("hours")
    
                tpl_layout.Parse("creditswarning")

            if self.IsImpersonating():
                tpl_layout.AssignValue("login", self.oPlayerInfo["login"])
                tpl_layout.Parse("impersonating")
                
            tpl_layout.AssignValue("userid", self.UserId)
            tpl_layout.AssignValue("server", universe)
    
            tpl_layout.Parse("menu")
    
            #
            # Write the template to the client
            #
            self.request.session["details"] = "sending page"
    
        self.logpage()

        return render(self.request, tpl_layout.template, tpl_layout.data)

    #
    # Check that our user is valid, otherwise redirect user to home page
    #
    def CheckSessionValidity(self):
        self.UserId = self.request.user.id
    
        # check that this session is still used
        # if a user tries to login multiple times, the first sessions are abandonned

        query = "SELECT ""login"", privilege, lastlogin, credits, lastplanetid, deletion_date, score, score_prestige, planets, previous_score," +\
                "alliance_id, alliance_rank, leave_alliance_datetime IS NULL AND (alliance_left IS NULL OR alliance_left < now()) AS can_join_alliance," +\
                "credits_bankruptcy, mod_planets, mod_commanders, avatar_url," +\
                "ban_datetime, ban_expire, ban_reason, ban_reason_public, orientation, (paid_until IS NOT NULL AND paid_until > now()) AS paid," +\
                " timers_enabled, display_alliance_planet_name, credits, prestige_points, (inframe IS NOT NULL AND inframe) AS inframe, COALESCE(skin, 's_default') AS skin," +\
                "lcid, security_level, (SELECT username FROM exile_nexus.users WHERE id=" + str(self.UserId) + ") AS username" +\
                " FROM users" +\
                " WHERE id=" + str(self.UserId)
        self.oPlayerInfo = oConnRow(query)
        
        # check account still exists or that the player didn't connect with another account meanwhile
        if self.oPlayerInfo == None:
            return HttpResponseRedirect("/") # Redirect to home page
    
        self.SecurityLevel = self.oPlayerInfo["security_level"]
        self.displayAlliancePlanetName = self.oPlayerInfo["display_alliance_planet_name"]
    
        self.request.session["LCID"] = self.oPlayerInfo["lcid"]
    
        if self.IsPlayerAccount():
            # Redirect to locked page
            if self.oPlayerInfo["privilege"] == -1: return HttpResponseRedirect("/game/locked/")
    
            # Redirect to holidays page
            if self.oPlayerInfo["privilege"] == -2: return HttpResponseRedirect("/game/holidays/")
    
            # Redirect to wait page
            if self.oPlayerInfo["privilege"] == -3: return HttpResponseRedirect("/game/wait/")
    
            # Redirect to game-over page
            if self.oPlayerInfo["credits_bankruptcy"] <= 0: return HttpResponseRedirect("/game/game-over/")

        self.AllianceId = self.oPlayerInfo["alliance_id"]
        self.AllianceRank = self.oPlayerInfo["alliance_rank"]
        self.oAllianceRights = None
    
        if self.AllianceId:
            query = "SELECT label, leader, can_invite_player, can_kick_player, can_create_nap, can_break_nap, can_ask_money, can_see_reports, can_accept_money_requests, can_change_tax_rate, can_mail_alliance," +\
                    " can_manage_description, can_manage_announce, can_see_members_info, can_use_alliance_radars, can_order_other_fleets" +\
                    " FROM alliances_ranks" +\
                    " WHERE allianceid=" + str(self.AllianceId) + " AND rankid=" + str(self.AllianceRank)
            self.oAllianceRights = oConnRow(query)
    
            if self.oAllianceRights == None:
                self.oAllianceRights = None
                self.AllianceId = None

        # log activity
        if not self.IsImpersonating(): oConnExecute("SELECT sp_log_activity(" + str(self.UserId) + "," + dosql(self.request.META.get("REMOTE_ADDR")) + ",0)")

    # set the new current planet, if the planet doesn't belong to the player then go back to the session planet
    def SetCurrentPlanet(self, planetid):
    
        #
        # Check if a parameter is given and if different than the current planet
        # In that case, try to set it as the new planet : check that this planet belongs to the player
        #
        if (planetid != "") and (planetid != self.CurrentPlanet):
            # check that the new planet belongs to the player
            oRs = oConnExecute("SELECT galaxy, sector FROM nav_planet WHERE planet_floor > 0 AND planet_space > 0 AND id=" + str(planetid) + " and ownerid=" + str(self.UserId))
            if oRs:
                self.CurrentPlanet = planetid
                self.CurrentGalaxyId = oRs[0]
                self.CurrentSectorId = oRs[1]
                self.request.session[sPlanet] = planetid
    
                # save the last planetid
                if not self.request.user.is_impersonate:
                    oConnDoQuery("UPDATE users SET lastplanetid=" + str(planetid) + " WHERE id=" + str(self.UserId))
    
                return None
    
        # 
        # retrieve current planet from session
        #
        self.CurrentPlanet = self.request.session.get(sPlanet, "")
    
        if self.CurrentPlanet != None:
            # check if the planet still belongs to the player
            oRs = oConnExecute("SELECT galaxy, sector FROM nav_planet WHERE planet_floor > 0 AND planet_space > 0 AND id=" + str(self.CurrentPlanet) + " AND ownerid=" + str(self.UserId))
            if oRs:
                # the planet still belongs to the player, exit
                self.CurrentGalaxyId = oRs[0]
                self.CurrentSectorId = oRs[1]
                return None
    

        # there is no active planet, select the first planet available
        oRs = oConnExecute("SELECT id, galaxy, sector FROM nav_planet WHERE planet_floor > 0 AND planet_space > 0 AND ownerid=" + str(self.UserId) + " LIMIT 1")
    
        # if player owns no planets then the game is over
        if oRs == None:
            if self.IsPlayerAccount():
                return HttpResponseRedirect("/game/game-over/")
            else:
                self.CurrentPlanet = 0
                self.CurrentGalaxyId = 0
                self.CurrentSectorId = 0
    
                return None
    
        # assign planet id
        self.CurrentPlanet = oRs[0]
        self.CurrentGalaxyId = oRs[1]
        self.CurrentSectorId = oRs[2]
        self.request.session[sPlanet] = self.CurrentPlanet
    
        # save the last planetid
        if not self.request.user.is_impersonate:
            oConnDoQuery("UPDATE users SET lastplanetid=" + str(self.CurrentPlanet) + " WHERE id=" + str(self.UserId))
    
        # a player may wish to destroy a building on a planet that belonged to him
        # if the planet doesn't belong to him anymore, the action may be performed on another planet
        # so we redirect the user to the overview to prevent executing an order on another planet
        return HttpResponseRedirect("/game/empire_view/")
    
    #
    # check if a planet is given in the querystring and that it belongs to the player
    #
    def CheckCurrentPlanetValidity(self):
    
        # retrieve planet parameter if any
        id = ToInt(self.request.GET.get("planet"), "")
    
        return self.SetCurrentPlanet(id)
