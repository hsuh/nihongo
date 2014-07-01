nihongo = angular.module('nihongo', ['templates', 'ngResource', 'ngRoute', 'controllers', 'directives'])

nihongo.config(['$routeProvider', ($routeProvider) ->
    $routeProvider
      .when('/',
        templateUrl: "index.html"
        controller: "IndexController"
      )
      .when('/notes/new',
        templateUrl: "new.html"
        controller: "NotesController"
      )
      .when('/graphs/social',
        templateUrl: "social.html"
        controller: "SocialGraphController"
      )
])

controllers = angular.module('controllers', [])
directives  = angular.module('directives', [])

controllers.controller('SocialGraphController', ['$scope', '$routeParams', '$location', (scope, routeParams, location) ->

])

controllers.controller('NotesController', ($scope) ->)

directives.directive('menu', () ->
    return {
        restrict : 'E',
        template :"<a href='/graphs/social'>"+
                  'Graph</a>'
    }
)
