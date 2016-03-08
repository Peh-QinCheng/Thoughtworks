require_relative 'Node/node'

class GraphParser
  
  attr_reader :graph_input

  #Public: Creates a GraphParser Object that parses a text file and makes a graph
  #
  #file - input text file
  #
  #Returns a GraphParser Object
  def initialize(file)
    # Assume text data in file is in one continuous line, with no linebreaks
    file = File.open file
    @graph_input = file.read
  end

  #Public: Make nodes and edges to form graph, using a string
  #
  #return a Hash of nodes
  def make_graph
    nodes = make_nodes(graph_input)
    make_edges(graph_input,nodes)
  end

private

    #Private: Create a hash of nodes mapped by their names
    #
    #graph_input - String containing edge information
    #
    #Return Hash of nodes
    def make_nodes(graph_input)
      nodes = Hash.new
      nodes_name = graph_input.gsub(/\W+/, '').gsub(/\d+/, '')
      nodes_name = nodes_name.split('').uniq
      nodes_name.each do |name|
        nodes[name] = Node.new(name)
      end
      nodes
    end 

    #Private: Add edges to nodes
    #
    #graph_input - String containing edge information
    #nodes - Hash of nodes in graph
    #
    #Return Nodes with edges
    def make_edges(graph_input,nodes)
      edges = graph_input.split(" ")
      edges.each do |edge|
        start_node = edge[0]
        target_node = edge[1]
        value = edge[2].to_i
        nodes[start_node].add_edge(target_node,value)
      end  
      nodes
    end

end
