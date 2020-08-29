# -*- coding: utf-8 -*-

from django.urls import path
from django.views.generic.base import RedirectView

from web_game import connect

from web_game.game import buildings
from web_game.game import fleet
from web_game.game import fleet_trade
from web_game.game import map
from web_game.game import orbit
from web_game.game import overview
from web_game.game import planet
from web_game.game import production
from web_game.game import reports
from web_game.game import research
from web_game.game import training
from web_game.game import shipyard



################################################################################
urlpatterns = [
	#---------------------------------------------------------------------------
	path('', RedirectView.as_view(url='/game/connect/')),
    path('connect/', connect.View.as_view()),
	#---------------------------------------------------------------------------
    path('buildings/', buildings.View.as_view()),
    path('fleet-trade/', fleet_trade.View.as_view()),
    path('fleet/', fleet.View.as_view()),
    path('map/', map.View.as_view()),
    path('orbit/', orbit.View.as_view()),
    path('overview/', overview.View.as_view()),
    path('planet/', planet.View.as_view()),
    path('production/', production.View.as_view()),
    path('reports/', reports.View.as_view()),
    path('research/', research.View.as_view()),
    path('training/', training.View.as_view()),
    path('shipyard/', shipyard.View.as_view()),
	#---------------------------------------------------------------------------
]
################################################################################
