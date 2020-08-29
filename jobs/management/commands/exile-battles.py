# -*- coding: utf_8 -*-

from django.core.management.base import BaseCommand

from web_game.lib.sql import *

class Command(BaseCommand):

    def handle(self, *args, **options):
        connectDB()
        oRss = oConnExecuteAll("SELECT id, COALESCE(sp_get_user(ownerid), ''), galaxy, sector, planet FROM nav_planet WHERE next_battle <= now() LIMIT 25;")
        if oRss:
            for oRs in oRss:
                self.ResolveBattle(oRs)
    
    def ResolveBattle(self, row):
        pass