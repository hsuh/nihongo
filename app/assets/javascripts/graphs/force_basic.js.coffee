return if (typeof(d3) == 'undefined')
d3.force_basic  = {}
d3.force_basic  = force_basic = () ->
  data        = []
  funcs       = null
  focus       = 0
  selection   = ''
  svg         = null; nodes=null; link=null; texts=null
  links_group = null; nodes_group = null; texts_group = null
  paths_group =null; paths=null; node_clicked = null
  width = 500; height=400; forceWidth=500; forceHeight=350

  force     = null
  color     = d3.scale.category10()
  graphProp = window.graph.graph_prop()
  graphProp.dr(15)

  linkArc = (d) ->
    sourceX = d.source.x; sourceY = d.source.y
    targetX = d.target.x; targetY = d.target.y
    dx = targetX - sourceX
    dy = targetY - sourceY
    dr = Math.sqrt(dx * dx + dy * dy)
    return "M" + sourceX + "," + sourceY + "A" + dr + "," + dr + " 0,0,1" + targetX + "," + targetY

  dragStart = (d,i) ->
    if force
      force.stop()

  dragMove = (d,i) ->
    d.px += d3.event.dx
    d.py += d3.event.dy
    d.x += d3.event.dx
    d.y += d3.event.dy
    tick()

  dragEnd = (d,i) ->
    d.fixed = true
    tick()
    force.resume()

  nodeDrag = d3.behavior.drag()
  nodeDrag.on("dragstart", dragStart)
  nodeDrag.on("drag", dragMove)
  nodeDrag.on("dragend", dragEnd)
  updateForce = (data) ->
    #may the force be with you
    force = d3.layout.force()
      .nodes(data.cluster_data.clusters)
      .links(data.cluster_data.cluster_links)
      .size([forceWidth, forceHeight])

      force.linkDistance((l,i) -> return 35) #35
      force.gravity(0.09)
      force.charge(-400)

    force.linkStrength((l, i) -> return 0) #2
    force.friction(0.7)
    force.start()

  updateLinks = (data) ->
    link = links_group.selectAll("line").data(data.cluster_data.cluster_links)
    link.exit().remove()
    link.enter().append("line")
      .attr("class", "link")
      .attr("x1", (d) -> return d.source.x)
      .attr("y1", (d) -> return d.source.y)
      .attr("x2", (d) -> return d.target.x)
      .attr("y2", (d) -> return d.target.y)
      .style("stroke-width", (d) -> return d.link_size || 1)
      .style('display', 'none') #hide this for now

  updatePaths = (data) ->
    paths = paths_group.append('g').selectAll('path').data(data.cluster_data.cluster_links)

    paths.enter().append('path')
      .attr('class', (d) -> return "link")
      .style('fill', 'none')
      .style('stroke', '#666')
      .style('stroke-width', (d) -> return d.link_size || 1)
      .style('stroke-opacity', 0.5)

  nodeClick = (d) ->
    if node_clicked
      node_clicked.style('stroke', '')

    node_clicked  = d3.select(this)
    node_clicked.style('stroke', "black")
    funcs.apply(d)

  dblClick = (d) ->
    funcs.show_cluster()

  updateNodes = (data) ->
    nodes    = nodes_group.selectAll("circle").data(data.cluster_data.clusters)
    nodes.exit().remove()
    nodes.enter().append("circle")
      .attr("class", (d) -> return 'node' + (if d.size then "" else " leaf _") + d.group)
      .attr("r", graphProp.calculateNodeSize)
      .style("fill", (d,i) -> return color(i))
      .on("mouseover", graphProp.highlightNodeDetails)
      .on("mouseout", graphProp.undoHighlightNode)
      .on("click", nodeClick)
      .on("dblclick", dblClick)

    #to update; need to call style operator on selectAll
    #not on the result of append operator
    nodes.style("fill", (d,i) -> return color(i))
    nodes.call(nodeDrag)

    #Update the text on nodes
    texts = texts_group.selectAll("text").data(data.cluster_data.clusters)
    texts.exit().remove()
    texts.enter().append("text")
                 .attr("cx", (d) -> return d.x)
                 .attr("cy", (d) -> return d.y)
                 .attr("y", ".35em")
                 .attr("text-anchor", "middle")
                 .text((d) -> return d.user_count)

    texts.call(nodeDrag)


  transform  = (d) ->
    return "translate(" + d.x + "," + d.y + ")"

  tick = () ->
    link.attr("x1", (d) -> return d.source.x)
        .attr("y1", (d) -> return d.source.y)
        .attr("x2", (d) -> return d.target.x)
        .attr("y2", (d) -> return d.target.y)

    paths.attr("d", linkArc)

    nodes.attr("transform", transform)
    texts.attr("transform", transform)

  setLayout = (newLayout) ->
    force.on("tick", -> tick())

  updateChart   = () ->
    node_selected = nodes.filter((d,i) ->
      d.group == data.selected_cluster.group
    )

    if node_clicked
      node_clicked.style('stroke', '')

    node_selected.style('stroke', "black")
    node_clicked = node_selected

  updateNetwork = (data) ->
    if force
      force.stop()
    updateForce(data)
    updateLinks(data)
    updatePaths(data)
    updateNodes(data)
    setLayout("force")

  my_chart = () ->

  my_chart.config = (_selection, _data, _funcs) ->
   selection = _selection
   data      = _data
   funcs     = _funcs
   return this

  my_chart.render = () ->
    if (!data) then return
    data.update_chart = updateChart
    graphProp.averageGroupSize(data.cluster_data)
    svg  = d3.select(selection).append("svg")
             .attr("width", width)
             .attr("height", height)
    links_group = svg.append("g").attr("class", "links")
    paths_group = svg.append("g").attr("class", "paths")
    nodes_group = svg.append("g").attr("class", "nodes")
    texts_group = svg.append("g").attr("class", "text")
    updateNetwork(data)

  return my_chart
