# -*- coding: utf-8 -*-

from django.urls import path
from django.views.generic.base import RedirectView

from .views import closed
from .views import locked
from .views import gameover
from .views import holidays
from .views import maintenance
from .views import starting
from .views import welcome

from .views import rest_chat
from .views import rest_fleets

from .views import alliance_announce
from .views import alliance_creation
from .views import alliance_displaying
from .views import alliance_gifts
from .views import alliance_invitations
from .views import alliance_members
from .views import alliance_naps
from .views import alliance_overview
from .views import alliance_ranks
from .views import alliance_recruitment
from .views import alliance_reports
from .views import alliance_requests
from .views import alliance_tributes
from .views import alliance_wallet
from .views import alliance_wars

from .views import chat_creation
from .views import chat_messages
from .views import chat_overview

from .views import commander_overview
from .views import commander_skills

from .views import empire_stats
from .views import empire_fleets
from .views import empire_orbiting
from .views import empire_overview
from .views import empire_parking
from .views import empire_upkeep
from .views import empire_planets
from .views import empire_purchases
from .views import empire_researches
from .views import empire_sales

from .views import fleet_overview
from .views import fleet_ships
from .views import fleet_splitting

from .views import help_buildings
from .views import help_researches
from .views import help_resources
from .views import help_ships
from .views import help_bbcode

from .views import mail_blacklist
from .views import mail_creation
from .views import mail_inbox
from .views import mail_outbox

from .views import map_galaxy
from .views import map_sector
from .views import map_universe

from .views import mercenary_spying

from .views import planet_overview
from .views import planet_production
from .views import planet_working
from .views import planet_transfers
from .views import planet_buildings
from .views import planet_ships
from .views import planet_recycling
from .views import planet_trainings
from .views import planet_orbit
from .views import planet_purchases
from .views import planet_sales

from .views import profile_displaying
from .views import profile_overview
from .views import profile_reports
from .views import profile_notes
from .views import profile_options
from .views import profile_vacancy

from .views import ranking_alliances
from .views import ranking_players
from .views import ranking_searching

from .views import report_battle
from .views import report_invasion
from .views import report_spying



