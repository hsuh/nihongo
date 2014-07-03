controllers = angular.module('controllers')
controllers.controller('NoteController', ['$scope','$routeParams', '$resource', 'flash', '$location', ($scope, $routeParams, $resource, flash, $location) ->

  $scope.data   = {}
  $scope.back   = -> $location.path("/notes")

  Note = $resource('/notes/:noteId', { noteId: "@id", format: 'json' },
         { 'save': { method: 'PUT' }, 'create': { method: 'POST' } })

  if $routeParams.noteId
    Note.get({noteId: $routeParams.noteId},
      ( (note) -> $scope.data.note = note ),
      ( (httpResponse) ->
          $scope.data.note = null
          flash.error = "There is no note with ID #{$routeParams.noteId}"
      )
    )
  else
    $scope.data.note = {}

  $scope.save = ->
    onError = (_httpResponse) -> flash.error = "Something went wrong"
    if $scope.data.note.id
      $scope.data.note.$save(
        ( () -> $location.path("/notes/#{$scope.data.note.id}") ),
        onError)
    else
      #create sends a post request to rails backend
      Note.create($scope.data.note,
        #newNote contains params from the form
        ( (newNote) -> $location.path("/notes/#{newNote.id}") ),
        onError)
])
