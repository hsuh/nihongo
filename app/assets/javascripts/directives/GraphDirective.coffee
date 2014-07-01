directives  = angular.module('directives')
directives.directive('menu', () ->
    return {
        restrict : 'E',
        template :"<a href='/graphs/social'>"+
                  'Graph</a>'
    }
)
