# -*- coding: utf-8 -*-

import re
import time

from math import sqrt
from random import *

from django.contrib.auth.mixins import LoginRequiredMixin
from django.db import connection
from django.http import HttpResponse, HttpResponseRedirect
from django.shortcuts import render
from django.utils import timezone
from django.views import View

universe = "ng03"

maintenance = False
registration = False

rUninhabited = -3
rWar = -2
rHostile = -1
rFriend = 0
rAlliance = 1
rSelf = 2

sPlanet = "planet"
sPrivilege = "privilege"

cursor = None

#-------------------------------------------------------------------------------
def dbRow(query):
    cursor.execute(query)
    return cursor.fetchone()

#-------------------------------------------------------------------------------
def dbRowRetry(query):
    i = 0
    while i < 5:
        try:
            i = 10
            return dbRow(query)
        except:
            i = i + 1
    return None

#-------------------------------------------------------------------------------
def dbRows(query):
    cursor.execute(query)
    return cursor.fetchall()
    
#-------------------------------------------------------------------------------
def dictFetchAll(cursor):
    columns = [col[0] for col in cursor.description]
    return [
        dict(zip(columns, row))
        for row in cursor.fetchall()
    ]

#-------------------------------------------------------------------------------
def dictFetchOne(cursor):
    results = dictFetchAll(cursor)
    if results: return results[0]
    else: return None

#-------------------------------------------------------------------------------
def dbDictRow(query):
    cursor.execute(query)
    return dictFetchOne(cursor)

#-------------------------------------------------------------------------------
def dbDictRows(query):
    cursor.execute(query)
    return dictFetchAll(cursor)
    
#-------------------------------------------------------------------------------
def dbExecute(query):
    cursor.execute(query)
    
#-------------------------------------------------------------------------------
def dbExecuteRetryNoRow(query):
    i = 0
    while i < 5:
        try:
            i = 10
            dbRow(query)
        except:
            i = i + 1

#-------------------------------------------------------------------------------
def sqlStr(text):
    ret = text.replace('\\', '\\\\') 
    ret = ret.replace('\'', '\'\'')
    ret = '\'' + ret + '\''
    return ret

#-------------------------------------------------------------------------------
def sqlValue(val):
    if val == None or val == "": return "Null"
    else: return str(val)

#-------------------------------------------------------------------------------
def ToInt(s, defaultValue):
    if(s == "" or s == None): return defaultValue
    i = int(float(s))
    if i == None: return defaultValue
    return i

#-------------------------------------------------------------------------------
def ToBool(s, defaultValue):
    if(s == "" or s == None): return defaultValue
    i = int(float(s))
    if i == 0: return defaultValue
    return True

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
    url = url.strip()
    p = re.compile("^(http|https|ftp)\://([a-zA-Z0-9\.\-]+(\:[a-zA-Z0-9\.&%\$\-]+)*@)?((25[0-5]|2[0-4][0-9]|[0-1]{1}[0-9]{2}|[1-9]{1}[0-9]{1}|[1-9])\.(25[0-5]|2[0-4][0-9]|[0-1]{1}[0-9]{2}|[1-9]{1}[0-9]{1}|[1-9]|0)\.(25[0-5]|2[0-4][0-9]|[0-1]{1}[0-9]{2}|[1-9]{1}[0-9]{1}|[1-9]|0)\.(25[0-5]|2[0-4][0-9]|[0-1]{1}[0-9]{2}|[1-9]{1}[0-9]{1}|[0-9])|([a-zA-Z0-9\-]+ \.)*[a-zA-Z0-9\-]+ \.[a-zA-Z]{2,4})(\:[0-9]+)?(/[^/][a-zA-Z0-9\.\,\?\'\\/\+&%\$#\=~_\-@]*)*$")
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
def isValidCategoryName(name):
    name = name.strip()
    if name == "" or len(name) < 2 or len(name) > 32:
        return False
    else:
        p = re.compile("^[a-zA-Z0-9\- ]+$")
        return p.match(name)
        
