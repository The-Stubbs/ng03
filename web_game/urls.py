# -*- coding: utf-8 -*-

from django.urls import path
from django.views.generic import TemplateView
from django.views.generic.base import RedirectView

from web_game.game import error_500

from web_game import connect

from web_game.game import alliance
from web_game.game import alliance_create
from web_game.game import alliance_invitations
from web_game.game import battle
from web_game.game import buildings
from web_game.game import commanders
from web_game.game import fleet
from web_game.game import fleet_trade
from web_game.game import fleets
from web_game.game import fleets_handler
from web_game.game import mails
from web_game.game import map
from web_game.game import market_buy
from web_game.game import market_sell
from web_game.game import orbit
from web_game.game import overview
from web_game.game import planet
from web_game.game import production
from web_game.game import reports
from web_game.game import research
from web_game.game import training
from web_game.game import shipyard
from web_game.game import start
from web_game.game import wait

from web_game.game import not_implemented



################################################################################
handler500 = 'error_500.View'
#-------------------------------------------------------------------------------
urlpatterns = [
	#---------------------------------------------------------------------------
	path('', RedirectView.as_view(url='/game/connect/')),
    path('connect/', connect.View.as_view()),
	#---------------------------------------------------------------------------
    path('alliance-create/', alliance_create.View.as_view()),
    path('alliance-invitations/', alliance_invitations.View.as_view()),
    path('alliance/', alliance.View.as_view()),
    path('battle/', battle.View.as_view()),
    path('buildings/', buildings.View.as_view()),
    path('chat/', not_implemented.View.as_view()),
    path('commanders/', commanders.View.as_view()),
    path('fleet-ships/', not_implemented.View.as_view()),
    path('fleet-split/', not_implemented.View.as_view()),
    path('fleet-trade/', fleet_trade.View.as_view()),
    path('fleet/', fleet.View.as_view()),
    path('fleets_handler/', fleets_handler.View.as_view()),
    path('fleets-orbiting/', not_implemented.View.as_view()),
    path('fleets-ships-stats/', not_implemented.View.as_view()),
    path('fleets-standby/', not_implemented.View.as_view()),
    path('fleets/', fleets.View.as_view()),
    path('help/', not_implemented.View.as_view()),
    path('mails/', mails.View.as_view()),
    path('map/', map.View.as_view()),
    path('market-buy/', market_buy.View.as_view()),
    path('market-sell/', market_sell.View.as_view()),
    path('mercenary-intelligence/', not_implemented.View.as_view()),
    path('nation/', not_implemented.View.as_view()),
    path('notes/', not_implemented.View.as_view()),
    path('orbit/', orbit.View.as_view()),
    path('options/', not_implemented.View.as_view()),
    path('overview/', overview.View.as_view()),
    path('planets/', not_implemented.View.as_view()),
    path('planet/', planet.View.as_view()),
    path('production/', production.View.as_view()),
    path('ranking-alliances/', not_implemented.View.as_view()),
    path('ranking-players/', not_implemented.View.as_view()),
    path('reports/', reports.View.as_view()),
    path('research/', research.View.as_view()),
    path('shipyard/', shipyard.View.as_view()),
    path('start/', start.View.as_view()),
    path('training/', training.View.as_view()),
    path('upkeep/', not_implemented.View.as_view()),
    path('wait/', wait.View.as_view()),
	#---------------------------------------------------------------------------
]
################################################################################