################################################################################
urlpatterns = [
	#---------------------------------------------------------------------------
	path('', RedirectView.as_view(url='/game/empire/overview/')),
	#---------------------------------------------------------------------------
    path('closed/', closed.View.as_view()),
    path('locked/', locked.View.as_view()),
    path('gameover/', gameover.View.as_view()),
    path('holidays/', holidays.View.as_view()),
    path('maintenance/', maintenance.View.as_view()),
    path('starting/', starting.View.as_view()),
    path('welcome/', welcome.View.as_view()),
	#---------------------------------------------------------------------------
    path('rest/chat/', rest_chat.View.as_view()),
    path('rest/fleets/', rest_fleets.View.as_view()),
	#---------------------------------------------------------------------------
    path('alliance/announce/', alliance_announce.View.as_view()),
    path('alliance/creation/', alliance_creation.View.as_view()),
    path('alliance/displaying/', alliance_displaying.View.as_view()),
    path('alliance/gifts/', alliance_gifts.View.as_view()),
    path('alliance/invitations/', alliance_invitations.View.as_view()),
    path('alliance/members/', alliance_members.View.as_view()),
    path('alliance/naps/', alliance_naps.View.as_view()),
    path('alliance/overview/', alliance_overview.View.as_view()),
    path('alliance/ranks/', alliance_ranks.View.as_view()),
    path('alliance/recruitment/', alliance_recruitment.View.as_view()),
    path('alliance/reports/', alliance_reports.View.as_view()),
    path('alliance/requests/', alliance_requests.View.as_view()),
    path('alliance/tributes/', alliance_tributes.View.as_view()),
    path('alliance/wallet/', alliance_wallet.View.as_view()),
    path('alliance/wars/', alliance_wars.View.as_view()),
	#---------------------------------------------------------------------------
    path('chat/creation/', chat_creation.View.as_view()),
    path('chat/messages/', chat_messages.View.as_view()),
    path('chat/overview/', chat_overview.View.as_view()),
	#---------------------------------------------------------------------------
    path('commander/overview/', commander_overview.View.as_view()),
    path('commander/skills/', commander_skills.View.as_view()),
	#---------------------------------------------------------------------------
    path('empire/stats/', empire_stats.View.as_view()),
    path('empire/fleets/', empire_fleets.View.as_view()),
    path('empire/orbiting/', empire_orbiting.View.as_view()),
    path('empire/overview/', empire_overview.View.as_view()),
    path('empire/parking/', empire_parking.View.as_view()),
    path('empire/upkeep/', empire_upkeep.View.as_view()),
    path('empire/planets/', empire_planets.View.as_view()),
    path('empire/purchases/', empire_purchases.View.as_view()),
    path('empire/researches/', empire_researches.View.as_view()),
    path('empire/sales/', empire_sales.View.as_view()),
	#---------------------------------------------------------------------------
    path('fleet/overview/', fleet_overview.View.as_view()),
    path('fleet/ships/', fleet_ships.View.as_view()),
    path('fleet/splitting/', fleet_splitting.View.as_view()),
	#---------------------------------------------------------------------------
    path('help/buildings/', help_buildings.View.as_view()),
    path('help/researches/', help_researches.View.as_view()),
    path('help/resources/', help_resources.View.as_view()),
    path('help/ships/', help_ships.View.as_view()),
    path('help/bbcode/', help_bbcode.View.as_view()),
	#---------------------------------------------------------------------------
    path('mail/blacklist/', mail_blacklist.View.as_view()),
    path('mail/creation/', mail_creation.View.as_view()),
    path('mail/inbox/', mail_inbox.View.as_view()),
    path('mail/outbox/', mail_outbox.View.as_view()),
	#---------------------------------------------------------------------------
    path('map/galaxy/', map_galaxy.View.as_view()),
    path('map/sector/', map_sector.View.as_view()),
    path('map/universe/', map_universe.View.as_view()),
	#---------------------------------------------------------------------------
    path('mercenary/spying/', mercenary_spying.View.as_view()),
	#---------------------------------------------------------------------------
    path('planet/overview/', planet_overview.View.as_view()),
    path('planet/production/', planet_production.View.as_view()),
    path('planet/working/', planet_working.View.as_view()),
    path('planet/transfers/', planet_transfers.View.as_view()),
    path('planet/buildings/', planet_buildings.View.as_view()),
    path('planet/ships/', planet_ships.View.as_view()),
    path('planet/recycling/', planet_recycling.View.as_view()),
    path('planet/trainings/', planet_trainings.View.as_view()),
    path('planet/orbit/', planet_orbit.View.as_view()),
    path('planet/purchases/', planet_purchases.View.as_view()),
    path('planet/sales/', planet_sales.View.as_view()),
	#---------------------------------------------------------------------------
    path('profile/displaying/', profile_displaying.View.as_view()),
    path('profile/overview/', profile_overview.View.as_view()),
    path('profile/reports/', profile_reports.View.as_view()),
    path('profile/notes/', profile_notes.View.as_view()),
    path('profile/options/', profile_options.View.as_view()),
    path('profile/vacancy/', profile_vacancy.View.as_view()),
	#---------------------------------------------------------------------------
    path('ranking/alliances/', ranking_alliances.View.as_view()),
    path('ranking/players/', ranking_players.View.as_view()),
    path('ranking/searching/', ranking_searching.View.as_view()),
	#---------------------------------------------------------------------------
    path('report/battle/', report_battle.View.as_view()),
    path('report/invasion/', report_invasion.View.as_view()),
    path('report/spying/', report_spying.View.as_view()),
    #---------------------------------------------------------------------------
]
################################################################################
