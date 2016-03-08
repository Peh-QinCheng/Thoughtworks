$LOAD_PATH << File.dirname('graph/graph.rb')
require 'graph'
require_relative 'visitor'

class SDistVisitor < Visitor

  attr_reader :start_town,:end_town,:gp,:nodes

  def initialize(start_town,end_town)
    @start_town,@end_town = start_town,end_town
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
    @nodes = graph.nodes
    @gp = graph.gp
    get_sdist start_town,end_town
  end

private
    def get_sdist(start_town,end_town)
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
      queue.sort_by{|obj| obj.min_dist}.reverse!
      queue.pop
    end
end

g = Graph.new "input.txt"
v = SDistVisitor.new 'A','C'
p g.accept v