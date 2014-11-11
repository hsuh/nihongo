services = angular.module('factories')
services.factory('testsService', ['$rootScope', '$q', '$resource', '$timeout',  ($rootScope, $q, $resource, $timeout) ->
  Tests = $resource('/tests', { format: 'json' })

  testsService         = {}
  testsService.promise = {}

  testsService.tests_broadcast = () ->
    $timeout(() ->
      $rootScope.$broadcast('handleTestsBroadcast')
    )

  getDataFromServer = (stackId) ->
    defer = $q.defer()
    console.log('getting data...')
    if stackId
      Tests.query(stack_id: stackId, (results) ->
        defer.resolve(results)
      )
    return defer.promise

  testsService.get = (stackId) ->
    testsService.promise = getDataFromServer(stackId)
    console.log('promise', testsService.promise)
    this.tests_broadcast()

  return testsService
])