#-------------------------------------------------------------------------------
def isValidAlliancename(name):
    name = name.strip()
    if name == "" or len(name) < 4 or len(name) > 32:
        return False
    else:
        p = re.compile("^[a-zA-Z0-9]+([ ]?[.]?[\-]?[ ]?[a-zA-Z0-9]+)*$")
        return p.match(name)
        
#-------------------------------------------------------------------------------
def isValidAlliancetag(tag):
    tag = tag.strip()
    if tag == "" or len(tag) < 2 or len(tag) > 4:
        return False
    else:
        p = re.compile("^[a-zA-Z0-9]+$")
        return p.match(tag)
        
#-------------------------------------------------------------------------------
def isValiddescription(self, description):
    return len(description) < 8192

#-------------------------------------------------------------------------------
def dtBuildings():
    query = "SELECT id, storage_workers, energy_production, storage_ore, storage_hydro, workers, storage_scientists, storage_soldiers, label, description, energy_consumption, workers*maintenance_factor/100, upkeep FROM dt_buildings"
    return dbRow(query)

#-------------------------------------------------------------------------------
def dtBuildingBuildingReqs():
    query = "SELECT buildingid, required_buildingid" + \
            " FROM dt_building_building_reqs" + \
            "    INNER JOIN dt_buildings ON (dt_buildings.id=dt_building_building_reqs.buildingid)" + \
            " WHERE dt_buildings.destroyable"
    return dbRow(query)

#-------------------------------------------------------------------------------
def dtShips():
    query = "SELECT id, label, description FROM dt_ships ORDER BY category, id"
    return dbRow(query)

#-------------------------------------------------------------------------------
def dtShipBuildingReqs():
    query = "SELECT shipid, required_buildingid FROM dt_ship_building_reqs"
    return dbRow(query)

#-------------------------------------------------------------------------------
class BaseMixin(LoginRequiredMixin):

    def pre_dispatch(self, request, *args, **kwargs):

        if maintenance: return HttpResponseRedirect('/game/maintenance/')
            
        global cursor
        cursor = connection.cursor()

