nihongo = angular.module('nihongo', [
        'templates',
        'ngResource',
        'ngRoute',
        'controllers',
        'angular-flash.service',
        'angular-flash.flash-alert-directive',
        'ui.bootstrap',
        'directives'])

nihongo.config(['$routeProvider', 'flashProvider', ($routeProvider, flashProvider) ->
    flashProvider.errorClassnames.push("alert-danger")
    flashProvider.warnClassnames.push("alert-warning")
    flashProvider.infoClassnames.push("alert-info")
    flashProvider.successClassnames.push("alert-success")

    $routeProvider
      .when('/notes',
       templateUrl: "results.html"
       controller: "NotesController"
      )
      .when('/notes/:noteId',
        templateUrl: "show.html"
        controller: "NoteController"
      )
      .when('/notes/new',
        templateUrl: "form.html"
        controller: "FormController"
      )
      .when('/graphs/social',
        templateUrl: "social.html"
        controller: "SocialGraphController"
      )
])

controllers = angular.module('controllers', [])
directives  = angular.module('directives', [])
