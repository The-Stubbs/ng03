# -*- coding: utf-8 -*-

from game.views._base import *



################################################################################
class View(ActionView):
    
    template_name = 'game/alliance_creation.html'
    success_url = '/game/alliance/creation/'
    
    menu_selected = 'alliance'
    submenu_selected = 'alliance_creation'

    #---------------------------------------------------------------------------
    def get_context(self, request, cursor, **kwargs):
        #-----------------------------------------------------------------------
        context = super().get_context(request, cursor, **kwargs)
        #-----------------------------------------------------------------------
        if self.profile['can_join_alliance']: context['can_create'] = True
        else: context['cant_create'] = True
        #-----------------------------------------------------------------------
        return context
        #-----------------------------------------------------------------------
    
    #---------------------------------------------------------------------------
    def process_action(self, request, cursor, action):
        #-----------------------------------------------------------------------
        if action == 'create':
            #-------------------------------------------------------------------
            tag = request.POST.get('tag').strip()
            name = request.POST.get('name').strip()
            description = request.POST.get('description').strip()
            #-------------------------------------------------------------------
            result = db_result(cursor, 'SELECT ua_alliance_create(' + self.profile['id'] + ',' + sql_str(name) + ',' + sql_str(tag) + ',' + sql_str(description) + ')')
            if result == 0: return self.success()
            else: messages.error(request, 'error_alliance_create_' + str(result))
        #-----------------------------------------------------------------------
        return self.failed()
        #-----------------------------------------------------------------------

################################################################################
