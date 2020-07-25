# -*- coding: utf_8 -*-

import time, datetime
from datetime import timedelta

from django.db import connection
from django.core.management.base import BaseCommand
from django.utils import timezone

from misc.battle import *



################################################################################
class Command(BaseCommand):

    #---------------------------------------------------------------------------
    def handle(self, *args, **options):
        #-----------------------------------------------------------------------
        with connection.cursor() as cursor:
            start = timezone.now()
            while timezone.now() - start < timedelta(seconds=59):
                self.process_battles(cursor)
                time.sleep(0.5)
        #-----------------------------------------------------------------------

    #---------------------------------------------------------------------------
    def process_battles(self, cursor):
        pass
    #---------------------------------------------------------------------------
    
################################################################################
