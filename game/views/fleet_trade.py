# -*- coding: utf-8 -*-

from game.views._base import *

#-------------------------------------------------------------------------------
class View(BaseView):
    
    def dispatch(self, request, *args, **kwargs):

        response = super().pre_dispatch(request, *args, **kwargs)
        if response: return response
        
        self.selected_menu = "gm_fleets"
        
        self.can_command_alliance_fleets = -1
        
        if self.allianceId and self.hasRight("can_order_other_fleets"):
            self.can_command_alliance_fleets = self.allianceId
        
        self.fleet_owner_id = self.userId
        
        self.fleetid = ToInt(self.request.GET.get("id"), 0)
        
        if self.fleetid == 0:
            return HttpResponseRedirect("/game/gm_fleets/")
        
        self.RetrieveFleetOwnerId(self.fleetid)
        
        self.TransferResourcesViaPost(self.fleetid)
        
        if self.request.GET.get("a") != "open":
            return HttpResponseRedirect("/game/fleet/?id=" + str(self.fleetid))
        
        self.TransferResources(self.fleetid)
        
        return self.DisplayExchangeForm(self.fleetid)
    
    def RetrieveFleetOwnerId(self, fleetid):
    
        # retrieve fleet owner
        query = "SELECT ownerid" + \
                " FROM vw_gm_fleets as f" + \
                " WHERE (ownerid=" + str(self.userId) + " OR (shared AND owner_alliance_id=" + str(self.can_command_alliance_fleets) + ")) AND id=" + str(self.fleetid)
        row = dbRow(query)
    
        self.fleet_owner_id = row[0]
    
    # display fleet info
    def DisplayExchangeForm(self, fleetid):
        content = self.loadTemplate("fleet-trade")
    
        # retrieve fleet name, size, position, destination
        query = "SELECT id, name, attackonsight, engaged, size, signature, speed, remaining_time, commanderid, commandername," + \
                " planetid, planet_name, planet_galaxy, planet_sector, planet_planet, planet_ownerid, planet_owner_name, planet_owner_relation," + \
                " cargo_capacity, cargo_ore, cargo_hydrocarbon, cargo_scientists, cargo_soldiers, cargo_workers" + \
                " FROM vw_gm_fleets" + \
                " WHERE ownerid=" + str(self.fleet_owner_id) + " AND id="+str(self.fleetid)
        row = dbRow(query)
    
        # if fleet doesn't exist, redirect to the list of gm_fleets
        if row == None:
            if self.request.GET.get("a") == "open":
                return HttpResponseRedirect("/game/gm_fleets/")
            else:
                return HttpResponseRedirect("/game/gm_fleets/")
    
        relation = row[17]
    
        # if fleet is moving or engaged, go back to the gm_fleets
        if row[7] or row[3]:
            if self.request.GET.get("a") == "open":
                relation = rWar
            else:
                return HttpResponseRedirect("/game/fleet/?id=" + str(self.fleetid))
            
        content.AssignValue("fleetid", self.fleetid)
        content.AssignValue("fleetname", row[1])
        content.AssignValue("size", row[4])
        content.AssignValue("speed", row[6])
    
        content.AssignValue("fleet_capacity", row[18])
        content.AssignValue("fleet_ore", row[19])
        content.AssignValue("fleet_hydrocarbon", row[20])
        content.AssignValue("fleet_scientists", row[21])
        content.AssignValue("fleet_soldiers", row[22])
        content.AssignValue("fleet_workers", row[23])
    
        content.AssignValue("fleet_load", row[19] + row[20] + row[21] + row[22] + row[23])
    
        if relation == rSelf:
            # retrieve planet ore, hydrocarbon, workers, relation
            query = "SELECT ore, hydrocarbon, scientists, soldiers," + \
                    " GREATEST(0, workers-GREATEST(workers_busy,workers_for_maintenance-workers_for_maintenance/2+1,500))," + \
                    " workers > workers_for_maintenance/2" + \
                    " FROM vw_gm_planets WHERE id="+str(row[10])
            row = dbRow(query)

            content.AssignValue("planet_ore", row[0])
            content.AssignValue("planet_hydrocarbon", row[1])
            content.AssignValue("planet_scientists", row[2])
            content.AssignValue("planet_soldiers", row[3])
            content.AssignValue("planet_workers", row[4])

            if not row[5]:
                content.AssignValue("planet_ore", 0)
                content.AssignValue("planet_hydrocarbon", 0)
                content.Parse("not_enough_workers_to_load")

            content.Parse("load")
        elif relation in [rFriend, rAlliance, rHostile]:

            content.Parse("unload")
        else:
            content.Parse("cargo")
    
        return self.display(content)
    
    def TransferResources(self, fleetid):
    
        ore = ToInt(self.request.GET.get("load_ore"), 0) - ToInt(self.request.GET.get("unload_ore"), 0)
        hydrocarbon = ToInt(self.request.GET.get("load_hydrocarbon"), 0) - ToInt(self.request.GET.get("unload_hydrocarbon"), 0)
        scientists = ToInt(self.request.GET.get("load_scientists"), 0) - ToInt(self.request.GET.get("unload_scientists"), 0)
        soldiers = ToInt(self.request.GET.get("load_soldiers"), 0) - ToInt(self.request.GET.get("unload_soldiers"), 0)
        workers = ToInt(self.request.GET.get("load_workers"), 0) - ToInt(self.request.GET.get("unload_workers"), 0)
    
        if ore != 0 or hydrocarbon != 0 or scientists != 0 or soldiers != 0 or workers != 0:
            row = dbRow("SELECT user_fleet_transfer_resources(" + str(self.fleet_owner_id) + "," + str(self.fleetid) + "," + str(ore) + "," + str(hydrocarbon) + "," + str(scientists) + "," + str(soldiers) + "," + str(workers) + ")")
    
    def TransferResourcesViaPost(self, fleetid):
    
        ore = ToInt(self.request.POST.get("load_ore"), 0) - ToInt(self.request.POST.get("unload_ore"), 0)
        hydrocarbon = ToInt(self.request.POST.get("load_hydrocarbon"), 0) - ToInt(self.request.POST.get("unload_hydrocarbon"), 0)
        scientists = ToInt(self.request.POST.get("load_scientists"), 0) - ToInt(self.request.POST.get("unload_scientists"), 0)
        soldiers = ToInt(self.request.POST.get("load_soldiers"), 0) - ToInt(self.request.POST.get("unload_soldiers"), 0)
        workers = ToInt(self.request.POST.get("load_workers"), 0) - ToInt(self.request.POST.get("unload_workers"), 0)
    
        if ore != 0 or hydrocarbon != 0 or scientists != 0 or soldiers != 0 or workers != 0:
            row = dbRow("SELECT user_fleet_transfer_resources(" + str(self.fleet_owner_id) + "," + str(self.fleetid) + "," + str(ore) + "," + str(hydrocarbon) + "," + str(scientists) + "," + str(soldiers) + "," + str(workers) + ")")
            return HttpResponseRedirect("/game/fleet/?id=" + str(self.fleetid) + "+trade=" + str(row[0]))
