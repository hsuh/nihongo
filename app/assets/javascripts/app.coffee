nihongo = angular.module('nihongo', ['templates', 'ngRoute', 'controllers'])

nihongo.config(($routeProvider) ->
    $routeProvider
      .when('/',
        templateUrl: "index.html"
        controller: "IndexController"
      )
      .when('/notes/new',
        templateUrl: "new.html"
        controller: "NoteController"
      )
)

notes = [
  {
    id: 1
    name: 'Cheese'
  },
  {
    id: 2
    name: 'Garlic Mashed Potatoes',
  },
  {
    id: 3
    name: 'Garlic Mushrooms',
  }
]

controllers = angular.module('controllers', [])

controllers.controller('IndexController', ['$scope', '$routeParams', '$location', ($scope, $routeParams, $location) ->
  $scope.search = (keywords) ->
    $location.path('/').search('keywords', keywords)

  if $routeParams.keywords
    keywords     = $routeParams.keywords.toLowerCase()
    $scope.notes = notes.filter (note) ->
      note.name.toLowerCase().indexOf(keywords) != -1
  else
    $scope.notes = []

])
controllers.controller('NoteController', ($scope) ->)


