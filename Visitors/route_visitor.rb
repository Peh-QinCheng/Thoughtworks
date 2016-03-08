$LOAD_PATH << File.dirname('graph/graph.rb')
require 'graph'
require_relative 'visitor'

class RouteVisitor < Visitor

  attr_reader :start_town,:end_town,:max_dist,:nodes

  def initialize(start_town,end_town,max_dist)
    @start_town,@end_town,@max_dist = start_town,end_town,max_dist
  end

  def visit(graph)
    @nodes = graph.nodes
    get_routes(start_town,end_town,max_dist)
  end

private

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
    def get_routes(start_town,end_town,max_dist,recur_params=nil)
      #Initialize recursive variables if not provided
      current_dist,route,routes = process_params(start_town,0,recur_params)

      if current_dist >= max_dist
        routes
      else
        matching = (start_town == end_town && current_dist < max_dist && route.length > 1)
        routes.push route  if matching
        nodes[start_town].edges.each do |_,edge|
          new_route = route + edge.target
          new_dist = current_dist + edge.value
          recur_params = new_dist,new_route,routes
          get_routes(edge.target,end_town,max_dist,recur_params)
        end
      end

      routes.length
    end

    def process_params(start_town,max,recur_params)
      recur_params.nil? ? [max,start_town,[]] : recur_params
    end

end

g = Graph.new "input.txt"
v = RouteVisitor.new 'C','C',30
p g.accept v