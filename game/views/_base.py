# -*- coding: utf-8 -*-

import time

from math import sqrt

from django.contrib.auth.mixins import LoginRequiredMixin
from django.http import HttpResponseRedirect
from django.shortcuts import render
from django.views import View
from django.utils import timezone

from django.db import connection

universe = "ng03"

maintenance = False
registration = False

urlNexus = "https://exileng.com/"

rUninhabited = -3
rWar = -2
rHostile = -1
rFriend = 0
rAlliance = 1
rSelf = 2

sUser = "user"
sPlanet = "planet"
sPlanetList = "planetlist"
sPlanetListCount = "planetlistcount"
sPrivilege = "Privilege"
sLogonUserID = "logonuserid"

def dict_fetchall(cursor):
    columns = [col[0] for col in cursor.description]
    return [
        dict(zip(columns, row))
        for row in cursor.fetchall()
    ]

def dict_fetchone(cursor):
    results = dict_fetchall(cursor)
    if results: return results[0]
    else: return None

cursor = None

def connectDB():
    global cursor
    cursor = connection.cursor()

def oConnExecute(query):
    cursor.execute(query)
    results = cursor.fetchall()
    if len(results) > 1: return results
    elif results: return results[0]
    return None

def oConnExecuteAll(query):
    cursor.execute(query)
    return cursor.fetchall()
    
def oConnDoQuery(query):
    cursor.execute(query)

def oConnRow(query):
    cursor.execute(query)
    return dict_fetchone(cursor)

def oConnRows(query):
    cursor.execute(query)
    return dict_fetchall(cursor)

# return a quoted string for sql queries
def dosql(ch):
    ret = ch.replace('\\', '\\\\') 
    ret = ret.replace('\'', '\'\'')
    ret = '\'' + ret + '\''
    return ret

# return "null" if val is null or equals ''
def sqlValue(val):
    if val == None or val == "":
        return "Null"
    else:
        return str(val)

# tries to execute a query up to 3 times if it fails the first times
def connExecuteRetry(query):
    i = 0
    while i < 5:
        try:
            i = 10
            rs = oConnExecute(query)
            return rs
        except:
            i = i + 1
    return None
    
def connExecuteRetryNoRecords(query):
    i = 0
    while i < 5:
        try:
            i = 10
            oConnExecute(query)
        except:
            i = i + 1

def ToInt(s, defaultValue):
    if(s == "" or s == None): return defaultValue
    i = int(float(s))
    if i == None:
        return defaultValue
    return i

def ToBool(s, defaultValue):
    if(s == "" or s == None): return defaultValue
    i = int(float(s))
    if i == 0:
        return defaultValue
    return True

# -*- coding: utf-8 -*-

import re

#-------------------------------------------------------------------------------
def isValidName(name):

    name = name.strip()
    if name == "" or len(name) < 2 or len(name) > 12:
        return False
    else:
        p = re.compile('^[a-zA-Z0-9]+([ ]?[\-]?[ ]?[a-zA-Z0-9]+)*$')
        return p.match(name)
        
#-------------------------------------------------------------------------------
def isValidURL(url):

    p = re.compile("^(http|https|ftp)\://([a-zA-Z0-9\.\-]+(\:[a-zA-Z0-9\.&%\$\-]+)*@)?((25[0-5]|2[0-4][0-9]|[0-1]{1}[0-9]{2}|[1-9]{1}[0-9]{1}|[1-9])\.(25[0-5]|2[0-4][0-9]|[0-1]{1}[0-9]{2}|[1-9]{1}[0-9]{1}|[1-9]|0)\.(25[0-5]|2[0-4][0-9]|[0-1]{1}[0-9]{2}|[1-9]{1}[0-9]{1}|[1-9]|0)\.(25[0-5]|2[0-4][0-9]|[0-1]{1}[0-9]{2}|[1-9]{1}[0-9]{1}|[0-9])|([a-zA-Z0-9\-]+\.)*[a-zA-Z0-9\-]+\.[a-zA-Z]{2,4})(\:[0-9]+)?(/[^/][a-zA-Z0-9\.\,\?\'\\/\+&%\$#\=~_\-@]*)*$")
    return p.match(url)

