# -*- coding: utf-8 -*-

from web_game.game._global import *

class View(GlobalView):

    def dispatch(self, request, *args, **kwargs):

        response = super().pre_dispatch(request, *args, **kwargs)
        if response: return response

        <!--#include virtual="/lib/exile.asp"-->
        <!--#include virtual="/lib/template.asp"-->
        from web_game.lib.accounts import *

        <script language="JScript" runat="server">
        def process() {
            if(!registration.enabled || (registration.until != None ++ new Date().getTime() > registration.until.getTime())) {
                var content = GetTemplate(self.request, "start-closed");
                content.Parse("");
                Response.write(content.Output());
                ();
            }

            var result = 0;

            var userId = Number(Session("user"));
            var galaxy = Number(request.POST.get('galaxy').item);
            if(isNaN(galaxy)) galaxy = 0;

            if(isNaN(userId)) {
                Response.redirect("/");
                ();
            }

            // check if it is the first login of the player
            var rs = oConnExecute("SELECT login FROM users WHERE resets=0 AND id=" + userId);
            if(rs.EOF) {
                Response.redirect("/");
                ();
            }

            var userName = rs(0).value;

            if(userName == None) {
                var newName = toStr(request.POST.get('name').item);
                if(newName != "") {
                    // try to rename user and catch any error
                    try {
                        if(isValidName(newName)) {
                            oConnDoQuery("UPDATE users SET login=" + dosql(newName) + " WHERE id=" + userId)
                            userName = newName;
                        }
                        else:
                            result = 11;
                    } catch(e) {
                        result = 10;
                    }
                }
            }

            if(result == 0) {
                var orientation = Number(request.POST.get("orientation").item);
                var allowed = False;

                for(var i = 0; i < allowedOrientations.length; i++)
                    if(allowedOrientations[i] == orientation) {
                        allowed = True;
                        break;
                    }

                if(allowed) {
                    oConn.BeginTrans();

                    oConnDoQuery("UPDATE users SET orientation=" + orientation + " WHERE id=" + userId)

                    var rs = oConnExecute("SELECT sp_reset_account(" + str(self.UserId) + "," + galaxy + ")");
                    result = rs(0).value;

                    try {
                        if(result != 0)
                            throw 0;

                        if orientation == 1:    # merchant
                            oConnDoQuery("INSERT INTO researches(userid, researchid, level) VALUES(" + str(self.UserId) + ",10,1)")
                            oConnDoQuery("INSERT INTO researches(userid, researchid, level) VALUES(" + str(self.UserId) + ",11,1)")
                            oConnDoQuery("INSERT INTO researches(userid, researchid, level) VALUES(" + str(self.UserId) + ",12,1)")

                        elif orientation == 2:    # military
                            oConnDoQuery("INSERT INTO researches(userid, researchid, level) VALUES(" + str(self.UserId) + ",20,1)")
                            oConnDoQuery("INSERT INTO researches(userid, researchid, level) VALUES(" + str(self.UserId) + ",21,1)")
                            oConnDoQuery("INSERT INTO researches(userid, researchid, level) VALUES(" + str(self.UserId) + ",22,1)")

                        elif orientation == 3:    # scientist
                            oConnDoQuery("INSERT INTO researches(userid, researchid, level) VALUES(" + str(self.UserId) + ",30,1)")
                            oConnDoQuery("INSERT INTO researches(userid, researchid, level) VALUES(" + str(self.UserId) + ",31,1)")
                            oConnDoQuery("INSERT INTO researches(userid, researchid, level) VALUES(" + str(self.UserId) + ",32,1)")

                        elif orientation == 4:    # war lord
                            oConnDoQuery("INSERT INTO researches(userid, researchid, level) VALUES(" + str(self.UserId) + ",40,1)")
                            oConnDoQuery("INSERT INTO researches(userid, researchid, level) VALUES(" + str(self.UserId) + ",12,1)")
                            oConnDoQuery("INSERT INTO researches(userid, researchid, level) VALUES(" + str(self.UserId) + ",32,1)")

                        oConnExecute("SELECT sp_update_researches(" + str(self.UserId) + ")")

                        oConn.CommitTrans();

                        Response.redirect("/game/overview.asp");
                        ();
                    } catch(e) {
                        oConn.RollbackTrans();
                    }
                }
            }

            // display start page
            var content = GetTemplate(self.request, "start");
            content.AssignValue("login", userName);

            for(var i = 0; i < allowedOrientations.length; i++)
                content.Parse("orientation_" + allowedOrientations[i]);

            var rs = oConnExecute("SELECT id, recommended FROM sp_get_galaxy_info(" + str(self.UserId) + ")");

            while(!rs.EOF) {
                content.AssignValue("id", rs(0).value);
                content.AssignValue("recommendation", rs(1).value);
                content.Parse("galaxies.galaxy");
                rs.MoveNext();
            }

            content.Parse("galaxies");

            if(result != 0)
                content.Parse("error_" + result);

            content.Parse("");

            Response.write(content.Output());
        }
        </script>

        process

