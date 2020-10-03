# -*- coding: utf-8 -*-

from django.urls import path
from django.views.generic.base import RedirectView

from web_game.game import error_500

from web_game.game import empire_planets
from web_game.game import empire_view

from web_game.game import game_connection



################################################################################
handler500 = 'error_500.View'
#-------------------------------------------------------------------------------
urlpatterns = [
	#---------------------------------------------------------------------------
	path('', RedirectView.as_view(url='/game/connection/')),
	#---------------------------------------------------------------------------
    #path('alliance_announce/', alliance_announce.View.as_view()),
    #path('alliance_edition/', alliance_edition.View.as_view()),
    #path('alliance_gifts/', alliance_gifts.View.as_view()),
    #path('alliance_invitations/', alliance_invitations.View.as_view()),
    #path('alliance_members/', alliance_members.View.as_view()),
    #path('alliance_naps/', alliance_naps.View.as_view()),
    #path('alliance_new/', alliance_new.View.as_view()),
    #path('alliance_ranks/', alliance_ranks.View.as_view()),
    #path('alliance_recruitment/', alliance_recruitment.View.as_view()),
    #path('alliance_reports/', alliance_reports.View.as_view()),
    #path('alliance_requests/', alliance_requests.View.as_view()),
    #path('alliance_tributes/', alliance_tributes.View.as_view()),
    #path('alliance_view/', alliance_view.View.as_view()),
    #path('alliance_wallet/', alliance_wallet.View.as_view()),
    #path('alliance_wars/', alliance_wars.View.as_view()),
    #path('battle_public/', battle_public.View.as_view()),
    #path('battle_view/', battle_view.View.as_view()),
    #path('chat_rest/', chat_rest.View.as_view()),
    #path('chat_view/', chat_view.View.as_view()),
    #path('commander_list/', commander_list.View.as_view()),
    #path('commander_skills/', commander_skills.View.as_view()),
    
    #path('empire_orbits/', empire_orbits.View.as_view()),
    #path('empire_parking/', empire_parking.View.as_view()),
    path('empire_planets/', empire_planets.View.as_view()),
    #path('empire_production/', empire_production.View.as_view()),
    #path('empire_stats/', empire_stats.View.as_view()),
    #path('empire_upkeep/', empire_upkeep.View.as_view()),
    path('empire_view/', empire_view.View.as_view()),
    
    #path('fleets_rest/', fleets_rest.View.as_view()),
    #path('fleets_view/', fleets_view.View.as_view()),
    #path('fleet_ships/', fleet_ships.View.as_view()),
    #path('fleet_splitting/', fleet_splitting.View.as_view()),
    #path('fleet_view/', fleet_view.View.as_view()),
    
    path('connection/', game_connection.View.as_view()),
    #path('game_holidays/', game_holidays.View.as_view()),
    #path('game_maintenance/', game_maintenance.View.as_view()),
    #path('game_over/', game_over.View.as_view()),
    #path('game_starting/', game_starting.View.as_view()),
    #path('game_waiting/', game_waiting.View.as_view()),

    #path('help_buildings/', help_buildings.View.as_view()),
    #path('help_general/', help_general.View.as_view()),
    #path('help_researches/', help_researches.View.as_view()),
    #path('help_ships/', help_ships.View.as_view()),
    #path('help_tags/', help_tags.View.as_view()),
    #path('invasion/', invasion.View.as_view()),
    #path('mail_blacklist/', mail_blacklist.View.as_view()),
    #path('mail_inbox/', mail_inbox.View.as_view()),
    #path('mail_new/', mail_new.View.as_view()),
    #path('mail_outbox/', mail_outbox.View.as_view()),
    #path('map/', map.View.as_view()),
    #path('market_purchases/', market_purchases.View.as_view()),
    #path('market_sales/', market_sales.View.as_view()),
    #path('mercenary/', mercenary.View.as_view()),
    #path('planet_buildings/', planet_buildings.View.as_view()),
    #path('planet_market/', planet_market.View.as_view()),
    #path('planet_orbit/', planet_orbit.View.as_view()),
    #path('planet_results/', planet_results.View.as_view()),
    #path('planet_ships/', planet_ships.View.as_view()),
    #path('planet_trainings/', planet_trainings.View.as_view()),
    #path('planet_transferts/', planet_transferts.View.as_view()),
    #path('planet_view/', planet_view.View.as_view()),
    #path('planet_working/', planet_working.View.as_view()),
    #path('profile_notes/', profile_notes.View.as_view()),
    #path('profile_options/', profile_options.View.as_view()),
    #path('profile_reports/', profile_reports.View.as_view()),
    #path('profile_view/', profile_view.View.as_view()),
    #path('ranking_alliances/', ranking_alliances.View.as_view()),
    #path('ranking_players/', ranking_players.View.as_view()),
    #path('researches/', researches.View.as_view()),
    #path('spying/', spying.View.as_view()),
	#---------------------------------------------------------------------------
]
################################################################################
