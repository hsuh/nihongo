return if (typeof(d3) == 'undefined')
d3.force_cola  = {}
d3.force_cola  = force_cola = () ->
  data        = []
  funcs       = null
  focus       = 0
  selection   = ''
  svg         = null; node=null; link=null; texts=null
  links_group = null; nodes_group = null; texts_group = null
  group = 4; paths_group =null; paths=null; node_clicked = null

  d3cola     = null
  color     = d3.scale.category10()
  graphProp = window.graph.graph_prop()
  graphProp.dr(15)
  width = 650; height=400; forceWidth=500; forceHeight=350

  linkArc = (d) ->
    sourceX = d.source.x; sourceY = d.source.y
    targetX = d.target.x; targetY = d.target.y
    dx = targetX - sourceX
    dy = targetY - sourceY
    dr = Math.sqrt(dx * dx + dy * dy)
    return "M" + sourceX + "," + sourceY + "A" + dr + "," + dr + " 0,0,1" + targetX + "," + targetY

  transform  = (d) ->
    return "translate(" + d.x + "," + d.y + ")"

  tick = () ->
    link.attr("x1", (d) -> return d.source.x)
        .attr("y1", (d) -> return d.source.y)
        .attr("x2", (d) -> return d.target.x)
        .attr("y2", (d) -> return d.target.y)

    paths.attr("d", linkArc)
    node.attr("transform", transform)
    texts.attr("transform", transform)

  setLayout = (newLayout) ->
    d3cola.on("tick", -> tick())

  updateForce = (data) ->
    d3cola = cola.d3adaptor()
      #.nodes(data.cluster_data.clusters[group].nodes)
      #.links(data.cluster_data.clusters[group].links)
      #.avoidOverlaps(true)
      .nodes(data.cluster_data.clusters)
      .links(data.cluster_data.cluster_links)
      .size([width, height])
      .size([forceWidth, forceHeight])

    d3cola.linkDistance(200)
    d3cola.start()

  updatePaths = (data) ->
    paths = paths_group.append('g').selectAll('path').data(data.cluster_data.cluster_links)

    paths.enter().append('path')
      .attr('class', (d) -> return "link")
      .style('fill', 'none')
      .style('stroke', '#666')
      .style('stroke-width', (d) -> return d.link_size || 1)
      .style('stroke-opacity', 0.5)

  updateLinks = (data) ->
    #link = links_group.selectAll("line").data(data.cluster_data.clusters[group].links)
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

  nodeClick = (d) ->
    if node_clicked
      node_clicked.style('stroke', '')

    node_clicked = d3.select(this)
    node_clicked.style('stroke', "black")
    funcs.apply(d)

  dblClick = (d) ->
    funcs.show_cluster()

  updateNodes = (data) ->
    node    = nodes_group.selectAll("circle").data(data.cluster_data.clusters)
    node.exit().remove()
    node.enter().append("circle")
      .attr("class", (d) -> return 'node' + (if d.size then "" else " leaf _") + d.group)
      .attr("r", graphProp.calculateNodeSize)
      #.style("fill", "#2777B4")
      .style("fill", (d,i) -> return color(i))
      .on("mouseover", graphProp.highlightNodeDetails)
      .on("mouseout", graphProp.undoHighlightNode)
      .on("mousedown", () -> nodeMouseDown = true) #separate dragging from clicks
      .on("mouseup", () -> nodeMouseDown = false)
      .on("click", nodeClick)
      .on("dblclick", dblClick)
      .call(d3cola.drag)

    #to update; need to call style operator on selectAll
    #not on the result of append operator
    node.style("fill", (d,i) -> return color(i))

    #Update the text on nodes
    #texts = texts_group.selectAll("text").data(data.cluster_data.clusters[group].nodes)
    texts = texts_group.selectAll("text").data(data.cluster_data.clusters)
    texts.exit().remove()
    texts.enter().append("text")
                 .attr("cx", (d) -> return d.x)
                 .attr("cy", (d) -> return d.y)
                 .attr("y", ".35em")
                 .attr("text-anchor", "middle")
                 .text((d) -> return d.user_count)

    texts.call(d3cola.drag)

  updateChart   = () ->
    node_selected = node.filter((d,i) ->
      d.group == data.selected_cluster.group
    )

    if node_clicked
      node_clicked.style('stroke', '')

    node_selected.style('stroke', "black")
    node_clicked = node_selected

  updateNetwork = (data) ->
    if d3cola
      d3cola.stop()
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
