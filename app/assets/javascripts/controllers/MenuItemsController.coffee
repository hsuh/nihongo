controllers = angular.module('controllers')

controllers.controller('MenuItemsController', ['$scope', '$location', '$resource', ($scope, $location, $resource) ->
  $scope.data   = {}
  $scope.data.items = [{name: 'Social', href: '/graphs/social'}, {name: 'Streak', href: ''}]
  $scope.data.list  = ['All', 'Kanji']

  $scope.viewGraph = (type) ->
    if type == 'Social'
      $location.path("/graphs/social")

  $scope.viewList = (type) ->
    if type == 'All'
      $location.path("/notes")

  $scope.newNote = () ->
    $location.path("/notes/new")
])
