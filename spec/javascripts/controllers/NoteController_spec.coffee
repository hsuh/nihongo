describe "NoteController", ->
  scope       = null
  ctrl        = null
  location    = null
  routeParams = null
  httpBackend = null
  flash       = null
  noteId      = 42

  fakeNote =
    id: noteId
    kanji: "去年"
    kana: 'きょねん'
    meaning: 'Last year'

  setupController = (noteExists=true) ->
    inject(($location, $routeParams, $rootScope, $httpBackend, $controller, _flash_) ->
      scope    = $rootScope.$new()
      location = $location
      httpBackend = $httpBackend
      routeParams = $routeParams
      routeParams.noteId = noteId
      flash = _flash_

      request = new RegExp("\/notes/#{noteId}")
      results = if noteExists
        [200, fakeNote]
      else
        [404]
      httpBackend.expectGET(request).respond(results[0], results[1])

      ctrl = $controller('NoteController', $scope: scope)
    )

  beforeEach(module('nihongo'))

  afterEach ->
    httpBackend.verifyNoOutstandingExpectation()
    httpBackend.verifyNoOutstandingRequest()

  describe 'controller initialization', ->
    describe 'note is found', ->
      beforeEach(setupController())
      it 'loads the given note', ->
        httpBackend.flush()
        expect(scope.data.note).toEqualData(fakeNote)

    describe 'note is not found', ->
      beforeEach(setupController(false))
      it 'loads the given note', ->
        httpBackend.flush()
        expect(scope.data.note).toBe(null)
        expect(flash.error).toBe("There is no note with ID #{noteId}")
