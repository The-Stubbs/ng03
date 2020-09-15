# -*- coding: utf-8 -*-

from django.urls import path
from django.views.generic import TemplateView
from django.views.generic.base import RedirectView

'''
from game.views import error_500

from game.views import connect

from game.views import alliance
'''
from game.views import alliance_creation
'''
from game.views import alliance_invitations
from game.views import alliance_manage
from game.views import alliance_members
from game.views import alliance_naps
from game.views import alliance_reports
from game.views import alliance_tributes
from game.views import alliance_wallet
from game.views import alliance_wars
from game.views import battle
from game.views import battle_view
from game.views import buildings
from game.views import chats
from game.views import commanders
from game.views import fleet
from game.views import fleet_ships
from game.views import fleet_split
from game.views import fleet_trade
from game.views import fleets
from game.views.lib import fleets_handler
from game.views import fleets_orbiting
from game.views import fleets_ships_stats
from game.views import fleets_standby
from game.views import game_over
from game.views import help
from game.views import holidays
from game.views import invasion
from game.views import mails
from game.views import maintenance
from game.views import map
from game.views import market_buy
from game.views import market_sell
from game.views import mercenary_intelligence
from game.views import nation
from game.views import notes
from game.views import orbit
from game.views import options
from game.views import overview
from game.views import planets
from game.views import planet
from game.views import production
from game.views import ranking_alliances
from game.views import ranking_players
from game.views import reports
from game.views import research
from game.views import shipyard
from game.views import spy_report
from game.views import start
from game.views import training
from game.views import upkeep
from game.views import wait
'''


################################################################################
handler500 = 'error_500.View'
#-------------------------------------------------------------------------------
urlpatterns = [
	#---------------------------------------------------------------------------
	path('', RedirectView.as_view(url='/game/connect/')),
    #path('connect/', connect.View.as_view()),
	#---------------------------------------------------------------------------
    path('alliance-creation/', alliance_creation.View.as_view()),
]
################################################################################
