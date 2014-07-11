directives  = angular.module('directives')
directives.directive('graphDirective', () ->
  renderer = window.renderer.graph()
  link = (scope, el, attr) ->
    scope.funcs    = {}

    #called by graph object to update values
    #when user interacts with the graph
    scope.funcs.apply = (d) ->
      scope.$apply(()->
        scope.network.selected_cluster = d
        scope.network.user_count       = d.user_count
      )

    #swap out your current graph with new graph
    #i.e. render nodes inside a cluster, when user double clicks
    #on a pie slice or send this request by any other means
    scope.funcs.show_cluster = () ->
      graph                           = renderer.type('in-force-cola')
      #find a better way of transitioning between graphs
      graph().config(el[0], scope.network).render()
      $('#graph').children()[0].remove()

      scope.$apply(()  ->
        scope.network.current_graph     = graph
        scope.network.toolbar_selection = 'inside_cluster'
      )
      return

    #update layout for the same data
    update_layout = (network) ->
      graph                 = renderer.type(network.renderer)
      network.current_graph = graph
      graph().config(el[0], network, scope.funcs).render()
      #remove previous svg
      $('#graph').children()[0].remove()
      return


    scope.$watch('network', (network) ->
      if(!network) then return
      graph                      = renderer.type('pie')
      network.current_graph      = graph
      network.update_layout      = update_layout
      graph().config(el[0],network, scope.funcs).render()
    )

  return {
      restrict : 'A',
      link: link,
      scope: {
        network: '='
      }
  }
)
