#maths - this should probably be in either Ruby or Java
return if (typeof(d3) == 'undefined')
this.graph = graph  = () ->
graph.maths = module = ->
  exports = () ->

  exports.getDegreeCentrality = (nodes) ->
    return nodes.sort((a,b) -> return (b.total_connections - a.total_connections))

  return exports
