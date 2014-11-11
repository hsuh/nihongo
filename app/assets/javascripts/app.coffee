nihongo = angular.module('nihongo', [
        'templates',
        'ngResource',
        'ngRoute',
        'ngAnimate',
        'controllers',
        'directives',
        'factories',
        'angular-flash.service',
        'angular-flash.flash-alert-directive',
        'ui.bootstrap'])

nihongo.config(['$routeProvider', 'flashProvider', ($routeProvider, flashProvider) ->
    flashProvider.errorClassnames.push("alert-danger")
    flashProvider.warnClassnames.push("alert-warning")
    flashProvider.infoClassnames.push("alert-info")
    flashProvider.successClassnames.push("alert-success")

    $routeProvider
      .when('/notes',
       templateUrl: "notes.html"
       controller: "NotesController"
      )
      .when('/stacks',
       templateUrl: 'stacks.html'
       controller: 'StacksController'
      )
      .when('/stacks/:stackId',
        templateUrl: "stack.html"
        controller: "StackController"
      )
      .when('/notes/new',
        templateUrl: "form.html"
        controller: "NoteController"
      )
      .when('/notes/:noteId',
        templateUrl: "show.html"
        controller: "NoteController"
      )
      .when('/tests',
        templateUrl: "tests.html"
        controller: "FooController"
      )
      .when('/graphs/social',
        templateUrl: "social.html"
        controller: "SocialGraphController"
      )
])

services    = angular.module('factories', [])
controllers = angular.module('controllers', [])
directives  = angular.module('directives', [])