#-------------------------------------------------------------------------------
def isValidObjectName(name):

    name = name.strip()
    if name == "" or len(name) < 2 or len(name) > 16:
        return False
    else:
        p = re.compile("^[a-zA-Z0-9\- ]+$")
        return p.match(myName)
        
#-------------------------------------------------------------------------------
def isValidCategoryName(self, name):
    
    name = name.strip()
    if name == "" or len(name) < 2 or len(name) > 32:
        return False
    else:
        p = re.compile("^[a-zA-Z0-9\- ]+$")
        return p.match(name)

def retrieveBuildingsCache():
    
    # retrieve general buildings info
    query = "SELECT id, storage_workers, energy_production, storage_ore, storage_hydrocarbon, workers, storage_scientists, storage_soldiers, label, description, energy_consumption, workers*maintenance_factor/100, upkeep FROM dt_buildings"
    return oConnExecute(query)

def retrieveBuildingsReqCache():
    
    # retrieve buildings requirements
    # planet elements can't restrict the destruction of a building that made their construction possible
    query = "SELECT buildingid, required_buildingid" +\
            " FROM dt_building_building_reqs" +\
            "    INNER JOIN dt_buildings ON (dt_buildings.id=dt_building_building_reqs.buildingid)" +\
            " WHERE dt_buildings.destroyable"
    return oConnExecute(query)

def retrieveShipsCache():

    # retrieve general Ships info
    query = "SELECT id, label, description FROM dt_ships ORDER BY category, id"
    return oConnExecute(query)

def retrieveShipsReqCache():
    
    # retrieve buildings requirements for ships
    query = "SELECT shipid, required_buildingid FROM dt_ship_building_reqs"
    return oConnExecute(query)

def retrieveResearchCache():

    # retrieve Research info
    query = "SELECT id, label, description FROM dt_researches"
    return oConnExecute(query)

def checkPlanetListCache(Session):
    
    # retrieve Research info
    query = "SELECT id, name, galaxy, sector, planet FROM gm_planets WHERE planet_floor > 0 AND planet_space > 0 AND ownerid=" + str(Session.get("user")) + " ORDER BY id"
    return oConnExecuteAll(query)

def getAllianceTag(allianceid):
    oRs = oConnExecute("SELECT tag FROM gm_alliances WHERE id=" + str(allianceid))
    if oRs:
        return oRs[0]
    else:
        return ""

def getBuildingLabel(buildingid):
    for i in retrieveBuildingsCache():
        if buildingid == i[0]:
            return i[8]

def getBuildingDescription(buildingid):
    for i in retrieveBuildingsCache():
        if buildingid == i[0]:
            return i[9]

def getShipLabel(ShipId):
    for i in retrieveShipsCache():
        if ShipId == i[0]:
            return i[1]

def getShipDescription(ShipId):
    for i in retrieveShipsCache():
        if ShipId == i[0]:
            return i[2]

def getResearchLabel(ResearchId):
    for i in retrieveResearchCache():
        if ResearchId == i[0]:
            return i[1]

class TemplaceContext():
    
    def __init__(self):
        self.template = ""
        self.data = {}

    def AssignValue(self, key, value):
        self.data[key] = value
    
    def Parse(self, key):
        self.data[key] = True
        
# Return an initialized template
def GetTemplate(request, name):
    
    result = TemplaceContext()
    result.template = name + ".html"

    result.AssignValue("PATH_IMAGES", "/assets/")
    result.AssignValue("PATH_TEMPLATE", "/game/templates")

    return result

class ExileMixin:

    def pre_dispatch(self, request, *args, **kwargs):

        self.StartTime = time.clock()

        if not maintenance: connectDB()
        else: return HttpResponseRedirect('/game/maintenance/')

