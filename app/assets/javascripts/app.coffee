nihongo = angular.module('nihongo', [
        'templates',
        'ngResource',
        'ngRoute',
        'controllers',
        'directives',
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
      .when('/notes/new',
        templateUrl: "form.html"
        controller: "NoteController"
      )
      .when('/notes/:noteId',
        templateUrl: "show.html"
        controller: "NoteController"
      )
      .when('/graphs/social',
        templateUrl: "social.html"
        controller: "SocialGraphController"
      )
])

controllers = angular.module('controllers', [])
directives  = angular.module('directives', [])

