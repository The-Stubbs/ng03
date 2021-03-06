# -*- coding: utf-8 -*-

from django import template
from django.utils.safestring import mark_safe

register = template.Library()

@register.filter
def icon(value):
    if value == 'credit': return mark_safe('<i class="fas fa-coins fa-fw" style="color:#cead21;"></i>')
    elif value == 'prestige': return mark_safe('<i class="fas fa-award fa-fw" style="color:#197c25;"></i>')
    elif value == 'ore': return mark_safe('<i class="fas fa-cubes fa-fw" style="color:#7b94a5;"></i>')
    elif value == 'hydro': return mark_safe('<i class="fas fa-tint fa-fw" style="color:#c35ff5;"></i>')
    elif value == 'worker': return mark_safe('<i class="fas fa-wrench fa-fw" style="color:#94a5ad;"></i>')
    elif value == 'scientist': return mark_safe('<i class="fas fa-flask fa-fw" style="color:#42b54a;"></i>')
    elif value == 'soldier': return mark_safe('<i class="fas fa-user-ninja fa-fw" style="color:#f70000;"></i>')
    elif value == 'attack': return mark_safe('<i class="fas fa-exclamation-circle fa-fw" style="color:#ffe82d;"></i>')
    elif value == 'defense': return mark_safe('<i class="fas fa-shield-alt fa-fw" style="color:#3173bd;"></i>')
    elif value == 'energy': return mark_safe('<i class="fas fa-bolt fa-fw" style="color:#f7f763;"></i>')
    elif value == 'floor': return mark_safe('<i class="fas fa-th fa-fw" style="color:#bd845a;"></i>')
    elif value == 'space': return mark_safe('<i class="far fa-dot-circle fa-fw" style="color:#bcbcc0;"></i>')
    elif value == 'idle': return mark_safe('<i class="fas fa-wrench fa-fw" style="color:#71d171;"></i>')
    elif value == 'commander': return mark_safe('<i class="fas fa-certificate fa-fw" style="color:#ffff00;"></i>')
    elif value == 'planet': return mark_safe('<i class="fas fa-globe fa-fw" style="color:#35eada;"></i>')
    elif value == 'fleet': return mark_safe('<i class="fas fa-plane fa-fw" style="color:#eee;"></i>')
    return '---'