class GlobalView(ExileMixin, View):

    CurrentPlanet = None
    CurrentGalaxyId = None
    CurrentSectorId = None
    scrollY = 0 # how much will be scrolled in vertical after the page is loaded
    showHeader = False
    url_extra_params = ""
    pageTerminated = False
    displayAlliancePlanetName = True
    pagelogged = False
    selected_menu = ""
    
    def pre_dispatch(self, request, *args, **kwargs):
        
        response = super().pre_dispatch(request, *args, **kwargs)
        if response: return response
        
        if not request.session.get(sUser):
            return HttpResponseRedirect("/") # Redirect to home page

        request.session["details"] = ""
        
        # Check that this session is still valid
        response = self.CheckSessionValidity()
        if response: return response
        
        # Check for the planet querystring parameter and if the current planet belongs to the player
        response = self.CheckCurrentPlanetValidity()
        if response: return response
        
        referer = self.request.META.get("HTTP_REFERER", "")
        
        if referer != "":
        
            # extract the website part from the referer url
            posslash = referer[8:].find("/")
            if posslash > 0:
                websitename = referer[8:posslash-8]
            else:
                websitename = referer[8:]
        
            if not "exileng.com" in referer.lower() and not referer.lower() in request.META.get("LOCAL_ADDR") and not "viewtopic" in referer.lower() and not "forum" in referer.lower():
                oConnExecute("SELECT sp_log_referer("+str(self.UserId)+","+dosql(referer) + ")")

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

    # Call this function when the name of a planet has changed or has been colonized or abandonned
    def InvalidatePlanetList(self):
        self.request.session[sPlanetList] = None

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
        query = "SELECT credits, prestige_points FROM gm_profiles WHERE id=" + str(self.UserId) + " LIMIT 1"
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
                " FROM vw_gm_planets WHERE id="+str(self.CurrentPlanet)
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
        if self.request.session.get(sPlanetList):
            planetListArray = self.request.session.get(sPlanetList)
            planetListCount = self.request.session.get(sPlanetListCount)
        else:
            # retrieve planet list
            query = "SELECT id, name, galaxy, sector, planet" + \
                    " FROM gm_planets" + \
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
    
        query = "SELECT buildingid" +\
                " FROM gm_planet_buildings INNER JOIN dt_buildings ON (dt_buildings.id=buildingid AND dt_buildings.is_planet_element)" +\
                " WHERE planetid="+str(self.CurrentPlanet)+\
                " ORDER BY upper(dt_buildings.label)"
        oRs = oConnExecuteAll(query)
    
        i = 0
        if oRs:
            for item in oRs:

                if i % 3 == 0:
                    tpl_header.AssignValue("special1", getBuildingLabel(item[0]))
                elif i % 3 == 1:
                    tpl_header.AssignValue("special2", getBuildingLabel(item[0]))
                else:
                    tpl_header.AssignValue("special3", getBuildingLabel(item[0]))
                    tpl_header.AssignValue("special")
        
                i = i + 1
    
        if i % 3 != 0: tpl_header.Parse("special")

    def FillHeaderCredits(self, tpl_header):
        oRs = oConnExecute("SELECT credits FROM gm_profiles WHERE id="+str(self.UserId))
        tpl_header.AssignValue("credits", oRs[0])
    
    #
    # Parse the menu
    #
    def FillMenu(self, tpl_layout):
        # Initialize the menu template

        tpl = tpl_layout
    
        # retrieve number of new gm_mails & gm_profile_reports
        query = "SELECT (SELECT int4(COUNT(*)) FROM gm_mails WHERE ownerid=" + str(self.UserId) + " AND read_date is NULL)," + \
                "(SELECT int4(COUNT(*)) FROM gm_profile_reports WHERE ownerid=" + str(self.UserId) + " AND read_date is NULL AND datetime <= now());"
        oRs = oConnExecute(query)
        
        if oRs[0] > 0:
            tpl.AssignValue("new_mail", oRs[0])

        if oRs[1] > 0:
            tpl.AssignValue("new_report", oRs[1])

        if self.oAllianceRights:
            if self.oAllianceRights["leader"] or self.oAllianceRights["can_manage_description"] or self.oAllianceRights["can_manage_announce"]: tpl.Parse("show_management")
            if self.oAllianceRights["leader"] or self.oAllianceRights["can_see_reports"]: tpl.Parse("show_reports")
            if self.oAllianceRights["leader"] or self.oAllianceRights["can_see_members_info"]: tpl.Parse("show_members")
    
        if self.SecurityLevel >= 3:
            tpl.Parse("show_mercenary")
            tpl.Parse("show_alliance")
    
        #
        # Fill admin info
        #
        if self.request.session.get("privilege", 0) >= 100:
            
            query = "SELECT int4(MAX(id)) FROM gm_log_server_errors"
            oRs = oConnExecute(query)
            last_errorid = oRs[0]
    
            query = "SELECT int4(MAX(id)) FROM gm_log_notices"
            oRs = oConnExecute(query)
            last_noticeid = oRs[0]
    
            query = "SELECT COALESCE(dev_lasterror, 0), COALESCE(dev_lastnotice, 0) FROM gm_profiles WHERE id=" + self.request.session.get(sLogonUserID)
            oRs = oConnExecute(query)
            if last_errorid > oRs[0]:
                tpl.AssignValue("new_error", last_errorid-oRs[0])
    
            if last_noticeid > oRs[1]:
                tpl.AssignValue("new_notice", last_noticeid-oRs[1])
    
            tpl.Parse("dev")
    
        tpl.AssignValue("planetid", self.CurrentPlanet)
    
        tpl.AssignValue("cur_g", self.CurrentGalaxyId)
        tpl.AssignValue("cur_s", self.CurrentSectorId)
        tpl.AssignValue("cur_p", ((self.CurrentPlanet-1) % 25) + 1)
    
        tpl.AssignValue("selectedmenu", self.selected_menu.replace(".","_"))
    
        if self.selected_menu != "":
            blockname = self.selected_menu + "_selected"
    
            while blockname != "":
                tpl.Parse(blockname)
    
                i = blockname.rfind(".")
                if i > 0: i = i - 1
                blockname = blockname[:i]

        # Assign the menu
        tpl_layout.AssignValue("menu", True)

    def logpage(self):
        self.pagelogged = True

    '''
    sub RedirectTo(url)
        logpage()
    
        pageTerminated = true
    
        Response.Redirect url
        Response.End
    end sub
    '''
    
    '''
    sub displayXML(tpl)
        dim tpl_xml
        set tpl_xml = GetTemplate("layoutxml")
    
        dim oRs, query
    
        ' retrieve number of new gm_mails & gm_profile_reports
        query = "SELECT (SELECT int4(COUNT(*)) FROM gm_mails WHERE ownerid=" & UserId & " AND read_date is NULL)," & _
                "(SELECT int4(COUNT(*)) FROM gm_profile_reports WHERE ownerid=" & UserId & " AND read_date is NULL AND datetime <= now());"
        set oRs = oConn.Execute(query)
    
        tpl_xml.AssignValue "new_mail", oRs(0)
        tpl_xml.AssignValue "new_report", oRs(1)
    
        tpl_xml.AssignValue "content", tpl.output
        tpl_xml.AssignValue "selectedmenu", Replace(selected_menu,".","_")
        tpl_xml.Parse ""
    
        response.contentType = "text/xml"
    
        Session("details") = "sending page"
        response.write tpl_xml.output
    end sub
    '''

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

            #
            # Fill admin info
            #
            if self.request.session.get(sPrivilege) > 100:
    
                if self.IsImpersonating():
                    tpl_layout.AssignValue("login", self.oPlayerInfo["login"])
                    tpl_layout.Parse("impersonating")
                    
                # Assign the time taken to generate the page
                tpl_layout.AssignValue("render_time",  (time.clock() - self.StartTime))
    
                # Assign number of logged players
                oRs = oConnExecute("SELECT int4(count(*)) FROM vw_gm_profiles WHERE lastactivity >= now()-INTERVAL '20 minutes'")
                tpl_layout.AssignValue("players", oRs[0])
                tpl_layout.Parse("dev")
    
                if self.oPlayerInfo["privilege"] == -2:
                    oRs = oConnExecute("SELECT start_time, min_end_time, end_time FROM gm_profile_holidays WHERE userid="+str(self.UserId))
    
                    if oRs:
                        tpl_layout.AssignValue("start_datetime", oRs[0])
                        tpl_layout.AssignValue("min_end_datetime", oRs[1])
                        tpl_layout.AssignValue("end_datetime", oRs[2])
                        tpl_layout.Parse("onholidays")
    
                if self.oPlayerInfo["privilege"] == -1:
                    tpl_layout.AssignValue("ban_datetime", self.oPlayerInfo["ban_datetime"])
                    tpl_layout.AssignValue("ban_reason", self.oPlayerInfo["ban_reason"])
                    tpl_layout.AssignValue("ban_reason_public", self.oPlayerInfo["ban_reason_public"])
    
                    if self.oPlayerInfo["ban_expire"]:
                        tpl_layout.AssignValue("ban_expire_datetime", self.oPlayerInfo["ban_expire"])
                        tpl_layout.Parse("banned.expire")
    
                    tpl_layout.Parse("banned")

            tpl_layout.AssignValue("userid", self.UserId)
            tpl_layout.AssignValue("server", universe)
    
            '''
            if not oPlayerInfo("paid") and Session(sPrivilege) < 100:
    
                connectNexusDB
                set oRs = oNexusConn.Execute("SELECT sp_ad_get_code(" & UserId & ")")
                if not oRs.EOF:
                    if not isnull(oRs[0]):
                        tpl_layout.AssignValue("ad_code", oRs[0]
                        tpl_layout.Parse("ads.code"
                    end if
                end if
    
                tpl_layout.Parse("ads"
                oConn.Execute "UPDATE gm_profiles SET displays_pages=displays_pages+1 WHERE id=" & UserId
            '''
            
            tpl_layout.Parse("menu")
    
            if not self.oPlayerInfo["inframe"]:
                tpl_layout.Parse("test_frame")
            
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
        self.UserId = self.request.session.get(sUser)
    
        # check that this session is still used
        # if a user tries to login multiple times, the first sessions are abandonned

        query = "SELECT ""login"", privilege, lastlogin, credits, lastplanetid, deletion_date, score, planets, previous_score," +\
                "alliance_id, alliance_rank, leave_alliance_datetime IS NULL AND (alliance_left IS NULL OR alliance_left < now()) AS can_join_alliance," +\
                "credits_bankruptcy, mod_planets, mod_commanders," +\
                "ban_datetime, ban_expire, ban_reason, ban_reason_public, orientation, (paid_until IS NOT NULL AND paid_until > now()) AS paid," +\
                " timers_enabled, display_alliance_planet_name, prestige_points, (inframe IS NOT NULL AND inframe) AS inframe, COALESCE(skin, 's_default') AS skin," +\
                "lcid, security_level, (SELECT username FROM public.auth_user WHERE id=" + str(self.UserId) + ") AS username" +\
                " FROM gm_profiles" +\
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
                    " FROM gm_alliance_ranks" +\
                    " WHERE allianceid=" + str(self.AllianceId) + " AND rankid=" + str(self.AllianceRank)
            self.oAllianceRights = oConnRow(query)
    
            if self.oAllianceRights == None:
                self.oAllianceRights = None
                self.AllianceId = None

        # log activity
        if not self.IsImpersonating(): oConnExecute("SELECT internal_profile_log_activity(" + str(self.UserId) + "," + dosql(self.request.META.get("REMOTE_ADDR")) + ",0)")

    # set the new current planet, if the planet doesn't belong to the player then go back to the session planet
    def SetCurrentPlanet(self, planetid):
    
        #
        # Check if a parameter is given and if different than the current planet
        # In that case, try to set it as the new planet : check that this planet belongs to the player
        #
        if (planetid != "") and (planetid != self.CurrentPlanet):
            # check that the new planet belongs to the player
            oRs = oConnExecute("SELECT galaxy, sector FROM gm_planets WHERE planet_floor > 0 AND planet_space > 0 AND id=" + str(planetid) + " and ownerid=" + str(self.UserId))
            if oRs:
                self.CurrentPlanet = planetid
                self.CurrentGalaxyId = oRs[0]
                self.CurrentSectorId = oRs[1]
                self.request.session[sPlanet] = planetid
    
                # save the last planetid
                if not self.request.user.is_impersonate:
                    oConnDoQuery("UPDATE gm_profiles SET lastplanetid=" + str(planetid) + " WHERE id=" + str(self.UserId))
    
                return
    
            self.InvalidatePlanetList()
    
        # 
        # retrieve current planet from session
        #
        self.CurrentPlanet = self.request.session.get(sPlanet, "")
    
        if self.CurrentPlanet != None:
            # check if the planet still belongs to the player
            oRs = oConnExecute("SELECT galaxy, sector FROM gm_planets WHERE planet_floor > 0 AND planet_space > 0 AND id=" + str(self.CurrentPlanet) + " AND ownerid=" + str(self.UserId))
            if oRs:
                # the planet still belongs to the player, exit
                self.CurrentGalaxyId = oRs[0]
                self.CurrentSectorId = oRs[1]
                return
    
            self.InvalidatePlanetList()
    
        # there is no active planet, select the first planet available
        oRs = oConnExecute("SELECT id, galaxy, sector FROM gm_planets WHERE planet_floor > 0 AND planet_space > 0 AND ownerid=" + str(self.UserId) + " LIMIT 1")
    
        # if player owns no planets then the game is over
        if oRs == None:
            if self.IsPlayerAccount():
                return HttpResponseRedirect("/game/game-over/")
            else:
                self.CurrentPlanet = 0
                self.CurrentGalaxyId = 0
                self.CurrentSectorId = 0
    
                return
    
        # assign planet id
        self.CurrentPlanet = oRs[0]
        self.CurrentGalaxyId = oRs[1]
        self.CurrentSectorId = oRs[2]
        self.request.session[sPlanet] = self.CurrentPlanet
    
        # save the last planetid
        if not self.request.user.is_impersonate:
            oConnDoQuery("UPDATE gm_profiles SET lastplanetid=" + str(self.CurrentPlanet) + " WHERE id=" + str(self.UserId))
    
        # a player may wish to destroy a building on a planet that belonged to him
        # if the planet doesn't belong to him anymore, the action may be performed on another planet
        # so we redirect the user to the overview to prevent executing an order on another planet
        return HttpResponseRedirect("/game/overview/")
    
    #
    # check if a planet is given in the querystring and that it belongs to the player
    #
    def CheckCurrentPlanetValidity(self):
    
        # retrieve planet parameter if any
        id = ToInt(self.request.GET.get("planet"), "")
    
        return self.SetCurrentPlanet(id)