#-------------------------------------------------------------------------------
class BaseView(BaseMixin, View):

    currentPlanetId = None
    currentGalaxy = None
    currentSector = None
    
    scrollY = 0
    showHeader = False
    selected_menu = ""
    
    #---------------------------------------------------------------------------
    def pre_dispatch(self, request, *args, **kwargs):
        
        response = super().pre_dispatch(request, *args, **kwargs)
        if response: return response
        
        self.userId = request.user.id
        
        # --- user checking & info
        
        query = "SELECT ""login"", privilege, lastlogin, credits, lastplanetid, deletion_date, score, planets, previous_score," + \
                " alliance_id, alliance_rank, leave_alliance_datetime IS NULL AND (alliance_left IS NULL OR alliance_left < now()) AS can_join_alliance," + \
                " credits_bankruptcy, mod_planets, mod_commanders, orientation," + \
                " prestige_points, COALESCE(skin, 's_default') AS skin," + \
                " (SELECT username FROM public.auth_user WHERE id=" + str(self.userId) + ") AS username" + \
                " FROM gm_profiles" + \
                " WHERE id=" + str(self.userId)
        self.userInfo = dbDictRow(query)        
        if self.userInfo == None: return HttpResponseRedirect("/")
    
        if self.userInfo["privilege"] == -1: return HttpResponseRedirect("/game/locked/")
        if self.userInfo["privilege"] == -2: return HttpResponseRedirect("/game/holidays/")
        if self.userInfo["privilege"] == -3: return HttpResponseRedirect("/game/wait/")
        
        if self.userInfo["credits_bankruptcy"] <= 0: return HttpResponseRedirect("/game/game-over/")
        
        self.allianceId = self.userInfo["alliance_id"]
        self.allianceRankId = self.userInfo["alliance_rank"]
        self.allianceRights = None
        
        # --- alliance info
        
        if self.allianceId:
            query = "SELECT label, leader, can_invite_player, can_kick_player, can_create_nap, can_break_nap, can_ask_money, can_see_reports, can_accept_money_requests, can_change_tax_rate, can_mail_alliance," + \
                    " can_manage_description, can_manage_announce, can_see_members_info, can_use_alliance_radars, can_order_other_fleets" + \
                    " FROM gm_alliance_ranks" + \
                    " WHERE allianceid=" + str(self.allianceId) + " AND rankid=" + str(self.allianceRankId)
            self.allianceRights = dbDictRow(query)

        if not request.user.is_impersonate:
            dbRow("SELECT internal_profile_log_activity(" + str(self.userId) + "," + sqlStr(self.request.META.get("REMOTE_ADDR")) + ",0)")
        
        # --- set current planet
        
        planetId = ToInt(request.GET.get("planet"), 0)
        if planetId != 0:
        
            row = dbRow("SELECT galaxy, sector FROM gm_planets WHERE planet_floor > 0 AND planet_space > 0 AND id=" + str(planetId) + " and ownerid=" + str(self.userId))
            if row:
            
                self.currentPlanetId = planetId
                self.currentGalaxy = row[0]
                self.currentSector = row[1]

                request.session[sPlanet] = planetId
    
                if not self.request.user.is_impersonate:
                    dbExecute("UPDATE gm_profiles SET lastplanetid=" + str(planetId) + " WHERE id=" + str(self.userId))
    
        # --- current planet checking & info
        
        self.currentPlanetId = request.session.get(sPlanet, "")    
        if self.currentPlanetId != "":
        
            row = dbRow("SELECT galaxy, sector FROM gm_planets WHERE planet_floor > 0 AND planet_space > 0 AND id=" + str(self.currentPlanetId) + " AND ownerid=" + str(self.userId))
            if row:

                self.currentGalaxy = row[0]
                self.currentSector = row[1]
            
        if self.currentGalaxy == None or self.currentSector == None:
        
            row = dbRow("SELECT id, galaxy, sector FROM gm_planets WHERE planet_floor > 0 AND planet_space > 0 AND ownerid=" + str(self.userId) + " LIMIT 1")
            if row == None: return HttpResponseRedirect("/game/game-over/")
        
            self.currentPlanetId = row[0]
            self.currentGalaxy = row[1]
            self.currentSector = row[2]
            
            self.request.session[sPlanet] = self.currentPlanetId
        
            if not self.request.user.is_impersonate:
                dbExecute("UPDATE gm_profiles SET lastplanetid=" + str(self.currentPlanetId) + " WHERE id=" + str(self.userId))
    
            return HttpResponseRedirect("/game/overview/")

    #---------------------------------------------------------------------------
    def get(self, request, *args, **kwargs):
    
        content = self.loadTemplate(self.template_name)
        
        pageData = {}
        self.fillContent(request, pageData)
        content["pagedata"] = pageData
        
        return self.display(content)

    #---------------------------------------------------------------------------
    def post(self, request, *args, **kwargs):
        
        action = request.POST.get("action","")
        if action != "":
            error = self.processAction(request, action)
            if error == 0:
                return HttpResponseRedirect(self.success_url)
            else:
                content = self.loadTemplate(self.template_name)
                
                if error: content["error_" + action] = error
                else: content["error_unknown"] = True
                
                pageData = {}
                self.fillContent(request, pageData)
                content["pagedata"] = pageData
                
                return self.display(content)

    #---------------------------------------------------------------------------
    def hasRight(self, right):
    
        if self.allianceRights == None: return False
        else: return self.allianceRights["leader"] or self.allianceRights[right]
    
    #---------------------------------------------------------------------------
    def getPlanetName(self, relation, radarStrength, ownerName, planetName):

        if relation == rSelf: return planetName if planetName else ""
        elif relation == rAlliance:
            if self.displayAlliancePlanetName: return planetName if planetName else ""
            else: return ownerName if ownerName else ""
        elif relation == rFriend: return ownerName if ownerName else ""
        elif radarStrength > 0: return ownerName if ownerName else ""
        else: return ""

    #---------------------------------------------------------------------------
    def getPlanetImg(self, id, floor):
    
        img = 1 + (floor + id) % 21
        if img < 10: img = "0" + str(img)
        return str(img)

    #---------------------------------------------------------------------------
    def getpercent(self, current, max, slice):
    
        if current >= max or max == 0: return 100
        else: return slice * int(100 * current / max / slice)
                 
    #---------------------------------------------------------------------------
    def loadTemplate(self, name):
        
        self.template = name + ".html"
        
        content = {}
        content["PATH_IMAGES"] = "/assets/"

        return content

    #---------------------------------------------------------------------------
    def display(self, content):

        content["userid"] = self.userId
        content["server"] = universe
        content["credits"] = self.userInfo["credits"]
        content["delete_datetime"] = self.userInfo["deletion_date"]
        
        if self.userInfo["skin"]: content["skin"] = self.userInfo["skin"]
        else: content["skin"] = "s_transparent"

        if self.scrollY != 0: content["scrolly"] = self.scrollY
        
        if self.userInfo["credits"] < 0: content["bankruptcy_hours"] = self.userInfo["credits_bankruptcy"]

        # --- menu data

        query = "SELECT (SELECT int4(COUNT(*)) FROM gm_mails WHERE ownerid=" + str(self.userId) + " AND read_date is NULL)," + \
                "(SELECT int4(COUNT(*)) FROM gm_profile_reports WHERE ownerid=" + str(self.userId) + " AND read_date is NULL AND datetime <= now());"
        row = dbRow(query)
        
        content["new_mail"] = row[0]
        content["new_report"] = row[1]

        if self.allianceRights:
            if self.allianceRights["leader"] or self.allianceRights["can_manage_description"] or self.allianceRights["can_manage_announce"]: content["show_management"] = True
            if self.allianceRights["leader"] or self.allianceRights["can_see_reports"]: content["show_reports"] = True
            if self.allianceRights["leader"] or self.allianceRights["can_see_members_info"]: content["show_members"] = True
        
        content["cur_planetid"] = self.currentPlanetId
        content["cur_g"] = self.currentGalaxy
        content["cur_s"] = self.currentSector
        content["cur_p"] = ((self.currentPlanetId - 1) % 25) + 1
    
        if self.selected_menu != "":
            blockname = self.selected_menu + "_selected"
    
            while blockname != "":
                content[blockname] = True
    
                i = blockname.rfind(".")
                if i > 0: i = i - 1
                blockname = blockname[:i]
    
        content["selected_menu"] = self.selected_menu.replace(".","_")
        
        if self.showHeader == True:

            # --- user info
            
            query = "SELECT credits, prestige_points FROM gm_profiles WHERE id=" + str(self.userId) + " LIMIT 1"
            row = dbRow(query)
            
            content["money"] = row[0]
            content["pp"] = row[1]
        
            # --- current planet info
            
            query = "SELECT ore, ore_production, ore_capacity," + \
                    "hydro, hydro_production, hydro_capacity," + \
                    "workers, workers_busy, workers_capacity," + \
                    "energy_consumption, energy_production," + \
                    "floor_occupied, floor," + \
                    "space_occupied, space, workers_for_maintenance," + \
                    "mod_production_ore, mod_production_hydro, energy, energy_capacity, soldiers, soldiers_capacity, scientists, scientists_capacity" + \
                    " FROM vw_gm_planets WHERE id=" + str(self.currentPlanetId)
            row = dbRow(query)
        
            content["ore"] = row[0]
            content["ore_prod"] = row[1]
            content["ore_stock"] = row[2]
            content["ore_level"] = self.getpercent(row[0], row[2], 10)
            
            if row[16] >= 0 and row[6] >= row[15]: content["ore_prod_normal"] = True
            else: content["ore_prod_medium"] = True
        
            content["hydro"] = row[3]
            content["hydro_prod"] = row[4]
            content["hydro_stock"] = row[5]
            content["hydro_level"] = self.getpercent(row[3], row[5], 10)
            
            if row[17] >= 0 and row[6] >= row[15]: content["hydro_prod_normal"] = True
            else: content["hydro_prod_medium"] = True
        
            content["worker"] = row[6]
            content["worker_stock"] = row[8]
            content["worker_idle"] = row[6] - row[7]
            content["worker_maintenance"] = row[15]
        
            content["soldier"] = row[20]
            content["soldier_capacity"] = row[21]
            if row[20] * 250 < row[6] + row[22]: content["soldier_low"] = True
        
            content["scientist"] = row[22]
            content["scientist_stock"] = row[23]
        
            content["energy"] = row[18]
            content["energy_capacity"] = row[19]
            content["energy_production"] = row[10] - row[9]       
            if row[9] > row[10]: content["energy_low"] = True
        
            content["floor"] = row[12]
            content["floor_occupied"] = row[11]
        
            content["space"] = row[14]
            content["space_occupied"] = row[13]

            # --- user planet list

            planets = []
            content["planets"] = planets
            
            query = "SELECT id, name, galaxy, sector, planet" + \
                    " FROM gm_planets" + \
                    " WHERE planet_floor > 0 AND planet_space > 0 AND ownerid=" + str(self.userId) + \
                    " ORDER BY id"
            rows = dbRows(query)            
            for row in rows:
        
                planet = {}
                planets.append(planet)
                
                planet["id"] = row[0]
                planet["name"] = row[1]
                planet["g"] = row[2]
                planet["s"] = row[3]
                planet["p"] = row[4]
        
                if row[0] == self.currentPlanetId: planet["selected"] = True
            
            # --- current planet bonuses
            
            query = "SELECT buildingid" + \
                    " FROM gm_planet_buildings INNER JOIN dt_buildings ON (dt_buildings.id=buildingid AND dt_buildings.is_planet_element)" + \
                    " WHERE planetid=" + str(self.currentPlanetId) + \
                    " ORDER BY upper(dt_buildings.label)"
            rows = dbRows(query)
            if rows:
                i = 0
                for row in rows:

                    if i % 3 == 0:
                        content["special1"] = getBuildingLabel(row[0])
                    elif i % 3 == 1:
                        content["special2"] = getBuildingLabel(row[0])
                    else:
                        content["special3"] = getBuildingLabel(row[0])
                        content["special"] = True
            
                    i = i + 1
        
            if i % 3 != 0: content["special"] = True
            
            content["context"] = True

        return render(self.request, self.template, content)

