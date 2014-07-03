controllers = angular.module('controllers')

controllers.controller('FormController', ['$scope', '$routeParams', '$location', '$resource', ($scope, $routeParams, $location, $resource) ->
  $scope.data   = {}
])
