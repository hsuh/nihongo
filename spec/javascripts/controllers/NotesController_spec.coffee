describe "NotesController", ->
  scope       = null
  ctrl        = null
  location    = null
  routeParams = null
  resource    = null
  httpBackend = null

  setupController = (keywords, results) ->
    inject(($location, $routeParams, $rootScope, $httpBackend, $resource, $controller) ->
      scope    = $rootScope.$new()
      location = $location
      resource = $resource
      httpBackend = $httpBackend
      routeParams = $routeParams
      routeParams.keywords = keywords


      if results && keywords == ""
        request = new RegExp("\/notes")
        httpBackend.expectGET(request).respond(results)
      else if results
        request = new RegExp("\/notes.*keywords=#{keywords}")
        httpBackend.expectGET(request).respond(results)
      else
        request = new RegExp("\/notes")
        httpBackend.expectGET(request).respond(results)

      ctrl = $controller('NotesController',
                        $scope: scope,
                        $location: location)
    )

  beforeEach(module('nihongo'))
  afterEach ->
    httpBackend.verifyNoOutstandingExpectation()
    httpBackend.verifyNoOutstandingRequest()


  describe 'controller initialization', ->
    describe 'when no keywords present', ->
      keywords = ""
      notes = [
        {
          id: 2
          kanji: "foo bar"
        },
        {
          id: 4
          kanji: "foo fez"
        },
        {
          id: 5
          kanji: "booey"
        }
      ]
      beforeEach ->
        setupController(keywords, notes)
        httpBackend.flush() #resolves all asyn promises

      it 'calls the back-end and return all notes', ->
        expect(scope.data.notes).toEqualData(notes)

    describe 'with keywords', ->
      keywords = "foo" #find out a way to test this with kanji characters
      notes = [
        {
          id: 2
          kanji: "foo bar"
        },
        {
          id: 4
          kanji: "foo fez"
        }
      ]
      beforeEach ->
        setupController(keywords, notes)
        httpBackend.flush() #resolves all asyn promises

      it 'calls the back-end', ->
        expect(scope.data.notes).toEqualData(notes)

  describe 'search()', ->
    beforeEach ->
      setupController()
      httpBackend.flush() #resolves all asyn promises

    it 'redirects to itself with a keyword param', ->
      keywords = '今年'
      scope.search(keywords)
      expect(location.path()).toBe("/notes")
      expect(location.search()).toEqualData({keywords: keywords})
