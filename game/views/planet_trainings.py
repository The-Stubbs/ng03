# -*- coding: utf-8 -*-

from game.views._base import *

#-------------------------------------------------------------------------------
class View(BaseView):

    def dispatch(self, request, *args, **kwargs):

        response = super().pre_dispatch(request, *args, **kwargs)
        if response: return response

        self.selected_menu = "training"

        self.showHeader = True

        self.train_error = 0

        Action = request.GET.get("a", "").lower()
        trainScientists = ToInt(request.POST.get("scientists"),0)
        trainSoldiers = ToInt(request.POST.get("soldiers"),0)
        queueId = ToInt(request.GET.get("q"),0)

        if Action == "train":
            self.Train(trainScientists, trainSoldiers)
        elif Action == "cancel":
            self.CancelTraining(queueId)

        return self.DisplayTraining()

    def DisplayTraining(self):

        content = self.loadTemplate("training")

        content.AssignValue("planetid", str(self.currentPlanetId))

        query = "SELECT scientist_ore, scientist_hydrocarbon, scientist_credits," + \
                " soldier_ore, soldier_hydrocarbon, soldier_credits" + \
                " FROM internal_profile_get_training_price(" + str(self.userId) + ")"
        row = dbRow(query)

        if row:
            content.AssignValue("scientist_ore", row[0])
            content.AssignValue("scientist_hydrocarbon", row[1])
            content.AssignValue("scientist_credits", row[2])
            content.AssignValue("soldier_ore", row[3])
            content.AssignValue("soldier_hydrocarbon", row[4])
            content.AssignValue("soldier_credits", row[5])

        query = "SELECT scientists, scientists_capacity, soldiers, soldiers_capacity, workers FROM vw_gm_planets WHERE id="+str(self.currentPlanetId)
        row = dbRow(query)

        if row:
            content.AssignValue("scientists", row[0])
            content.AssignValue("scientists_capacity", row[1])

            content.AssignValue("soldiers", row[2])
            content.AssignValue("soldiers_capacity", row[3])
            if row[2]*250 < row[0]+row[4]: content.Parse("not_enough_soldiers")

            if row[0] < row[1]:
                content.Parse("input_scientists")
            else:
                content.Parse("max_scientists")

            if row[2] < row[3]:
                content.Parse("input_soldiers")
            else:
                content.Parse("max_soldiers")

        if self.train_error != 0:
            if self.train_error == 5: content.Parse("cant_train_now")
            else: content.Parse("not_enough_workers")

            content.Parse("error")

        # training in process
        query = "SELECT id, scientists, soldiers, int4(date_part('epoch', end_time-now()))" + \
                " FROM gm_planet_trainings WHERE planetid="+str(self.currentPlanetId)+" AND end_time IS NOT NULL" + \
                " ORDER BY start_time"
        oRss = dbRows(query)

        i = 0
        list = []
        content.AssignValue("trainings", list)
        for row in oRss:
            item = {}
            list.append(item)
            
            item["queueid"] = row[0]
            item["remainingtime"] = row[3]

            if row[1] > 0:
                item["quantity"] = row[1]
                item["scientists"] = True

            if row[2] > 0:
                item["quantity"] = row[2]
                item["soldiers"] = True

            i = i + 1

        # queue
        query = "SELECT gm_planet_trainings.id, gm_planet_trainings.scientists, gm_planet_trainings.soldiers," + \
                "    int4(ceiling(1.0*gm_planet_trainings.scientists/GREATEST(1, training_scientists)) * date_part('epoch', INTERVAL '1 hour'))," + \
                "    int4(ceiling(1.0*gm_planet_trainings.soldiers/GREATEST(1, training_soldiers)) * date_part('epoch', INTERVAL '1 hour'))" + \
                " FROM gm_planet_trainings" + \
                "    JOIN gm_planets ON (gm_planets.id=gm_planet_trainings.planetid)" + \
                " WHERE planetid="+str(self.currentPlanetId)+" AND end_time IS NULL" + \
                " ORDER BY start_time"
        oRss = dbRows(query)

        i = 0
        list = []
        content.AssignValue("queues", list)
        for row in oRss:
            item = {}
            list.append(item)
            
            item["queueid"] = row[0]

            if row[1] > 0:
                item["quantity"] = row[1]
                item["remainingtime"] = row[3]
                item["scientists"] = True

            if row[2] > 0:
                item["quantity"] = row[2]
                item["remainingtime"] = row[4]
                item["soldiers"] = True

            i = i + 1

        return self.display(content)

    def Train(self, Scientists, Soldiers):

        row = dbRowRetry("SELECT * FROM user_planet_training_start(" + str(self.userId) + "," + str(self.currentPlanetId) + "," + str(Scientists) + "," + str(Soldiers) + ")")

        if row:
            self.train_error = row[0]
        else:
            self.train_error = 1

    def CancelTraining(self, queueId):
        dbExecuteRetryNoRow("SELECT * FROM user_planet_training_cancel(" + str(self.currentPlanetId) + ", " + str(queueId) + ")")
        return HttpResponseRedirect("?")

