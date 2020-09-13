# -*- coding: utf-8 -*-

from django.urls import path
from django.views.generic import TemplateView
from django.views.generic.base import RedirectView

from game.views import error_500

from game.views import connection

from game.views import alliance
from game.views import alliance_creation
from game.views import alliance_invitations
from game.views import alliance_management
from game.views import alliance_members
from game.views import alliance_naps
from game.views import alliance_reports
from game.views import alliance_tributes
from game.views import alliance_wallet
from game.views import alliance_wars
from game.views import battle
from game.views import chats
from game.views import commanders
from game.views import empire_orbitting
from game.views import empire_overview
from game.views import empire_planets
from game.views import empire_standby
from game.views import empire_upkeep
from game.views import fleet
from game.views import fleet_ships
from game.views import fleet_split
from game.views import fleet_trade
from game.views import help
from game.views import home_gameover
from game.views import home_holidays
from game.views import home_maintenance
from game.views import home_starting
from game.views import home_waiting
from game.views import mails
from game.views import map
from game.views import market_purchase
from game.views import market_sale
from game.views import mercenary
from game.views import planet
from game.views import planet_buildings
from game.views import planet_orbit
from game.views import planet_production
from game.views import planet_shipyard
from game.views import planet_trainings
from game.views import profile
from game.views import profile_fleetcategory
from game.views import profile_notes
from game.views import profile_options
from game.views import profile_reports
from game.views import profile_researches
from game.views import profile_shipstats
from game.views import ranking_alliances
from game.views import ranking_players
from game.views import report_battle
from game.views import report_invasion
from game.views import report_spying



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
    path('alliance-manage/', alliance_manage.View.as_view()),
    path('alliance-members/', alliance_members.View.as_view()),
    path('alliance-naps/', alliance_naps.View.as_view()),
    path('alliance-reports/', alliance_reports.View.as_view()),
    path('alliance-tributes/', alliance_tributes.View.as_view()),
    path('alliance-wallet/', alliance_wallet.View.as_view()),
    path('alliance-wars/', alliance_wars.View.as_view()),
    path('alliance/', alliance.View.as_view()),
    path('battle-view/', battle_view.View.as_view()),
    path('battle/', battle.View.as_view()),
    path('buildings/', buildings.View.as_view()),
    path('chats/', chats.View.as_view()),
    path('commanders/', commanders.View.as_view()),
    path('fleet-ships/', fleet_ships.View.as_view()),
    path('fleet-split/', fleet_split.View.as_view()),
    path('fleet-trade/', fleet_trade.View.as_view()),
    path('fleet/', fleet.View.as_view()),
    path('fleets_handler/', fleets_handler.View.as_view()),
    path('fleets-orbiting/', fleets_orbiting.View.as_view()),
    path('fleets-ships-stats/', fleets_ships_stats.View.as_view()),
    path('fleets-standby/', fleets_standby.View.as_view()),
    path('fleets/', gm_fleets.View.as_view()),
    path('game-over/', game_over.View.as_view()),
    path('help/', help.View.as_view()),
    path('holidays/', holidays.View.as_view()),
    path('invasion/', invasion.View.as_view()),
    path('mails/', mails.View.as_view()),
    path('maintenance/', maintenance.View.as_view()),
    path('map/', map.View.as_view()),
    path('market-buy/', market_buy.View.as_view()),
    path('market-sell/', market_sell.View.as_view()),
    path('mercenary-intelligence/', mercenary_intelligence.View.as_view()),
    path('nation/', nation.View.as_view()),
    path('notes/', notes.View.as_view()),
    path('orbit/', orbit.View.as_view()),
    path('options/', options.View.as_view()),
    path('overview/', overview.View.as_view()),
    path('planets/', planets.View.as_view()),
    path('planet/', planet.View.as_view()),
    path('production/', production.View.as_view()),
    path('ranking-gm_alliances/', ranking_alliances.View.as_view()),
    path('ranking-players/', ranking_players.View.as_view()),
    path('profile_reports/', gm_profile_reports.View.as_view()),
    path('research/', research.View.as_view()),
    path('shipyard/', shipyard.View.as_view()),
    path('spyings-report/', spy_report.View.as_view()),
    path('start/', start.View.as_view()),
    path('training/', training.View.as_view()),
    path('upkeep/', upkeep.View.as_view()),
    path('wait/', wait.View.as_view()),
	#---------------------------------------------------------------------------
]
################################################################################
