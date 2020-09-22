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
        
        dbExecute("SELECT internal_profile_update_modifiers(" + str(self.userId) + ")")
        
        return super().dispatch(request, *args, **kwargs)

    #---------------------------------------------------------------------------
    def processAction(self, request, action):

        if action == "research":
        
            id = ToInt(request.POST.get("id"), 0)
            
            row = dbRow("SELECT * FROM user_research_start(" + str(self.userId) + "," + str(id) + ", false)")
            return row[0]
            
        elif action == "cancel":
        
            id = ToInt(request.POST.get("id"), 0)
            
            row = dbRow("SELECT * FROM user_research_cancel(" + str(self.userId) + "," + str(id) + ")")
            return row[0]
            
        elif action == "continue":
        
            id = ToInt(request.POST.get("id"), 0)
            
            dbExecute("UPDATE gm_profile_research_pendings SET looping=true WHERE userid=" + str(self.userId) + " AND researchid=" + str(id))
            return 0
            
        elif action == "stop":
        
            id = ToInt(request.POST.get("id"), 0)
            
            dbExecute("UPDATE gm_profile_research_pendings SET looping=false WHERE userid=" + str(self.userId) + " AND researchid=" + str(id))
            return 0

    #---------------------------------------------------------------------------
    def fillContent(self, request, data):

        # --- research pending data
        
        row = dbRow("SELECT int4(count(1)) FROM gm_profile_research_pendings WHERE userid=" + str(self.userId) + " LIMIT 1")
        underResearchCount = row[0]

        # --- research data
        
        data["categories"] = []
        
        query = "SELECT researchid, category, total_cost, total_time, level, levels, researchable, buildings_requirements_met, status," + \
                " (SELECT looping FROM gm_profile_research_pendings WHERE researchid = t.researchid AND userid=" + str(self.userId) + ") AS looping," + \
                " expiration_time IS NOT NULL" + \
                " FROM internal_profile_get_researches_status(" + str(self.userId) + ") AS t" + \
                " WHERE level > 0 OR (researchable AND planet_elements_requirements_met)"
        rows = dbRows(query)
        if rows:
            lastcategory = -1
            for row in rows:

                if row[1] != lastcategory:
                
                    category = { 'id':row[1], 'researches':[] }
                    data["categories"].append(category)
                    
                    lastcategory = row[1]
                
                research = {}
                category['researches'].append(research)

                research["id"] = row[0]
                research["name"] = getResearchLabel(row[0])
                research["credits"] = row[2]
                research["nextlevel"] = row[4] + 1
                research["level"] = row[4]
                research["levels"] = row[5]
                research["description"] = getResearchDescription(row[0])
                research["mode"] = row[9]

                status = row[8]
                if status:
                
                    if status < 0: status = 0

                    research["leveling"] = True
                    research["remainingtime"] = status
                    research["cost"] = True
                    research["countdown"] = True
                    research["researching"] = True
                    
                else:

                    if row[4] < row[5] or row[10]:
                    
                        research["time"] = row[3]
                        research["researchtime"] = True

                        if not row[6] or not row[7]: research["notresearchable"] = True
                        elif underResearchCount > 0: research["busy"] = True
                        elif not (credits <= 0 or self.userInfo["credits"] >= row[2]): research["notenoughmoney"] = True
                        else: research["research"] = True

                        research["cost"] = True
                        
                    else:
                    
                        research["nocost"] = True
                        research["noresearchtime"] = True
                        research["complete"] = True
