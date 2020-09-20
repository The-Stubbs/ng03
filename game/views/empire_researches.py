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

        dbRow("SELECT internal_profile_update_modifiers(" + str(self.userId) + ")")

        Action = request.GET.get("a","").lower()
        ResearchId = ToInt(request.GET.get("r"), 0)

        if ResearchId != 0:

            if Action == "research":
                self.StartResearch(ResearchId)
            elif Action == "cancel":
                self.CancelResearch(ResearchId)
            elif Action == "continue":
                dbExecute("UPDATE gm_profile_research_pendings SET looping=true WHERE userid=" + str(self.userId) + " AND researchid=" + str(ResearchId))
            elif Action == "stop":
                dbExecute("UPDATE gm_profile_research_pendings SET looping=false WHERE userid=" + str(self.userId) + " AND researchid=" + str(ResearchId))
                
        return self.ListResearches()

    def HasEnoughFunds(self, credits):
        return credits <= 0 or self.userInfo["credits"] >= credits

    # List all the available gm_profile_researches
    def ListResearches(self):

        # count number of gm_profile_researches pending
        row = dbRow("SELECT int4(count(1)) FROM gm_profile_research_pendings WHERE userid=" + str(self.userId) + " LIMIT 1")
        underResearchCount = row[0]

        # list things that can be researched
        query = "SELECT researchid, category, total_cost, total_time, level, levels, researchable, buildings_requirements_met, status," + \
                " (SELECT looping FROM gm_profile_research_pendings WHERE researchid = t.researchid AND userid=" + str(self.userId) + ") AS looping," + \
                " expiration_time IS NOT NULL" + \
                " FROM internal_profile_get_researches_status(" + str(self.userId) + ") AS t" + \
                " WHERE level > 0 OR (researchable AND planet_elements_requirements_met)"
        oRss = dbRow(query)
        
        content = self.loadTemplate("research")

        content.AssignValue("userid", self.userId)

        # number of items in category
        itemCount = 0
        
        lastCategory = -1
        
        categories = []
        for row in rows:
            CatId = row[1]

            if CatId != lastCategory:
                category = {'id':CatId, 'gm_profile_researches':[]}
                categories.append(category)
                lastCategory = CatId
                itemCount = 0
            
            research = {}
            category['gm_profile_researches'].append(research)
            
            itemCount = itemCount + 1

            research["id"] = row[0]
            research["name"] = getResearchLabel(row[0])
            research["credits"] = row[2]
            research["nextlevel"] = row[4]+1
            research["level"] = row[4]
            research["levels"] = row[5]
            research["description"] = getResearchDescription(row[0])

            status = row[8]

            # if status is not None: this research is under way
            if status:
                if status < 0: status = 0

                research["leveling"] = True

                research["remainingtime"] = status

                if row[9]:
                    research["auto"] = True
                else:
                    research["manual"] = True

                research["cost"] = True
                research["countdown"] = True
                research["researching"] = True
            else:

                if (row[4] < row[5] or row[10]):
                    research["time"] = row[3]
                    research["researchtime"] = True

                    if not row[6] or not row[7]:
                        research["notresearchable"] = True
                    elif underResearchCount > 0:
                        research["busy"] = True
                    elif not self.HasEnoughFunds(row[2]):
                        research["notenoughmoney"] = True
                    else:
                        research["research"] = True

                    research["cost"] = True
                else:
                    research["nocost"] = True
                    research["noresearchtime"] = True
                    research["complete"] = True

        content.AssignValue("categories", categories)
        
        self.FillHeaderCredits(content)

        return self.display(content)

    def StartResearch(self, ResearchId):
        dbRow("SELECT * FROM user_research_start(" + str(self.userId) + "," + str(ResearchId) + ", false)")

    def CancelResearch(self, ResearchId):
        dbRow("SELECT * FROM user_research_cancel(" + str(self.userId) + "," + str(ResearchId) + ")")
