controllers = angular.module('controllers')
controllers.controller('NoteController', ['$scope','$routeParams', '$resource', 'flash', '$location', ($scope, $routeParams, $resource, flash, $location) ->
  $scope.back   = -> $location.path("/")

  Note = $resource('/notes/:noteId', { noteId: "@id", format: 'json' })

  Note.get({noteId: $routeParams.noteId},
    ( (note) -> $scope.note = note ),
    ( (httpResponse) ->
        $scope.note = null
        flash.error = "There is no note with ID #{$routeParams.noteId}"
    )
  )
])
