#seemingly declare controllers again but
#without 2nd argument this is just a way of letting ng know
#we just want access to the previously declared module

controllers = angular.module('controllers')
controllers.controller('IndexController', ['$scope', '$routeParams', '$location', '$resource', ($scope, $routeParams, $location, $resource) ->
  $scope.search = (keywords) -> $location.path('/').search('keywords', keywords)
  Note          = $resource('/notes/:nodeId', { noteId: "@id", format: 'json' })

  if $routeParams.keywords
    Note.query(keywords: $routeParams.keywords, (results) -> $scope.notes = results)
  else
    $scope.notes = []
])
