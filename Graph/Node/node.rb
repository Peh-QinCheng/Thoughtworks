require_relative 'edge'

class Node

  attr_reader :name, :edges, :min_dist
  attr_writer :min_dist

  #Public: Create a Node object that contains its name and a hash collection of its edges
  #
  #name - name of node
  #
  #Returns a Node object
  def initialize(name)
    @name = name
    @edges = Hash.new
  end

  #Public: Finds the value of the edge pointing to the target node specified
  #
  #target_node - name of target node
  #value - value of edge
  #
  #Returns value of edge
  def add_edge(target_node,value)
    edges[target_node] = Edge.new(target_node,value)
  end

  def find_edge(target)
    if edges[target]
      edges[target].value
    else
      false
    end
  end

end