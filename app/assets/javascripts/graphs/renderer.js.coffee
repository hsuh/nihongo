return if (typeof(d3) == 'undefined')
this.renderer = renderer = () ->
renderer.graph = module = ->
  graph_type   = 'pie'
  pie          = d3.pie()
  cola         = d3.force_cola()
  in_cola      = d3.in_force_cola()
  force_basic  = d3.force_basic()
  color        = {0: "#8bb9d0",1: "#659941" ,2: "#ea9639", 3: "#cb6698", 4: "#036597",5: "#BC5D58", 6: "#BAB86C"}

  exports = () ->
    if graph_type == 'pie'
      return pie
    if graph_type == 'in-force-cola'
      return in_cola
    if graph_type == 'force-cola'
      return cola
    if graph_type == 'force-basic'
      return force_basic

  exports.type = (_t) ->
    if(!arguments.length) then return graph_type
    graph_type = _t
    return this

  return exports

