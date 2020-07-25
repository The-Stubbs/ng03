# -*- coding: utf_8 -*-

import time, datetime
from datetime import timedelta

from django.db import connection
from django.core.management.base import BaseCommand
from django.utils import timezone



################################################################################
class Command(BaseCommand):

    #---------------------------------------------------------------------------
    def handle(self, *args, **options):
        #-----------------------------------------------------------------------
        with connection.cursor() as cursor:
            start = timezone.now()
            while timezone.now() - start < timedelta(seconds=59):
                cursor.execute('SELECT admin_execute_processes()')
                time.sleep(0.5)
        #-----------------------------------------------------------------------

################################################################################
