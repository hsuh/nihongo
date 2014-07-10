directives  = angular.module('directives')
directives.directive('graphSettingsDirective', () ->
  ctrl = ($scope) ->
    $scope.data                = {}
    $scope.data.show_renderers = false
    $scope.data.show_clusters  = false
    $scope.data.blurred        = true

    #show/hide dropdown div
    $scope.show_renderers_dropdown = () ->
      $scope.data.show_renderers = !$scope.data.show_renderers
      $scope.data.show_clusters  = false

    $scope.show_clusters_dropdown = () ->
      $scope.data.show_clusters  = !$scope.data.show_clusters
      $scope.data.show_renderers = false

    $scope.toggle_settings = () ->
      $scope.data.blurred = !$scope.data.blurred
      $scope.data.show_clusters  = false
      $scope.data.show_renderers = false

    #update when a cluster option is clicked
    #on the dropdown
    $scope.select_cluster = (c) ->
      $scope.network.selected_cluster = c
      $scope.network.update_chart()

    $scope.update_graph_layout = (r) ->
      $scope.network.renderer = r
      $scope.network.update_layout($scope.network)

  link = (scope, el, attr) ->
    scope.$watch('network', (network) ->
      console.log('network from settings..', network)
    )

  return {
      link: link,
      restrict : 'A',
      templateUrl: 'graph_settings.html'
      controller: ctrl,
      scope: {
        network: '='
      }
  }
)
