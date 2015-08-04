using FactCheck

using Nets

facts("Pruebas del módulo Nets") do
	# Deberíamos de cambiar el tipo para que funcione con p = 0
	num_nodes = 10 ; num_neighs = 2 ; p = 0.
	w = SmallWorldNet(num_nodes, num_neighs, p)

	@fact length(w.neighbours) --> num_nodes
	@fact length(getNeighbours(w,1)) --> num_neighs

	# Pruebas de la condición de frontera cíclica
	@fact 2 in getNeighbours(w,1) --> true
	@fact num_nodes in getNeighbours(w,1) --> true
end