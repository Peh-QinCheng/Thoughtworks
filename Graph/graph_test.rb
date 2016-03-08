require_relative 'graph'
require "test/unit"

class GraphTest < Test::Unit::TestCase
  attr_reader :graph
  
  def setup
    @graph = Graph.new 'input.txt'
  end

  def test_initialize
    assert_equal(5,graph.nodes.length)
    assert_equal(3,graph.nodes['A'].edges.length)
  end

  def test_get_distance
    dist = graph.get_distance "ABC"
    assert_equal 9, dist
  end

  def test_get_routes_max
    trips = graph.get_routes_max "C","C",3
    assert_equal 2, trips
  end

  def test_get_routes_exact
    trips = graph.get_routes_exact "A","C",4
    assert_equal 3, trips
  end

  def test_shortest_distance
    path_length = graph.shortest_distance "A","C" 
    assert_equal 9, path_length
  end

  def test_track_trips_routes
    routes = graph.track_trips_routes 'C','C',30
    assert_equal 7, routes
  end

end