# -*- coding: utf-8 -*-

from django.core.cache import cache
from django.utils import timezone

from web_game.lib.exile import *
from web_game.lib.sql import *

# this script is made to cache some data from the sql server that doesn't change often

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
    if allianceid == None:
        return ""

    allianceTag = cache.get("AllianceTag_" + str(allianceid))

    if allianceTag == None:
        oRs = oConnExecute("SELECT tag FROM gm_alliances WHERE id=" + str(allianceid))
        if oRs:
            return oRs[0]
        else:
            return ""
    
    return allianceTag

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

def getResearchDescription(ResearchId):
    for i in retrieveResearchCache():
        if ResearchId == i[0]:
            return i[2]