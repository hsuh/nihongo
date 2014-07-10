directives  = angular.module('directives')
directives.directive('flipMe', ($animate) ->
  return (scope, elements, attrs) ->
    console.log('attrs', attrs)
    scope.$watch(attrs.flipMe, (newVal) ->
      console.log('animate', $animate)
      if(newVal)
        $animate.addClass(element, 'flipped')
      else
        $animate.removeClass(element, 'flipped')
    )
)
