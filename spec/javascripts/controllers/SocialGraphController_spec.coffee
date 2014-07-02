describe "SocialGraphController", ->
  scope       = null
  ctrl        = null
  location    = null
  httpBackend = null
  flash       = null

  fakeNetwork =
    clusters: 'clusters'
    users: 'users'
    links: 'links'

  setupController = (jsonExists=true) ->
    inject(($location, $rootScope, $httpBackend, $controller, _flash_) ->
      scope    = $rootScope.$new()
      location = $location
      httpBackend = $httpBackend
      flash = _flash_

      request = new RegExp("\/graphs/social")
      results = if jsonExists
        [200, fakeNetwork]
      else
        [404]
      httpBackend.expectGET(request).respond(results[0], results[1])

      ctrl = $controller('SocialGraphController', $scope: scope)
    )

  beforeEach(module('nihongo'))

  afterEach ->
    httpBackend.verifyNoOutstandingExpectation()
    httpBackend.verifyNoOutstandingRequest()

  describe 'controller initialization', ->
    describe 'network data is received,', ->
      beforeEach(setupController())
      it 'and loads the json', ->
        httpBackend.flush()
        expect(scope.data.network).toEqualData(fakeNetwork)

    describe 'network data is not received', ->
      beforeEach(setupController(false))
      it 'loads the json', ->
        httpBackend.flush()
        expect(scope.data.network).toBe(null)
        expect(flash.error).toBe("There is no json data")
