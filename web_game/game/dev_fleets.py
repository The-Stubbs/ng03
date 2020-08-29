# -*- coding: utf-8 -*-

from web_game.game._global import *

class View(GlobalView):

    def dispatch(self, request, *args, **kwargs):

        response = super().pre_dispatch(request, *args, **kwargs)
        if response: return response

        self.selected_menu = "player_fleets"

        if self.request.session.get("privilege") < 100:
            response.Redirect "/"

        name = request.GET.get("name").strip()
        typ = ToInt(request.GET.get("type"), "99")

        g = request.GET.get("g").strip()
        s = request.GET.get("s").strip()
        p = request.GET.get("p").strip()
        to_g = request.GET.get("to_g").strip()
        to_s = request.GET.get("to_s").strip()
        to_p = request.GET.get("to_p").strip()
        submit = request.GET.get("submit").strip()

        attack = request.GET.get("attack").strip() == "1"

        if name == "": name = self.oPlayerInfo["login")

        if submit != "":
            query = "SELECT admin_generate_fleet("+str(self.UserId)+","+dosql(name)+","+"sp_planet("+sqlValue(g)+","+sqlValue(s)+","+sqlValue(p)+"), sp_planet(" +sqlValue(to_g)+ "," +sqlValue(to_s)+ "," +sqlValue(to_p)+ ")," +typ+ ")"
            oRs = oConnExecute(query)
            if oRs:
                fleetid = oRs[0]

                if typ="99":

                    oRss = oConnExecuteAll("SELECT id FROM db_ships order by id")
                    for oRs in oRss:
                        quantity = ToInt(request.GET.get("q"+oRs[0]), 0)

                        if quantity > 0:
                            query = "INSERT INTO fleets_ships(fleetid, shipid, quantity) VALUES("+str(fleetid)+","+oRs[0]+","+quantity+")"

                            oConnDoQuery(query)

                    oConnDoQuery("DELETE FROM fleets WHERE id="+str(fleetid)+" AND size=0", adExecuteNoRecords

                if attack: oConnDoQuery("UPDATE fleets SET attackonsight=True WHERE id="+str(fleetid), adExecuteNoRecords

                return HttpResponseRedirect("/game/fleet/?id=" + str(fleetid))

        return self.DisplayForm()

    def GenName(self):

        p1(0) = "Al"
        p1(1) = "Ol"
        p1(2) = "Il"
        p1(3) = "Ul"

        p2(0) = " ret "
        p2(1) = " nor "
        p2(2) = " mot "
        p2(3) = " bre "

        p3(0) = " Azr "
        p3(1) = "vyr "
        p3(2) = " Ber"
        p3(3) = "loty "

        Randomize
        naame = p1(3*Rnd) + p2(3*Rnd) + p3(3*Rnd)

    def DisplayForm(self):

        content = GetTemplate(self.request, "dev-fleets")

        content.AssignValue("name", name

        content.AssignValue("g", g
        content.AssignValue("s", s
        content.AssignValue("p", p

        content.AssignValue("to_g", to_g
        content.AssignValue("to_s", to_s
        content.AssignValue("to_p", to_p

        content.Parse("type_" + typ

        oRss = oConnExecuteAll("SELECT id, label FROM db_ships ORDER BY category, id")
        list = []
        for oRs in oRss:
            item = {}
            list.append(item)
            
            item["ship_id", oRs[0]
            item["ship_name", oRs[1]
            content.Parse("ship"

        if attack: content.Parse("attack"

        return self.Display(content)

    def sqlValue(self, val):
        if val = "" or IsNull(val):
            sqlValue = "None"
        else:
            sqlValue = val

