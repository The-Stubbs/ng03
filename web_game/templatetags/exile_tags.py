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
    elif value == 'attack': return mark_safe('<i class="fas fa-exclamation fa-fw" style="color:#d6c642;"></i>')
    elif value == 'defense': return mark_safe('<i class="fas fa-shield-alt fa-fw" style="color:#3173bd;"></i>')
    return '---'
