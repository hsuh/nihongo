describe "MenuItemsController", ->
  scope       = null
  ctrl        = null
  location    = null
  httpBackend = null
  flash       = null

  setupController = () ->
    inject(($location, $rootScope, $httpBackend, $controller, _flash_) ->
      scope    = $rootScope.$new()
      location = $location
      httpBackend = $httpBackend
      flash = _flash_

      ctrl = $controller('MenuItemsController', $scope: scope)
    )

  beforeEach(module('nihongo'))

  afterEach ->
    httpBackend.verifyNoOutstandingExpectation()
    httpBackend.verifyNoOutstandingRequest()

  describe 'viewGraph()', ->
    beforeEach(setupController())
    it 'redirects to /graphs/social', ->
      scope.viewGraph('Social')
      expect(location.path()).toBe("/graphs/social")
