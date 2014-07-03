controllers = angular.module('controllers')

controllers.controller('NotesController', ['$scope', '$routeParams', '$location', '$resource', ($scope, $routeParams, $location, $resource) ->

  $scope.data   = {}
  $scope.view   = (noteId) -> $location.path("/notes/#{noteId}")
  $scope.search = (keywords) ->
    $location.path('/notes').search('keywords', keywords)

  Note = $resource('/notes', { format: 'json' })

  if $routeParams.keywords
    Note.query(keywords: $routeParams.keywords, (results) -> $scope.data.notes = results)
  else
    $scope.data.notes = []
])
