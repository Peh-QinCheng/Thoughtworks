$LOAD_PATH << File.dirname('graph/graph.rb')
require 'graph'
require_relative 'visitor'

class ExactVisitor < Visitor

  attr_reader :start_town,:end_town,:exac_limit,:nodes

  def initialize(start_town,end_town,exac_limit)
    @start_town,@end_town,@exac_limit = start_town,end_town,exac_limit
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
  def visit(graph)
    @nodes = graph.nodes
    unfiltered_routes = get_routes(start_town,end_town,exac_limit)
    routes = unfiltered_routes.select { |route| route.length == exac_limit+1}
    routes.length
  end

private

    def get_routes(start_town,end_town,max_limit,recur_params=nil)
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
          get_routes(edge_target,end_town,max_limit,recur_params)
        end
      end
      routes
    end

    def process_params(start_town,max,recur_params)
      recur_params.nil? ? [max,start_town,[]] : recur_params
    end
end

g = Graph.new "input.txt"
v = ExactVisitor.new "A","C",4
p g.accept v