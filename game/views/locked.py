# -*- coding: utf-8 -*-

from game.views._base import *



################################################################################
class View(LoginRequiredMixin, View):
    
    template_name = 'game/locked.html'
    success_url = '/game/locked/'

    #---------------------------------------------------------------------------
    def dispatch(self, request, *args, **kwargs):
        #-----------------------------------------------------------------------
        return super().dispatch(request, *args, **kwargs)
        #-----------------------------------------------------------------------

    #---------------------------------------------------------------------------
    def get(self, request, *args, **kwargs):
        context = {}
        return render(request, self.template_name, context)
    #---------------------------------------------------------------------------
    
    #---------------------------------------------------------------------------
    def post(self, request, *args, **kwargs):
        #-----------------------------------------------------------------------
        if action == 'unlock':
            #-------------------------------------------------------------------
            result = db_result(cursor, 'SELECT (' + ')')
            if result == 0: return HttpResponseRedirect(self.success_url)
            else: messages.error(request, 'error_' + str(result))
        #-----------------------------------------------------------------------
        context = {}
        return render(request, self.template_name, context)
        #-----------------------------------------------------------------------

################################################################################
