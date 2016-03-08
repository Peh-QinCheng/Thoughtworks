
require_relative 'Node/node'
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

  def accept(visitor)
    visitor.visit self
  end

end
