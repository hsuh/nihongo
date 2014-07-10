#methods for manipulating nodes and links of a force directed graph. mostly views
return if (typeof(d3) == 'undefined')
graph.graph_prop = module = ->
  tooltip = null
  dr      = 5
  average_gSize = 60
  #domain - user count, range - affects radius
  #small number of nodes per cluster
  radiusCalcSmall = d3.scale.sqrt().domain([0, 300]).range([0, 150])
  #large number of nodes per cluster
  radiusCalcBig = d3.scale.sqrt().domain([0, 4000]).range([0, 200])

  exports = () ->

  getUserCount = (e) ->
    return e.user_count

  exports.averageGroupSize = (data) ->
    if(!arguments.length) then return average_gSize
    user_counts   = data.clusters.map(getUserCount)
    average_gSize = user_counts.reduce(((a,b) -> return (a + b)), 0)/user_counts.length
    return this

  exports.calculateNodeSize = (d) ->
    if average_gSize > 100
      return (if d.user_count then radiusCalcBig(d.user_count + dr) else dr + 1)
    else
      return (if d.user_count then radiusCalcSmall(d.user_count + dr) else dr + 1)

  exports.dr = (_dr) ->
    if(!arguments.length) then return dr
    dr = _dr
    return this

  return exports