#-------------------------------------------------------------------------------
class RestView(BaseView):

    #---------------------------------------------------------------------------
    def dispatch(self, request, *args, **kwargs):

        response = super().pre_dispatch(request, *args, **kwargs)
        if response: return response
        
        return super().dispatch(request, *args, **kwargs)

    #---------------------------------------------------------------------------
    def post(self, request, *args, **kwargs):
        
        action = request.POST.get("action","")
        if action != "":
            return self.processAction(request, action)
    
#-------------------------------------------------------------------------------
def formatBattle(view, battleid, creator, pointofview, ispubliclink):

    content = {}
    
    # --- battle info
    
    query = "SELECT time, planetid, name, galaxy, sector, planet, rounds," + \
            " EXISTS(SELECT 1 FROM gm_battle_ships WHERE battleid=" + str(battleid) + " AND owner_id=" + str(creator) + " AND won LIMIT 1), MD5(key||" + str(creator) + ")," + \
            " EXISTS(SELECT 1 FROM gm_battle_ships WHERE battleid=" + str(battleid) + " AND owner_id=" + str(creator) + " AND damages > 0 LIMIT 1) AS see_details" + \
            " FROM gm_battles" + \
            "    INNER JOIN gm_planets ON (planetid=gm_planets.id)" + \
            " WHERE gm_battles.id = " + str(battleid)
    row = dbRow(query)
    if row == None: return None

    content["battleid"] = battleid
    content["userid"] = creator
    content["key"] = row[8]
    content["time"] = row[0]
    content["planetid"] = row[1]
    content["planetname"] = row[2]
    content["g"] = row[3]
    content["s"] = row[4]
    content["p"] = row[5]
    content["rounds"] = row[6]

    if not ispubliclink:
        content["baseurl"] = view.request.META.get("HTTP_HOST")

    # --- kills data

    query = "SELECT fleet_id, shipid, destroyed_shipid, sum(count)" + \
            " FROM gm_battle_fleets" + \
            "    INNER JOIN gm_battle_fleet_ship_kills ON (gm_battle_fleets.id=fleetid)" + \
            " WHERE battleid=" + str(battleid) + \
            " GROUP BY fleet_id, shipid, destroyed_shipid" + \
            " ORDER BY sum(count) DESC"
    kills = dbRows(query)

    # --- battle data

    rounds = row[6]
    hasWon = row[7]
    showEnemyDetails = row[9] or hasWon or rounds > 1

    query = "SELECT owner_name, fleet_name, shipid, shipcategory, shiplabel, count, lost, killed, won, relation1, owner_id , relation2, fleet_id, attacked, mod_shield, mod_handling, mod_tracking_speed, mod_damage, alliancetag" + \
            " FROM internal_battle_get_result(" + str(battleid) + "," + str(creator) + "," + str(pointofview) + ")"
    rows = dbRows(query)
    if rows:
    
        opponents = []
        content["opponents"] = opponents
        
        lastFleetId = -1
        lastCategory = -1
        lastPlayerName = ""
        
        for row in rows:
            
            if row[0] != lastPlayerName:
                lastPlayerName = row[0]
                
                opponent = { 'gm_fleets':[], "count":0,  "lost":0, "killed":0, "after":0 }
                opponents.append(opponent)
                
                opponent["name"] = playerName
                opponent["view"] = row[10]
                opponent["stance"] = row[13]                
                opponent["tag"] = row[18]
                
                if ispubliclink: opponent["public"] = True
                    
                if row[11] == rSelf: opponent["self"] = True
                elif row[11] == rAlliance: opponent["ally"] = True
                elif row[11] == rFriend: opponent["friend"] = True
                else: opponent["enemy"] = True
                
                if row[8]: opponent["won"] = True
            
            if row[12] != lastFleetId:
                lastFleetId = row[12]
                
                fleet = { 'ships':[], "count":0,  "lost":0, "killed":0, "after":0 }
                opponent['fleets'].append(fleet)
                
                fleet["name"] = row[1]
                    
                if row[11] == rSelf: fleet["self"] = True
                elif row[11] == rAlliance: fleet["ally"] = True
                elif row[11] == rFriend: fleet["friend"] = True
                else: fleet["enemy"] = True
                
                if not showEnemyDetails and row[9] < rFriend:
                    fleet["mod_shield"] = "?"
                    fleet["mod_handling"] = "?"
                    fleet["mod_tracking_speed"] = "?"
                    fleet["mod_damage"] = "?"
                else:
                    fleet["mod_shield"] = row[14]
                    fleet["mod_handling"] = row[15]
                    fleet["mod_tracking_speed"] = row[16]
                    fleet["mod_damage"] = row[17]
            
            if showEnemyDetails or row[9] >= rFriend:
                if not hasWon and rounds <= 1 and row[9] < rFriend:
                    
                    if row[3] != lastCategory:
                        lastCategory = row[3]
                        
                        ship = { "ships":0, "lost":0, "killed":0, "after":0 }
                        fleet['ships'].append(ship)
                        
                        ship["category"] = row[3]
                                        
                    ship["ships"] += row[5]
                    ship["lost"] += row[6]
                    ship["killed"] += row[7]
                    ship["after"] += row[5] - row[6]
                    
                else:
                    ship = { 'kills':[] }
                    fleet['ships'].append(ship)
                    
                    ship["label"] = row[4]
                    ship["ships"] = row[5]
                    ship["lost"] = row[6]
                    ship["killed"] = row[7]
                    ship["after"] = row[5] - row[6]
                    
                    for i in kills:
                        if row[12] == i[0] and row[2] == i[1]:
                        
                            kill = {}
                            ship['kills'].append(kill)
                            
                            kill["name"] = getShipLabel(i[2])
                            kill["count"] = i[3]
        
                fleet["count"] += row[5]
                fleet["lost"] += row[6]
                fleet["killed"] += row[7]
                fleet["after"] += row[5] - row[6]
                
                opponent["count"] += row[5]
                opponent["lost"] += row[6]
                opponent["killed"] += row[7]
                opponent["after"] += row[5] - row[6]
                
    return content
