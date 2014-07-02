controllers = angular.module('controllers')
controllers.controller('SocialGraphController', ['$scope', '$resource', 'flash', '$location', (scope, resource, flash, location) ->

  scope.data   = {}

  Network = resource('/graphs/social', { format: 'json' })
  Network.get(((network) -> scope.data.network = network ),
              ((httpResponse) ->
                scope.data.network = null
                flash.error = "There is no json data"
              )
            )
])
