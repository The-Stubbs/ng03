# -*- coding: utf_8 -*-

import time

from django.core.management.base import BaseCommand
from django.utils import timezone

from web_game.lib.sql import *

class Command(BaseCommand):

    def handle(self, *args, **options):
        h = timezone.now().hour
        connectDB()
        oRss = oConnExecuteAll("SELECT id FROM gm_profiles WHERE privilege >= 0 AND planets > 0 AND credits_bankruptcy > 0 AND lastlogin IS NOT NULL ORDER BY id")
        if oRss:
            for oRs in oRss:
                oConnExecute("SELECT internal_profile_update_data(" + str(oRs[0]) + "," + str(h) + ");")
                time.sleep(20)
