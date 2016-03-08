$LOAD_PATH << File.dirname('graph/graph.rb')
require 'graph'
require_relative 'visitor'

class DistVisitor < Visitor

  attr_reader :route

  def initialize(route)
    @route = route
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
  def visit(graph)
    dist = 0
    towns = route.split("")
    towns.each_cons(2) do |from,towards|
      edge_value = graph.nodes[from].find_edge(towards)
      if edge_value
        dist += edge_value
      else
        dist = "NO SUCH ROUTE"
        break
      end
    end
    dist
  end
end

g = Graph.new "input.txt"
v = DistVisitor.new 'ABC'
p g.accept v