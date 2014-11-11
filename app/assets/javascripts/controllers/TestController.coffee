controllers = angular.module('controllers')
controllers.controller('TestController', ['$scope','$routeParams', '$resource', 'flash', '$location', ($scope, $routeParams, $resource, flash, $location) ->

  $scope.data   = {}

  Test = $resource('/tests/:testId/edit', { testId : "@id", format: 'json' },
         { 'update': { method: 'PUT' } })

  Tests = $resource('/tests', { format: 'json' })

  #a request from browser
  if $routeParams.testId
    Test.get({testId: $routeParams.testId},
      ( (test) ->
        $scope.data.test = test
      ),
      ( (httpResponse) ->
          $scope.data.test = null
          flash.error = "There is no test with ID #{$routeParams.testId}"
      ))
  else
    $scope.data.test = {}


  $scope.update = ->
    onError = (_httpResponse) ->
      flash.error = "Something went wrong"

    if $scope.data.test.id
      $scope.data.test.$update(
        ( () -> $location.path("/tests/#{$scope.data.test.id}?test=") ),
        onError)

])
