controllers = angular.module('controllers')

controllers.controller('StacksController', ['$scope', '$routeParams', '$location', '$resource', ($scope, $routeParams, $location, $resource) ->

  $scope.data   = {}
  $scope.view   = (stackId) -> $location.path("/stacks/#{stackId}")
  $scope.search = (keywords) ->
    $location.path('/stacks').search('keywords', keywords)

  Stack = $resource('/stacks', { format: 'json' })

  if $routeParams.keywords
    Stack.query(keywords: $routeParams.keywords, (results) -> $scope.data.stacks = results)
  else
    Stack.query((results) -> $scope.data.stacks = results)

])
