return if (typeof(d3) == 'undefined')
d3.in_force_cola  = {}
d3.in_force_cola  = in_force_cola = () ->
  data        = []
  focus       = 0
  r           = 8
  selection   = ''
  svg         = null; nodes=null; link=null; texts=null
  links_group = null; nodes_group = null; texts_group = null
  nodeMouseDown = false; paths_group =null; paths=null
  zoom= null; group = 4; tooltip = null; hoverimage = null
  node_click_count = 0; last_clicked = null

  d3cola     = null
  color   = {0:"#8bb9d0",1:"#659941" ,2:"#ea9639", 3: "#cb6698", 4: "#036597", 5: "#BC5D58", 6: "#BAB86C"}
  graphProp = window.graph.graph_prop()
  graphProp.dr(15)
  width = 650; height=400; forceWidth=500; forceHeight=400

  transform  = (d) ->
    max_dx = Math.max(r, Math.min(width - r, d.x))
    max_dy = Math.max(r, Math.min(height - r, d.y))
    return "translate(" + max_dx + "," + max_dy + ")"

  linkArc = (d) ->
    max_sourceX = Math.max(r, Math.min(width - r, d.source.x))
    max_sourceY = Math.max(r, Math.min(height - r, d.source.y))

    max_targetX = Math.max(r, Math.min(width - r, d.target.x))
    max_targetY = Math.max(r, Math.min(height - r, d.target.y))

    #sourceX = d.source.x; sourceY = d.source.y
    #targetX = d.target.x; targetY = d.target.y
    dx = max_targetX - max_sourceX
    dy = max_targetY - max_sourceY
    dr = Math.sqrt(dx * dx + dy * dy) + 5
    return "M" + max_sourceX + "," + max_sourceY + "A" + dr + "," + dr + " 0,0,1" + max_targetX + "," + max_targetY

  tick = () ->
    link.attr("x1", (d) -> return d.source.x)
        .attr("y1", (d) -> return d.source.y)
        .attr("x2", (d) -> return d.target.x)
        .attr("y2", (d) -> return d.target.y)

    nodes.attr("transform", transform)
    paths.attr("d", linkArc)
    texts.attr("transform", transform)

  setLayout = (newLayout) ->
    d3cola.on("tick", -> tick())

  updateForce = (data) ->
    d3cola = cola.d3adaptor()
      .nodes(data.selected_cluster.nodes)
      .links(data.selected_cluster.links)
      .size([width, height])
      .size([forceWidth, forceHeight])

    d3cola.linkDistance(70).avoidOverlaps
    d3cola.start()

  updatePaths = (data) ->
    paths = paths_group.append('g').selectAll('path').data(data.selected_cluster.links)

    paths.enter().append('path')
      .attr('class', (d) -> return "link")
      .style('fill', 'none')
      .style('stroke', '#666')
      .style('stroke-width', (d) -> return 1)
      .style('stroke-opacity', 1)

  updateLinks = (data) ->
    #link = links_group.selectAll("line").data(data.cluster_data.clusters[group].links)
    link = links_group.selectAll("line").data(data.selected_cluster.links)
    link.exit().remove()
    link.enter().append("line")
      .attr("class", "link")
      .attr("x1", (d) -> return d.source.x)
      .attr("y1", (d) -> return d.source.y)
      .attr("x2", (d) -> return d.target.x)
      .attr("y2", (d) -> return d.target.y)
      .style("stroke-width", (d) -> return d.link_size || 1)
      .style('display', 'none') #hide this for now

  nodeSize = (d) ->
    if d.total_connections == 0
      return 2
    else if d.total_connections == 1
      return 3
    else
      return 8

  hide_nodes = () ->
    node_no_links = nodes.filter((d,i) ->
      d.total_connections == 0
    )
    node_no_links.style('display', 'none')


  show_tooltip = (d, sidebar_link) ->
    #should use profile_thumb
    #photo_to_profile method in applcation_helper.rb
    conn    = d.total_connections #ToDo add connections
    inner   = d.inner_connections.length
    outer   = d.outer_connections.length
    promise = data.get_user_json(d.user_id)
    promise.then(
      (data) ->
        name  = data.first_name + ' ' + data.last_name
        photo = data.photo_url
        html  = "<a href='#' id=close-icon></a>
                 <span class=node_image>
                 <img src=#{photo}></span>
                 <span>#{name}</span><hr/>
                 <div class=tooltip-data>
                 <span>Connections:</span><br/>
                 <span>Total - #{conn}</span><br/>
                 <span>Inside Cluster  - #{inner}</span><br/>
                 <span>Outside Cluster - #{outer}</span>
                 </div>"
        tooltip.style("visibility", "visible")
                .transition()
                .duration(200)
                .style("opacity", 0.9)
        tooltip.html(html)
      ,(err) ->
        html  = "<a href='#' id=close-icon></a>
                 <span>" + d.name  + "</span><hr/>
                 <div class=tooltip-data>
                 <span>Connections:</span><br/>
                 <span>Total - #{conn}</span><br/>
                 <span>Inside Cluster - #{inner}</span><br/>
                 <span>Outside Cluster - #{outer}</span>
                 </div>"
        tooltip.style("visibility", "visible")
                .transition()
                .duration(200)
                .style("opacity", 1)
        tooltip.html(html)
    )
    if sidebar_link != true
      x = d3.event.pageX; y = d3.event.pageY
      tooltip.style('visibility', 'visible')
              .style('top', (y - 30) + "px")
              .style('left', (x + 15) + "px")
    else
      tooltip.style('visibility', 'visible')
              .style('top', (d.y  + 310 - 15) + "px")
              .style('left', (d.x + 400 + 30) + "px")

    change_stroke_style(d, "#de2d26", 5, 0.5)
  $(document).on('click', '#close-icon', (e)->
    hide_tooltip(d)
    e.preventDefault()
  )

  hide_tooltip = (d) ->
    change_stroke_style(d, "#fff", 1, '')
    tooltip.transition()
            .duration(500)
            .style('opacity', 1e-6)
            .each('end', () ->
              tooltip.style("visibility", "hidden")
            )

  change_stroke_style = (d, colour, stroke_width, opacity) ->
    my_node = nodes.filter((node, i) ->
      d.user_id == node.user_id)
    my_node.style('stroke', colour)
           .style('stroke-width', stroke_width)
           .style('stroke-opacity', opacity)

  nodeClick = (d, i, sidebar_link) ->
    if last_clicked == null
      last_clicked     = d
      node_click_count += 1
      show_tooltip(d, sidebar_link)
    else if last_clicked.user_id == d.user_id && node_click_count > 0
      last_clicked = null
      node_click_count = 0
      hide_tooltip(d)
    else if last_clicked.user_id != d.user_id && node_click_count > 0
      hide_tooltip(last_clicked)
      show_tooltip(d, sidebar_link)
      last_clicked = d

    nodes.style('fill-opacity', (o) ->
      thisOpacity = 0.5
      if d.user_id == o.user_id then return 1
      $.each d.inner_connections, (k, n_obj) ->
        if n_obj.user_id == o.user_id
          thisOpacity = 1
          return thisOpacity
      return thisOpacity
    )

  updateNodes = (data) ->
    nodes    = nodes_group.selectAll("circle").data(data.selected_cluster.nodes)
    nodes.exit().remove()
    nodes.enter().append("circle")
      .attr("class", (d) -> return 'node' + (if d.size then "" else " leaf _") + d.total_connections + " " + d.user_id)
      .attr("r", nodeSize)
      .style("fill", (d,i) -> return color[d.group])
      .on("mousedown", () -> nodeMouseDown = true)
      .on("mouseup", () -> nodeMouseDown = false)
      .on("click", nodeClick)

    #transition the very small nodes in
    small_nodes = nodes.filter((d,i) ->
      d.total_connections == 0)
    small_nodes.attr('r', 8)
               .transition().duration(1000)
               .attr('r', nodeSize)

    #to update; need to call style operator on selectAll
    #not on the result of append operator
    nodes.style("fill", (d,i) -> return color[d.group])
    nodes.call(d3cola.drag)

    if data.hide_nodes
      hide_nodes()

    #Update the text on nodes
    #texts = texts_group.selectAll("text").data(data.cluster_data.clusters[group].nodes)
    texts = texts_group.selectAll("text").data(data.selected_cluster.nodes)
    texts.exit().remove()
    texts.enter().append("text")
                 .attr("cx", (d) -> return d.x)
                 .attr("cy", (d) -> return d.y)
                 .attr("y", ".35em")
                 .attr("text-anchor", "middle")
                 #.text((d) -> return d.group) #change back to user_count for clusters

    texts.call(d3cola.drag)

  redraw = () ->
    if nodeMouseDown then return
    trans = d3.event.translate
    scale = d3.event.scale
    svg.attr("transform", "translate(" + trans + ")" + " scale(" + scale + ")")

  updateNetwork = (data) ->
    if d3cola
      d3cola.stop()
    updateForce(data)
    updateLinks(data)
    updatePaths(data)
    updateNodes(data)
    setLayout("force")

  my_chart = () ->

  my_chart.config = (_selection, _data) ->
   selection = _selection
   data      = _data
   return this

  my_chart.hide_nodes = () ->
    hide_nodes()

  my_chart.show_nodes = () ->
    node_no_links = nodes.filter((d,i) ->
      d.total_connections == 0
    )
    node_no_links.style('display', '')

  my_chart.show_node_info = (user) ->
    nodeClick(user, user.user_id, true)

  my_chart.do_something = () ->
    nodes.transition().style("fill", (d,i) -> return color[5])

  my_chart.render = () ->
    if (!data) then return
    zoom    = d3.behavior.zoom()
    svg  = d3.select(selection).append("svg")
             .attr("width", width)
             .attr("height", height)
             .attr("pointer-events", "all")
            .append('svg:g')
             .call(zoom.on("zoom",redraw))
            .append('svg:g')
            #panning doesn't work well without this extra 'g'

    #without rect scaling only works with mouse on nodes
    svg.append('svg:rect').attr("width", width)
       .attr("height", height)
       .attr("fill", 'white')

    links_group = svg.append("g").attr("class", "links")
    paths_group = svg.append("g").attr("class", "paths")
    nodes_group = svg.append("g").attr("class", "nodes")
    texts_group = svg.append("g").attr("class", "text")
    tooltip     = d3.select('body').append("div").attr("class", "tooltip")

    updateNetwork(data)

  return my_chart
