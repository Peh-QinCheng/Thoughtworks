require_relative 'node'
require_relative 'graph_parser'

class Graph

  attr_reader :nodes, :gp


  #Public: Make a new graph object given a text file
  #
  #file - provided text file
  #
  #Returns a graph object
  def initialize(file)
    @gp = GraphParser.new file
    @nodes = gp.make_graph
  end

  #Public: Get total distance of specified route
  #
  #route_input - string containing nodes to visit
  #
  #Example
  #  get_distance('ABC')
  #  # => 9
  #
  #Returns total distance of specified route
  def get_distance(route_input)
    dist = 0
    towns = route_input.split("")

    towns.each_cons(2) do |from,towards|
      edge_value = nodes[from].find_edge(towards)
      if edge_value
        dist += edge_value
      else
        dist = "NO SUCH ROUTE"
        break
      end
    end
    dist
  end


  #Public: Track graph and return trips with specified maximum length,start point and end point
  #
  #start_town - node to start from
  #end_town - node to end with
  #max_limit - maximum number of nodes to traverse, excluding starting node
  #recur_params - parameters used for recursion:
  #  current_limit - current number of nodes traversed
  #  route - string containing name of all nodes traversed
  #  routes - array containing currently collected satisfying routes
  #
  #Examples
  #  def get_routes_max('C','C',3)
  #  # => 2
  #
  #Returns array of all satisfying routes
  def get_routes_max(start_town,end_town,max_limit,recur_params=nil)
    routes = get_routes(start_town,end_town,max_limit,recur_params)
    routes.length
  end

  #Public: Track graph and return trips with specified exact length,start point and end point
  #
  #Parameters are identical to get_routes_max
  #
  #Examples
  #  def track_trips_exact('A','C',3)
  #  # => 3
  #
  #Returns array of all satisfying routes
  def get_routes_exact(start_town,end_town,exac_limit,recur_params=nil)
    unfiltered_routes = get_routes(start_town,end_town,exac_limit,recur_params)
    routes = unfiltered_routes.select { |route| route.length == exac_limit+1}
    routes.length
  end

  #Public: Track graph and return routes with specified start point and end point, with total
  #        distance less than specified distance
  #
  #start_town - node to start from
  #end_town - node to end with
  #max_dist - maxmimum total distance of nodes traversed
  #recur_params - parameters used for recursion:
  #  current_dist - current total distance of nodes traversed
  #  route - string containing name of all nodes traversed
  #  routes - array containing currently collected satisfying routes
  #
  #Examples
  #  def track_trips_routes('A','C',20)
  #  # => 5
  #
  #Returns number of satisfying routes
  def track_trips_routes(start_town,end_town,max_dist,recur_params=nil)

    #Initialize recursive variables if not provided
    current_dist,route,routes = process_params(start_town,0,recur_params)

    if current_dist >= max_dist
      routes
    else
      matching = (start_town == end_town && current_dist < max_dist && route.length > 1)
      if matching
        routes.push route
      end    
      nodes[start_town].edges.each do |_,edge|
        new_route = route + edge.target
        new_dist = current_dist + edge.value
        recur_params = new_dist,new_route,routes
        track_trips_routes(edge.target,end_town,max_dist,recur_params)
      end
    end

    routes.length
  end

  #Public: Find the shortest path from specified start_town to end_town
  #
  #start_town - node to start from
  #end_town - node to end with
  #
  #Example
  #  shortest_distance('A','C')
  #  # => 9
  #
  #Returns value of shortest path
  def shortest_distance(start_town,end_town)

    temp_nodes,queue,visited = init_dijkstra(start_town)

    while visited.length < temp_nodes.length
      current = extract_min(queue)
      visited.push current

      visited.delete temp_nodes[start_town] if start_town == end_town

      current.edges.each do |edge_target, edge|
        node = temp_nodes[edge_target]

        new_dist = edge.value + current.min_dist
        if node.min_dist > new_dist || node.min_dist == 0
          node.min_dist = edge.value + current.min_dist
        end
        if !(queue.include? node) || !(visited.include? node)
          queue.push node
        end

      end
    end
    temp_nodes[end_town].min_dist
  end

private

    def get_routes(start_town,end_town,max_limit,recur_params)
      #Initialize recursive variables if not provided
      current_limit,route,routes = process_params(start_town,max_limit,recur_params)

      if current_limit < 0
        routes
      else
        matching = (start_town == end_town && current_limit < max_limit && route.length > 1)
        if matching
          routes.push route
        end
        nodes[start_town].edges.each do |edge_target,_|
          new_route = route + edge_target
          recur_params = current_limit - 1,new_route,routes
          get_routes_max(edge_target,end_town,max_limit,recur_params)
        end
      end
      routes
    end

    #Private: Initialize parameters required by recursion if none
    #
    #start_town - node to start from
    #max - maximum distance or limit
    #recur_params - params required by recursion, as described in respective methods
    #
    #Returns recursive parameters
    def process_params(start_town,max,recur_params)
      if recur_params.nil?
        [max,start_town,[]]
      else
        [recur_params[0],recur_params[1],recur_params[2]]
      end
    end

    #Private: Initialize queues and duplicate graph for Dijkstra's algorithm
    #
    #start_town - node to start from
    #
    #Example
    #  def init_dijkstra('A')
    #  # => [Hash_containing_nodes,queue_array,visited_array]
    #
    #Returns:
    #
    #temp_nodes - duplicate of graph
    #queue - array with start_town inserted
    #visited - array to contained visited nodes 
    def init_dijkstra(start_town)
      temp_nodes = gp.make_graph
      temp_nodes.each do |name,node|
        node.min_dist = Float::INFINITY
      end
      temp_nodes[start_town].min_dist = 0
      queue = [].push temp_nodes[start_town]
      visited = []
      return temp_nodes,queue,visited
    end

    #Private: Retrieve highest priority node in priority queue
    #
    #queue - priority queue
    #
    #Example
    #  def extract_min(queue)
    #  # => node_object 
    #Returns highest priority node object
    def extract_min(queue)
      sorted_q = queue.sort_by {|obj| obj.min_dist}
      sorted_q.reverse!
      queue.pop
    end

end
