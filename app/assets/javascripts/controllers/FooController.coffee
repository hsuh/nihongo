controllers = angular.module('controllers')
controllers.controller('FooController', ['$rootScope', '$scope', 'testsService',  ($rootScope, $scope, testsService) ->

  $scope.data   = {}
  $scope.data.stack   = {}
  $scope.data.current = {}

  $scope.$watch('data', (data) ->
    console.log('data change!', data)
  )

  $scope.$on('handleTestsBroadcast', () ->
    console.log('handling broadcast...')
    testsService.promise.then((results) ->
      $scope.data.stack   = results
      $scope.data.current = $scope.data.stack[0]
      console.log('tests', $scope.data.stack)
      console.log('current', $scope.data.current)
    )
  )
])
