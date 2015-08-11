using FactCheck

using RandomWalks

facts("Pruebas de las funciones para calcular distancias") do
	srand(1)
	num_nodes = 10 ; num_neighs = 2 ; p = 0.1
	w = SmallWorldNet(num_nodes,num_neighs,p)

	distances = pathLengthsFromNode(w,1)
	@fact length(distances) --> num_nodes
	@fact distances[1] --> 0
	@fact distances[10] --> 1
	@fact distances[6] --> 4

	hist_distances = pathLengthsHist(w)
	@fact length(hist_distances) --> 6
	@fact hist_distances[1] --> num_nodes
	@fact hist_distances[end] --> 1

	@fact avgPathLength(w) --> 2.090909090909091

	@fact maxPathLength(w) --> 4
end
