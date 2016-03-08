class Node
  class Edge

    attr_reader :target, :value

    #Public: Create an edge object to store edge target and value
    #
    #target - name of target node that edge is pointing to
    #value - value of edge
    #
    #Returns and edge object
    def initialize(target,value)
      @target = target
      @value = value
    end

  end
end