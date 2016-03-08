require_relative 'Graph/graph'

graph = Graph.new "input.txt"

#Output 1
#Usage: 'get_routes_max(route_as_a_string)'
op1 = graph.get_distance 'ABC'
p 'Output #1: ' + op1.to_s

#Output 2
op2 = graph.get_distance 'AD'
p 'Output #2: ' + op2.to_s

#Output 3
op3 = graph.get_distance 'ADC'
p 'Output #3: ' + op3.to_s

#Output 4
op4 = graph.get_distance 'AEBCD'
p 'Output #4: ' + op4.to_s

#Output 5
op5 = graph.get_distance 'AED'
p 'Output #5: ' + op5.to_s

#Output 6 
#Usage: 'get_routes_max(start_town, end_town, max_no_of_nodes)'
op6 = graph.get_routes_max 'C','C',3
p 'Output #6: ' + op6.to_s

#Output 7
op7 = graph.get_routes_exact 'A','C',4
p 'Output #7: ' + op7.to_s

#Output 8
#Usage: 'shortest_distance(start_town, end_town)'
op8 = graph.shortest_distance 'A','C'
p 'Output #8: ' + op8.to_s

#Output 9
#Usage: 'shortest_distance(start_town, end_town)'
op9 = graph.shortest_distance 'B','B'
p 'Output #9: ' + op9.to_s

#Output 10
#Usage: 'track_trips_routes(start_town, end_town,max_distance)'
op10 = graph.track_trips_routes 'C', 'C', 30
p 'Output #10: ' + op10.to_s
