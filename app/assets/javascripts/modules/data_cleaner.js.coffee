# data cleaning functions for network
this.dataCleaner    = dataCleaner = () ->
dataCleaner.cleaner = module = ->
  data        = null

  cleaner = () ->

  #Return the node given user_id
  filterNode = (user_id) ->
    return (node) ->
      if node.user_id == user_id then return node

  #Return the cluster given group number
  filterFunc = (group_num) ->
    return (cluster) ->
      if cluster.group == group_num then return cluster

  #get node objects for links objects' source and target
  #e.g. link = {source: '4', target: '5'} becomes
  #link = {source: {'user_id':4, name:'John'}, target: {'user_id':5, 'name':'Morag'a}}
  getNodesForLinkSourceAndTarget = (data) ->
    $.each data.links, (k, link) ->
      link.source = data.nodes.filter(filterNode(link.source))[0]
      link.target = data.nodes.filter(filterNode(link.target))[0]

  #if the link is from the same cluster/group
  #add the link to clusters' link[] array
  #assign the group number property for that link
  nodeAndLinkCountPerGroup = () ->
    cluster_links = []
    $.each data.clusters, (k, v) ->
      v.links = []
      v.nodes = []

    $.each data.links, (k,link) ->
      group_num = link.source.group
      if link.source.group == link.target.group
        link.group = link.source.group
        data.clusters.filter(filterFunc(group_num))[0].links.push(link)
      else
        link.group = 'null'

    $.each data.nodes, (k,node) ->
      data.clusters.filter(filterFunc(node.group))[0].nodes.push(node)

  #get cluster number
  getGroup = (n) ->
    if n != undefined
      return n.group

  #links between clusters
  interClusterLinks = () ->
    lm                 = {}
    data.cluster_links = []

    $.each data.links, (k,link) ->
      link = data.links[k]
      s_g  = getGroup(link.source)
      t_g  = getGroup(link.target)

      if s_g != t_g
        group_pair = if (s_g < t_g) then (s_g + "|" + t_g) else (t_g + "|" + s_g)
        l = lm[group_pair] || (lm[group_pair]= {"source": s_g, "target": t_g, "link_size": 0})
        l.link_size += 1

    for l of lm
      lm[l].source = data.clusters.filter(filterFunc(lm[l].source))[0]
      lm[l].target = data.clusters.filter(filterFunc(lm[l].target))[0]
      data.cluster_links.push(lm[l])


  cleaner.prepareData = () ->
    if data == null then return
    getNodesForLinkSourceAndTarget(data)

    #Get connected nodes(friends) for each node
    $.each data.nodes, (k, node_obj) ->
      node_obj.total_connections   = 0
      node_obj.inner_connections = []
      node_obj.outer_connections = []
      $.each data.links, (k, link) ->
        if link.source and link.target
          lsource = link.source; ltarget = link.target
          if lsource == node_obj
            node_obj.total_connections += 1
            if (lsource.group == ltarget.group)
              node_obj.inner_connections.push(ltarget)
            else
              node_obj.outer_connections.push(ltarget)

          if ltarget == node_obj
            node_obj.total_connections += 1
            if (lsource.group == ltarget.group)
              node_obj.inner_connections.push(lsource)
            else
              node_obj.outer_connections.push(lsource)
        else
          console.log('link objects need to have source and target ids- check Tomcat data')
          return

    #sort the nodes by degree
    data.nodes.sort((a,b) -> return (b.total_connections - a.total_connections))

    nodeAndLinkCountPerGroup()
    interClusterLinks()

    console.log('data', data)
    return data

  cleaner.data = (_data) ->
    if(!arguments.length) then return data
    data = _data
    return this

  return cleaner
