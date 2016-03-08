$LOAD_PATH << File.dirname('graph/graph.rb')
require 'graph'
require_relative 'visitor'

class MaxVisitor < Visitor

  attr_reader :start_town,:end_town,:max_limit,:nodes

  def initialize(start_town,end_town,max_limit)
    @start_town,@end_town,@max_limit = start_town,end_town,max_limit
  end

  def visit(graph)
    @nodes = graph.nodes
    routes = get_routes(start_town,end_town,max_limit)
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
v = MaxVisitor.new 'C','C',3
p g.accept v