# -*- coding: utf-8 -*-

from game.views._base import *

#-------------------------------------------------------------------------------
class View(RestView):

    #---------------------------------------------------------------------------
    def processAction(self, request, action):
        
        if action == "setcat":
            
            id = ToInt(request.POST.get("id"), 0)
            old = ToInt(request.POST.get("old"), 0)
            new = ToInt(request.POST.get("new"), 0)

            row = dbRow("SELECT user_fleet_category_assign(" + str(self.userId) + "," + str(id) + "," + str(old) + "," + str(new) + ")")
            if row and row[0]:
                
                data = {}

                data["id"] = id
                data["old"] = old
                data["new"] = new
                
                data["fleet_category_changed"] = True

                return render(request, "empire-fleets-rest.html", data)

        elif action == "newcat":
            
            name = request.POST.get("name","").strip()

            data = {}

            if self.isValidCategoryName(name):
                
                row = dbRow("SELECT user_fleet_category_create(" + str(self.userId) + "," + sqlStr(name) + ")")
                if row:
                
                    data["id"] = row[0]
                    data["label"] = name
                    data["category"] = True

            else: data["category_name_invalid"] = True

            return render(request, "empire-fleets-rest.html", data)
        
        elif action == "rencat":
            
            id = ToInt(request.POST.get("id"), 0)
            name = request.POST.get("name","").strip()

            data = {}

            if name == "":
            
                row = dbRow("SELECT user_fleet_category_delete(" + str(self.userId) + "," + str(id) + ")")
                if row:
                
                    data["id"] = id
                    data["label"] = name
                    data["category"] = True

            elif self.isValidCategoryName(name):
            
                row = dbRow("SELECT user_fleet_category_rename(" + str(self.userId) + "," + str(id) + "," + sqlStr(name) + ")")
                if row:
                
                    data["id"] = id
                    data["label"] = name
                    data["category"] = True

            else: data["category_name_invalid"] = True

            return render(request, "empire-fleets-rest.html", data)
