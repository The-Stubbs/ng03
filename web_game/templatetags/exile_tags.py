# -*- coding: utf-8 -*-

from django import template
from django.utils.safestring import mark_safe

register = template.Library()

@register.filter
def icon(value):
    if value == 'credit': return mark_safe('<i class="fas fa-coins fa-fw" style="color:#cead21;"></i>')
    elif value == 'prestige': return mark_safe('<i class="fas fa-award fa-fw" style="color:#197c25;"></i>')
    return '---'
