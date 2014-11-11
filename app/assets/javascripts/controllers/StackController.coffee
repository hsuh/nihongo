controllers = angular.module('controllers')
controllers.controller('StackController', ['$scope','$routeParams', '$resource', 'flash', '$location', ($scope, $routeParams, $resource, flash, $location) ->

  $scope.data   = {}
  $scope.back   = -> $location.path("/stacks")

  Stack = $resource('/stacks/:stackId', { stackId: "@id", format: 'json' },
         { 'save': { method: 'PUT' }, 'create': { method: 'POST' } })

  if $routeParams.stackId
    Stack.get({stackId: $routeParams.stackId},
      ( (stack) -> $scope.data.stack = stack ),
      ( (httpResponse) ->
          $scope.data.stack = null
          flash.error = "There is no stack with ID #{$routeParams.stackId}"
      )
    )
  else
    $scope.data.stack = {}

  $scope.save = ->
    onError = (_httpResponse) -> flash.error = "Something went wrong"
    if $scope.data.stack.id
      $scope.data.stack.$save(
        ( () -> $location.path("/stacks/#{$scope.data.stack.id}") ),
        onError)
    else
      #create sends a post request to rails backend
      Stack.create($scope.data.stack,
        #newStack contains params from the form
        ( (newStack) -> $location.path("/stacks/#{newStack.id}") ),
        onError)
])
