# -*- coding: utf-8 -*-

from game.views._base import *

#-------------------------------------------------------------------------------
class View(BaseView):

    def dispatch(self, request, *args, **kwargs):

        response = super().pre_dispatch(request, *args, **kwargs)
        if response: return response

        self.selected_menu = "production"

        self.showHeader = True

        return self.displayPage(True)

    def displayReceiveSendEnergy(self):

        query = "SELECT energy_receive_antennas, energy_send_antennas FROM gm_planets WHERE id=" + str(self.currentPlanetId)
        row = dbRow(query)

        max_receive = row[0]
        max_send = row[1]

        update_planet = False

        if self.action == "cancel":
            energy_from = ToInt(self.request.GET.get("from"), 0)
            energy_to = ToInt(self.request.GET.get("to"), 0)

            if energy_from != 0:
                query = "DELETE FROM gm_planet_energy_transfers WHERE planetid=" + str(energy_from) + " AND target_planetid=" + str(self.currentPlanetId)
            else:
                query = "DELETE FROM gm_planet_energy_transfers WHERE planetid=" + str(self.currentPlanetId) + " AND target_planetid=" + str(energy_to)

            dbExecute(query)

            update_planet = True

            return HttpResponseRedirect("/game/production/?cat=" + str(self.cat))

        elif self.action == "submit":

            query = "SELECT target_planetid, energy, enabled" + \
                    " FROM gm_planet_energy_transfers" + \
                    " WHERE planetid=" + str(self.currentPlanetId)
            rows = dbRows(query)
            list = []
            for row in rows:
                item = {}
                list.append(item)
                
                query = ""

                I = ToInt(self.request.POST.get("energy_" + str(row[0])), 0)
                if I != row[1]:
                    query = query + "energy = " + str(I)

                I = self.request.POST.get("enabled_" + str(row[0]))
                if I == "1":
                    I = True
                else:
                    I = False

                if I != row[2]:
                    if query != "": query = query + ","
                    query = query + "enabled=" + str(I)

                if query != "":
                    query = "UPDATE gm_planet_energy_transfers SET " + query + " WHERE planetid=" + str(self.currentPlanetId) + " AND target_planetid=" + str(row[0])
                    dbExecute(query)

                    update_planet = True

            g = ToInt(self.request.POST.get("to_g"), 0)
            s = ToInt(self.request.POST.get("to_s"), 0)
            p = ToInt(self.request.POST.get("to_p"), 0)
            energy = ToInt(self.request.POST.get("energy"), 0)

            if g != 0 and s != 0 and p != 0 and energy > 0:
                query = "INSERT INTO gm_planet_energy_transfers(planetid, target_planetid, energy) VALUES(" + str(self.currentPlanetId) + ", tool_compute_planet_id(" + str(g) + "," + str(s) + "," + str(p) + ")," + str(energy) + ")"
                dbExecute(query)

                update_planet = True

            if update_planet:
                query = "SELECT internal_planet_update_data(" + str(self.currentPlanetId) + ")"
                dbExecute(query)

            return HttpResponseRedirect("/game/production/?cat=" + str(self.cat))

        query = "SELECT t.planetid, internal_planet_get_name(" + str(self.userId) + ", n1.id), internal_profile_get_relation(n1.ownerid," + str(self.userId) + "), n1.galaxy, n1.sector, n1.planet, " + \
                "        t.target_planetid, internal_planet_get_name(" + str(self.userId) + ", n2.id), internal_profile_get_relation(n2.ownerid," + str(self.userId) + "), n2.galaxy, n2.sector, n2.planet, " + \
                "        t.energy, t.effective_energy, enabled" + \
                " FROM gm_planet_energy_transfers t" + \
                "    INNER JOIN gm_planets n1 ON (t.planetid=n1.id)" + \
                "    INNER JOIN gm_planets n2 ON (t.target_planetid=n2.id)" + \
                " WHERE planetid=" + str(self.currentPlanetId) + " OR target_planetid=" + str(self.currentPlanetId) + \
                " ORDER BY not enabled, planetid, target_planetid"
        rows = dbRows(query)

        receiving = 0
        sending = 0
        sending_enabled = 0

        sents = []
        self.content.AssignValue("sents", sents)
        receiveds = []
        self.content.AssignValue("receiveds", receiveds)
        for row in rows:
            item = {}
            
            item["energy"] = row[12]
            item["effective_energy"] = row[13]
            item["loss"] = self.getpercent(row[12]-row[13], row[12], 1)

            if row[0] == self.currentPlanetId:
                sending = sending + 1
                if row[14]: sending_enabled = sending_enabled + 1
                item["planetid"] = row[6]
                item["name"] = row[7]
                item["rel"] = row[8]
                item["g"] = row[9]
                item["s"] = row[10]
                item["p"] = row[11]
                if row[14]: item["enabled"] = True
                sents.append(item)
            elif row[14]: # if receiving and enabled, display it
                receiving = receiving + 1
                item["planetid"] = row[0]
                item["name"] = row[1]
                item["rel"] = row[2]
                item["g"] = row[3]
                item["s"] = row[4]
                item["p"] = row[5]
                receiveds.append(item)

        self.content.AssignValue("planetid","")
        self.content.AssignValue("name","")
        self.content.AssignValue("rel","")
        self.content.AssignValue("g","")
        self.content.AssignValue("s","")
        self.content.AssignValue("p","")
        self.content.AssignValue("energy", 0)
        self.content.AssignValue("effective_energy", 0)
        self.content.AssignValue("loss", 0)

        self.content.AssignValue("antennas_receive_used", receiving)
        self.content.AssignValue("antennas_receive_total", max_receive)

        self.content.AssignValue("antennas_send_used", sending_enabled)
        self.content.AssignValue("antennas_send_total", max_send)

        if max_send == 0: self.content.Parse("send_no_antenna")
        if max_receive == 0: self.content.Parse("receive_no_antenna")

        if receiving > 0:
            self.content.Parse("cant_send_when_receiving")
            max_send = 0

        if sending_enabled > 0:
            self.content.Parse("cant_receive_when_sending")
            max_receive = 0
        elif receiving == 0 and max_receive > 0:
            self.content.Parse("receiving_none")

        if max_receive > 0: self.content.Parse("receive")
        if max_send - len(sents) > 0: self.content.Parse("send")
        if max_send > 0: self.content.Parse("submit")

        self.content.Parse("sendreceive")
