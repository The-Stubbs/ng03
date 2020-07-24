# -*- coding: utf-8 -*-

from django.conf import settings
from django.conf.urls.static import static
from django.urls import include, path
from django.views.generic.base import RedirectView



################################################################################
urlpatterns = [
	#---------------------------------------------------------------------------
	path('',                RedirectView.as_view(url='/game/empire/overview/')),
    path('favicon.ico',     RedirectView.as_view(url='/static/favicon.ico')),
    #---------------------------------------------------------------------------
    path('impersonate/',    include('impersonate.urls')),
    path('game/',           include('game.urls')),
    #---------------------------------------------------------------------------
] + static(settings.STATIC_URL, document_root=settings.STATIC_ROOT)
################################################################################
