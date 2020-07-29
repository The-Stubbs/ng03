# -*- coding: utf-8 -*-

from django import template
from django.utils.safestring import mark_safe

register = template.Library()

@register.filter
def icon(value):
    if value == 'credit': return mark_safe('<img src="/static/credit.gif" title="Crédits" data-toggle="tooltip"></i>')
    elif value == 'prestige': return mark_safe('<img src="/static/prestige.gif" title="Prestige" data-toggle="tooltip"></i>')
    elif value == 'ore': return mark_safe('<img src="/static/ore.gif" title="Minerai" data-toggle="tooltip"></i>')
    elif value == 'hydro': return mark_safe('<img src="/static/hydro.gif" title="Hydro" data-toggle="tooltip"></i>')
    elif value == 'energy': return mark_safe('<img src="/static/energy.gif" title="Energie" data-toggle="tooltip"></i>')
    elif value == 'worker': return mark_safe('<img src="/static/worker.gif" title="Travailleur" data-toggle="tooltip"></i>')
    elif value == 'scientist': return mark_safe('<img src="/static/scientist.gif" title="Scientifique" data-toggle="tooltip"></i>')
    elif value == 'soldier': return mark_safe('<img src="/static/soldier.gif" title="Soldat" data-toggle="tooltip"></i>')
    elif value == 'floor': return mark_safe('<img src="/static/floor.gif" title="Terrain" data-toggle="tooltip"></i>')
    elif value == 'space': return mark_safe('<img src="/static/space.gif" title="Espace" data-toggle="tooltip"></i>')
    elif value == 'special': return mark_safe('<img src="/static/special.gif" title="Bonus" data-toggle="tooltip"></i>')
    return '---'
