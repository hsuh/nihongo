#implement pie chart as closure with get-set methods
return if (typeof(d3) == 'undefined')
d3.pie  = {}
d3.pie  = pie = () ->
  svg         = null
  data        = []
  funcs       = null
  width       = 500 #default width and height
  height      = 400
  net         = null
  click_count = 0
  expand      = {}
  radius      = Math.min(width, height) /2
  tooltips    = null
  #force_graph    = d3.inner_force_graph()
  slice_selected = false
  selection = ''
  #color   = d3.scale.category10()
  color   = {0:"#8bb9d0",1:"#659941" ,2:"#ea9639", 3: "#cb6698", 4: "#036597", 5: "#BC5D58", 6: "#BAB86C"}
  arc     = d3.svg.arc().outerRadius(radius - 15)
              .innerRadius(0) #this will create <path> elems for us using arc data
  arcOver = d3.svg.arc().outerRadius(radius + 5)

  onMouseOver = (d) ->
    if not slice_selected
      slice = d3.select(this)
      slice.attr("opacity", 1)
      slice.transition()
        .duration(500)
        .attr("d", arcOver)

  onMouseOut = (d) ->
    slice = d3.select(this)
    $(slice[0][0].nextElementSibling).attr("display", "none")
    slice.transition()
      .duration(500)
      .attr("d", arc)

  onMouseDblClick = (d) ->
    funcs.show_cluster()

  onMouseClick = (d) ->
    #highlight the slice
    slice_selected = true
    slice        = d3.select(this)
    slice_color  = slice.attr('fill')
    arcs         = svg.selectAll('path') #select all g's with class slice
    arcs.attr("opacity", .5)
    arcs.attr("stroke", "")
    slice.attr("opacity", 1)
    slice.attr("stroke", "#911e16")
    slice.attr('stroke-width', 2)
    slice.attr('stroke-opacity', 0.5)
    funcs.apply(d.data)

  updatePie = () ->
    slice_selected = true
    arcs = d3.selectAll('path')
    slice = arcs.filter((d,i) ->
      d.data.group == data.selected_cluster.group
    )
    arcs.attr("opacity", .4)
    arcs.attr("stroke", "")
    slice.attr("opacity", 1)
    slice.attr("stroke", "#000000")

  my_chart = () ->

  my_chart.config = (_selection, _data, _funcs) ->
    selection = _selection
    data = _data
    funcs = _funcs
    return this

  my_chart.reposition = (direction) ->
    if direction == 'down'
      d3.select('svg').style('margin-top', '50px')
    if direction == 'up'
      d3.select('svg').style('margin-top', '0px')

  my_chart.render = () ->
    if(!data) then return
    data.update_chart = updatePie
    clusters = data.cluster_data.clusters
    pie  = d3.layout.pie()
            .value((d) -> return d.user_count)

    svg  = d3.select(selection).append("svg")
             .attr("width", width)
             .attr("height", height)
             .append("svg:g") #make a group to hold pie chart
             #move the centre of the pie-chart
             .attr("transform", "translate(" + width * 0.4 + "," + height/2 + ")")

    arcs = svg.selectAll("g.slice") #select all g's with class slice
             .data(pie(clusters)) #associate data, array of arcs startAngle, EndAngle, value
             .enter()
             .append("svg:g") #create a group to hold each slice
             .attr("class", "slice")

    arcs.append("svg:path")
        .attr("fill", (d,i) -> return color[i])
        .attr("d", arc) #creates svg path using associated data(pie)
        .on("mouseover", onMouseOver)
        .on("mouseout", onMouseOut)
        .on("click", onMouseClick)
        .on("dblclick", onMouseDblClick)

    arcs.append("svg:text")
        .attr("transform", (d) -> return "translate(" + arc.centroid(d) + ")")
        .attr("text-anchor", "middle")
        .attr("dy", ".35em")
        .attr("display", "none")
        .text((d,i) -> return d.data.user_count)

    tooltips = d3.selectAll('path')
      .append('title')
        .classed('tooltip', true)
        .text(() -> return 'Double click to see inside cluster')

  return my_chart
