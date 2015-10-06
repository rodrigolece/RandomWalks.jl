
facts("Pruebas de las funciones para calcular distancias") do
	srand(1)
	num_nodes = 10 ; num_neighs = 1 ; p = 0.1
	w = SmallWorldNet(num_nodes,num_neighs,p)

	distances = pathLengthsFromNode(w,1)
	@fact length(distances) --> num_nodes
	@fact distances[1] --> 0
	@fact distances[10] --> 1
	@fact distances[6] --> 4

	class = classifyWithDistance(w,1)
	@fact class[1] --> [1]
	@fact class[4] --> [4, 7, 8]
	@fact class[end] --> [5,6]

	all_paths = allPathLengths(w)
	@fact length(all_paths) --> 55
	@fact all_paths[(4,4)] --> 0
	@fact all_paths[(8,10)] --> 2
	@fact all_paths[(4,9)] --> 4

	hist_distances = pathLengthsHist(w)
	@fact length(hist_distances) --> 6
	@fact hist_distances[1] --> num_nodes
	@fact hist_distances[end] --> 1

	@fact avgPathLength(w) --> roughly(2.09 ; atol = 1e-2)

	@fact maxPathLength(w) --> 5


	num_nodes = 4 ; p = 0.
	w = SmallWorldNet(num_nodes, num_neighs, p)
	ds = pathLengths2D(w)
	@fact ds[:,1] --> [0, 1, 2, 1]
	@fact ds[:,3] --> [2, 1, 0, 1]
end
