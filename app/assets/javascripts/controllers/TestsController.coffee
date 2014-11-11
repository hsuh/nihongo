controllers = angular.module('controllers')


controllers.controller('TestsController', ['$rootScope', '$scope', '$q', '$routeParams', '$location', '$resource', 'testsService', ($rootScope, $scope, $q, $routeParams, $location, $resource, testsService) ->

  $scope.data   = {}
  promise       = {}

  Tests = $resource('/tests', { format: 'json' })
  Test  = $resource('/tests/:testId/edit', { testId : "@id", format: 'json' },
         { 'update': { method: 'PUT' } })

  #practise button click on stack
  $scope.practise = (stackId) ->
    testsService.get(stackId)
    $location.path('/tests')
])
