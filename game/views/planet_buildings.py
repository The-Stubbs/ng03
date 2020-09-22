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
        
        self.showHeader = True
        
        dtBuildings()
        dtBuildingBuildingReqs()
        
        Action = request.GET.get("a","").lower()
        BuildingId = ToInt(request.GET.get("b"), "")
        
        if BuildingId != "":
            BuildingId = BuildingId
        
            if Action == "build":
                self.StartBuilding(BuildingId)
        
            elif Action== "cancel":
                self.CancelBuilding(BuildingId)
    
            elif Action== "destroy":
                self.DestroyBuilding(BuildingId)
        
        y = ToInt(request.GET.get("y"),"")
        scriptname = request.META.get("SCRIPT_NAME")
        
        if y != "":
            request.session["scrollExpire"] = 5/(24*3600) # allow 5 seconds
            request.session["scrollPage"] = scriptname
            request.session["scrolly"] = y
            
            return HttpResponseRedirect(scriptname + "?planet=" + str(self.currentPlanetId))
        else:
            
            # if scrolly is stored in the session and is still valid, set the scrolly of the displayed page
            if request.session.get("scrolly") != "" and request.session.get("scrollExpire", 0) > 0 and request.session.get("scrollPage") == scriptname:
                self.scrollY = request.session.get("scrolly")
                request.session["scrolly"] = ""
            
            self.RetrievePlanetInfo()
            return self.ListBuildings()

    def RetrievePlanetInfo(self):
        # Retrieve recordset of current planet
        query = "SELECT ore, hydro, workers-workers_busy, workers_capacity - workers, energy, " + \
                " floor - floor_occupied, space - space_occupied," + \
                " mod_production_ore, mod_production_hydro, mod_production_energy," + \
                " ore_capacity, hydro_capacity," + \
                " scientists, scientists_capacity, soldiers, soldiers_capacity, energy_production-energy_consumption" + \
                " FROM vw_gm_planets" + \
                " WHERE id="+str(self.currentPlanetId)
        row = dbRow(query)
    
        if row == None: return
    
        self.OreBonus = row[7]
        self.HydroBonus = row[8]
        self.EnergyBonus = row[9]
        self.pOre = row[0]
        self.phydro = row[1]
        self.pWorkers = row[2]
        self.pVacantWorkers = row[3]
        self.pEnergy = row[4]
        self.pFloor = row[5]
        self.pSpace = row[6]
        self.pBonusEnergy = row[9]
        self.pOreCapacity = row[10]
        self.phydroCapacity = row[11]
    
        self.pScientists = row[12]
        self.pScientistsCapacity = row[13]
        self.pSoldiers = row[14]
        self.pSoldiersCapacity = row[15]
    
        # Retrieve buildings of current planet
        query = "SELECT planetid, buildingid, quantity FROM gm_planet_buildings WHERE quantity > 0 AND planetid=" + str(self.currentPlanetId)
        oPlanetBuildings = dbRow(query)
        
        if not oPlanetBuildings:
            self.buildingsCount = -1
        else:
            self.buildingsArray = oPlanetBuildings
            self.buildingsCount = len(self.buildingsArray)
    
    # check if we already have this building on the planet and return the number of this building on this planet
    def BuildingQuantity(self, BuildingId):
    
        Quantity = 0
    
        for i in self.buildingsArray:
            if BuildingId == i[1]:
                Quantity = int(i[2])
                break
                
        return Quantity
    
    # check if some buildings on the planet requires the presence of the given building
    def HasBuildingThatDependsOn(self, BuildingId):
        ret = False
    
        for i in dtBuildingBuildingReqs():
            if BuildingId == i[1]:
                requiredBuildId = i[0]
    
                if self.BuildingQuantity(requiredBuildId) > 0:
                    ret = True
                    break
                    
        return ret
    
    def HasEnoughWorkersToDestroy(self, BuildingId):
        ret = True
        
        for i in dtBuildings():
            if BuildingId == i[0]:
                if i[5]/2 > self.pWorkers:
                    ret = False
                    break
                    
        return ret
    
    def HasEnoughStorageAfterDestruction(self, BuildingId):
        ret = False
    
        # 1/ if we want to destroy a building that increase max population: check that 
        # the population is less than the limit after the building destruction
        # 2/ if the building produces energy, check that there will be enough energy after
        # the building destruction
        # 3/ if the building increases the capacity of ore or hydro, check that there is not
        # too much ore/hydro
        for i in dtBuildings():
            if BuildingId == i[0]:
                if (i[1] > 0) and (self.pVacantWorkers < i[1]):
                    ret = True
                    break
    
                # check if scientists/soldiers are lost
                if self.pScientists > self.pScientistsCapacity-i[6]:
                    ret = True
                    break
    
                if self.pSoldiers > self.pSoldiersCapacity-i[7]:
                    ret = True
                    break
    
                # check if a storage building is destroyed
                if self.pOre > self.pOreCapacity-i[3]:
                    ret = True
                    break
    
                if self.phydro > self.phydroCapacity-i[4]:
                    ret = True
                    break
                    
        return ret

    def getBuildingMaintenanceWorkers(self, BuildingId):
        ret = 0
    
        for i in dtBuildings():
            if BuildingId == i[0]:
                ret = i[11]
                break
                    
        return ret
    
    # List all the available buildings
    def ListBuildings(self):
    
        # count number of buildings under construction
        row = dbRow("SELECT int4(count(*)) FROM gm_planet_building_pendings WHERE planetid=" + str(self.currentPlanetId) + " LIMIT 1")
        underConstructionCount = row[0]
    
        # list buildings that can be built on the planet
        query = "SELECT id, category, cost_prestige, cost_ore, cost_hydro, cost_energy, cost_credits, workers, floor, space," + \
                "construction_maximum, quantity, build_status, construction_time, destroyable, '', production_ore, production_hydro, energy_production, buildings_requirements_met, destruction_time," + \
                "upkeep, energy_consumption, buildable" + \
                " FROM vw_gm_planet_buildings" + \
                " WHERE planetid=" + str(self.currentPlanetId) + " AND ((buildable AND research_requirements_met) or quantity > 0)"
    
        oRss = dbRow(query)
        content = self.loadTemplate("buildings")
    
        content.AssignValue("planetid", str(self.currentPlanetId))
    
        cat_id = -1
        lastCategory = -1
            
        categories = []
        index = 1
        for row in rows:
            # if can be built or has some already built, display it
            if row[19] or row[11] > 0:
        
                BuildingId = row[0]
        
                CatId = row[1]
        
                if CatId != lastCategory:
                    category = {'id': CatId, 'buildings':[]}
                    categories.append(category)
                    lastCategory = CatId
                    
                building = {}
                building["id"] = BuildingId
                building["name"] = getBuildingLabel(row[0])
        
                building["ore"] = row[3]
                building["hydro"] = row[4]
                building["energy"] = row[5]
                building["credits"] = row[6]
                building["workers"] = row[7]
                building["prestige"] = row[2]
        
                building["floor"] = row[8]
                building["space"] = row[9]
                building["time"] = row[13]
                building["description"] = getBuildingDescription(row[0])
        
                OreProd= row[16]
                HydroProd= row[17]
                EnergyProd= row[18]
        
                building["ore_prod"] = int(OreProd)
                building["hydro_prod"] = int(HydroProd)
                building["energy_prod"] = int(EnergyProd)
                building["ore_modifier"] = int(OreProd*(self.OreBonus-100)/100)
                building["hydro_modifier"] = int(HydroProd*(self.HydroBonus-100)/100)
                building["energy_modifier"] = int(EnergyProd*(self.EnergyBonus-100)/100)
        
                if OreProd != 0 or HydroProd != 0 or EnergyProd != 0:
                    if self.OreBonus < 100 and OreProd != 0:
                        building["tipprod_ore_malus"] = True
                    else:
                        building["tipprod_ore_bonus"] = True
                    
                    building["tipprod_ore"] = True

                    if self.HydroBonus < 100 and HydroProd != 0:
                        building["tipprod.hydro.malus"] = True
                    else:
                        building["tipprod.hydro.bonus"] = True
                    
                    building["tipprod.hydro"] = True

                    if self.EnergyBonus < 100 and EnergyProd != 0:
                        building["tipprod.energy.malus"] = True
                    else:
                        building["tipprod.energy.bonus"] = True
                    
                    building["tipprod.energy"] = True
                    building["tipprod"] = True
                
                maximum = row[10]
                quantity = row[11]
        
                building["quantity"] = quantity
        
                status = row[12]
        
                building["remainingtime"] = ""
                building["nextdestroytime"] = ""
        
                if status:
                    if status < 0: status = 0
        
                    building["remainingtime"] = status
                    building["underconstruction"] = True
                    building["isbuilding"] = True
        
                elif not row[23]:
                    building["limitreached"] = True
                elif (quantity > 0) and (quantity >= maximum):
                    if quantity == 1:
                        building["built"] = True
                    else:
                        building["limitreached"] = True
                    
                elif not row[19]:
        
                    building["buildings_required"] = True
        
                else:
                    notenoughspace = False
                    notenoughresources = False
        
                    if row[8] > self.pFloor:
                        building["not_enough_floor"] = True
                        notenoughspace = True
                        
                    if row[9] > self.pSpace:
                        building["not_enough_space"] = True
                        notenoughspace = True
                        
                    if row[2] > 0 and row[2] > self.userInfo["prestige_points"]:
                        building["not_enough_prestige"] = True
                        notenoughresources = True
                        
                    if row[3] > 0 and row[3] > self.pOre:
                        building["not_enough_ore"] = True
                        notenoughresources = True
                        
                    if row[4] > 0 and row[4] > self.phydro:
                        building["not_enough_hydro"] = True
                        notenoughresources = True
                    
                    if row[5] > 0 and row[5] > self.pEnergy:
                        building["not_enough_energy"] = True
                        notenoughresources = True
                        
                    if row[7] > 0 and row[7] > self.pWorkers:
                        building["not_enough_workers"] = True
                        notenoughresources = True
                    
                    if notenoughspace: building["not_enough.space"] = True
                    if notenoughresources: building["not_enough.resources"] = True
        
                    if notenoughspace or notenoughresources:
                        building["not_enough"] = True
                    else:
                        building["build"] = True

                if (quantity > 0) and row[14]:
        
                    if row[20]:
                        building["nextdestroytime"] = row[20]
                        building["next_destruction_in"] = True
                        building["isdestroying"] = True
                    elif not self.HasEnoughWorkersToDestroy(BuildingId):
                        building["workers_required"] = True
                    elif self.HasBuildingThatDependsOn(BuildingId):
                        building["required"] = True
                    elif self.HasEnoughStorageAfterDestruction(BuildingId):
                        building["capacity"] = True
                    else:
                        building["destroy"] = True
                    
                else:
                    building["empty"] = True
                    
                building["index"] = index
                index = index + 1
        
                building["workers_for_maintenance"] = self.getBuildingMaintenanceWorkers(BuildingId)
                building["upkeep"] = row[21]
                building["upkeep_energy"] = row[22]
        
                category['buildings'].append(building)
    
        content.AssignValue("categories", categories)
    
        if self.request.session.get(sPrivilege) > 100: content.Parse("dev")
        if self.userId==1009: content.Parse("dev")
    
    def StartBuilding(self, BuildingId):
        row = dbRowRetry("SELECT user_planet_building_start(" + str(self.userId) + "," + str(self.currentPlanetId) + "," + str(BuildingId) + ", false)")
        
    def CancelBuilding(self, BuildingId):
        dbExecuteRetryNoRow("SELECT user_planet_building_cancel(" + str(self.userId) + "," + str(self.currentPlanetId) + "," + str(BuildingId) + ")")
    
    def DestroyBuilding(self, BuildingId):
        dbExecuteRetryNoRow("SELECT user_planet_building_destroy(" + str(self.userId) + "," + str(self.currentPlanetId) + "," + str(BuildingId) + ")")