def FormatBattle(view, battleid, creator, pointofview, ispubliclink):

    # Retrieve/assign battle info
    query = "SELECT time, planetid, name, galaxy, sector, planet, rounds," + \
            "EXISTS(SELECT 1 FROM gm_battle_ships WHERE battleid=" + str(battleid) + " AND owner_id=" + str(creator) + " AND won LIMIT 1), MD5(key||"+str(creator)+")," + \
            "EXISTS(SELECT 1 FROM gm_battle_ships WHERE battleid=" + str(battleid) + " AND owner_id=" + str(creator) + " AND damages > 0 LIMIT 1) AS see_details" + \
            " FROM gm_battles" + \
            "    INNER JOIN gm_planets ON (planetid=gm_planets.id)" + \
            " WHERE gm_battles.id = " + str(battleid)
    oRs = oConnExecute(query)

    if oRs == None: return

    content = GetTemplate(view.request, "battle")

    content.AssignValue("battleid", battleid)
    content.AssignValue("userid", creator)
    content.AssignValue("key", oRs[8])

    if not ispubliclink:
        # link for the freely viewable report of this battle
        content.AssignValue("baseurl", view.request.META.get("HTTP_HOST"))
        content.Parse("publiclink")

    content.AssignValue("time", oRs[0])
    content.AssignValue("planetid", oRs[1])
    content.AssignValue("planet", oRs[2])
    content.AssignValue("g", oRs[3])
    content.AssignValue("s", oRs[4])
    content.AssignValue("p", oRs[5])
    content.AssignValue("rounds", oRs[6])

    rounds = oRs[6]
    hasWon = oRs[7]
    showEnemyDetails = oRs[9] or hasWon or rounds > 1

    query = "SELECT fleet_id, shipid, destroyed_shipid, sum(count)" + \
            " FROM gm_battle_fleets" + \
            "    INNER JOIN gm_battle_fleet_ship_kills ON (gm_battle_fleets.id=fleetid)" + \
            " WHERE battleid=" + str(battleid) + \
            " GROUP BY fleet_id, shipid, destroyed_shipid" + \
            " ORDER BY sum(count) DESC"
    killsArray = oConnExecuteAll(query)

    query = "SELECT owner_name, fleet_name, shipid, shipcategory, shiplabel, count, lost, killed, won, relation1, owner_id , relation2, fleet_id, attacked, mod_shield, mod_handling, mod_tracking_speed, mod_damage, alliancetag" + \
            " FROM internal_battle_get_result(" + str(battleid) + "," + str(creator) + "," + str(pointofview) + ")"

    oRss = oConnExecuteAll(query)

    if oRss:
        opponents = []
        content.AssignValue("opponents", opponents)
        
        lastFleetId = -1
        lastCategory = -1
        lastPlayerName = ""
        
        for oRs in oRss:
            
            playerName = oRs[0]
            if playerName != lastPlayerName:
                opponent = { 'gm_fleets':[], "count":0,  "lost":0, "killed":0, "after":0 }
                opponents.append(opponent)
                
                opponent["name"] = playerName
                opponent["view"] = oRs[10]
                
                if ispubliclink: opponent["public"] = True
                
                if oRs[13]: opponent["attack"] = True
                else: opponent["defend"] = True
                
                if oRs[18]:
                    opponent["alliancetag"] = oRs[18]
                    opponent["alliance"] = True
                    
                if oRs[11] == rSelf: opponent["self"] = True
                elif oRs[11] == rAlliance: opponent["ally"] = True
                elif oRs[11] == rFriend: opponent["friend"] = True
                else: opponent["enemy"] = True
                
                if oRs[8]: opponent["won"] = True
                
                lastPlayerName = playerName
            
            fleetId = oRs[12]
            if fleetId != lastFleetId:
                fleet = { 'ships':[], "count":0,  "lost":0, "killed":0, "after":0 }
                opponent['gm_fleets'].append(fleet)
                
                fleet["name"] = oRs[1]
                    
                if oRs[11] == rSelf: fleet["self"] = True
                elif oRs[11] == rAlliance: fleet["ally"] = True
                elif oRs[11] == rFriend: fleet["friend"] = True
                else: fleet["enemy"] = True
                
                if not showEnemyDetails and oRs[9] < rFriend:
                    fleet["mod_shield"] = "?"
                    fleet["mod_handling"] = "?"
                    fleet["mod_tracking_speed"] = "?"
                    fleet["mod_damage"] = "?"
                else:
                    fleet["mod_shield"] = oRs[14]
                    fleet["mod_handling"] = oRs[15]
                    fleet["mod_tracking_speed"] = oRs[16]
                    fleet["mod_damage"] = oRs[17]
                
                lastFleetId = fleetId
            
            if showEnemyDetails or oRs[9] >= rFriend:
                
                # if not a friend and there was no more than a fixed number of rounds, display ships by category and not their name
                if not hasWon and rounds <= 1 and oRs[9] < rFriend:
                    
                    category = oRs[3]
                    if category != lastCategory:
                        ship = { "ships":0, "lost":0, "killed":0, "after":0 }
                        fleet['ships'].append(ship)
                        
                        ship["category" + str(category)] = True
                        
                        lastCategory = category
                
                    ship["ships"] += oRs[5]
                    ship["lost"] += oRs[6]
                    ship["killed"] += oRs[7]
                    ship["after"] += oRs[5]-oRs[6]
                    
                else:
                    ship = { 'kills':[] }
                    fleet['ships'].append(ship)
                    
                    ship["label"] = oRs[4]
                    ship["ships"] = oRs[5]
                    ship["lost"] = oRs[6]
                    ship["killed"] = oRs[7]
                    ship["after"] = oRs[5]-oRs[6]
                    
                    killed = 0
                    for i in killsArray:
                        if oRs[12] == i[0] and oRs[2] == i[1]:
                            kill = {}
                            ship['kills'].append(kill)
                            
                            kill["killed_name"] = getShipLabel(i[2])
                            kill["killed_count"] = i[3]
                            
                            killed = killed + 1 # count how many different ships were destroyed
        
                    if killed == 0: ship["killed_zero"] = True
                    if killed > 1: ship["killed_total"] = True
        
                fleet["count"] += oRs[5]
                fleet["lost"] += oRs[6]
                fleet["killed"] += oRs[7]
                fleet["after"] += oRs[5]-oRs[6]
        
                opponent["count"] += oRs[5]
                opponent["lost"] += oRs[6]
                opponent["killed"] += oRs[7]
                opponent["after"] += oRs[5]-oRs[6]
                
    return content
