# -*- coding: utf-8 -*-

from django.urls import path
from django.views.generic import TemplateView
from django.views.generic.base import RedirectView

from game.views import game_connection

from game.views import empire_view

################################################################################
handler500 = 'error_500.View'
#-------------------------------------------------------------------------------
urlpatterns = [
	#---------------------------------------------------------------------------
	path('', RedirectView.as_view(url='/game/connection/')),
    path('connection/', game_connection.View.as_view()),
	#---------------------------------------------------------------------------
    path('empire_view/', empire_view.View.as_view()),
]
################################################################################
