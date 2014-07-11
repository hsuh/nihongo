controllers = angular.module('controllers')
controllers.controller('SocialGraphController', ['$scope', '$resource', 'flash', '$location', (scope, resource, flash, location) ->

  scope.data = {}
  data_prep  = window.dataCleaner.cleaner()

  Network = resource('/graphs/social', { format: 'json' })
  Network.get(((network) ->
                data_prep.data(network)
                scope.data.network = {
                  cluster_data: data_prep.prepareData(),
                  current_graph: '',
                  selected_cluster: '',
                  show_all_clusters: '',
                  renderers: ['pie', 'force-basic', 'force-cola'],
                  renderer: 'pie',
                  toolbar_selection: 'all_clusters'
                }
              ),
              ((httpResponse) ->
                scope.data.network = null
                flash.error = "There is no json data"
              )
            )
])
