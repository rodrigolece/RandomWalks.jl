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

	n1 = 1 ; n2 = 5
	addEdge!(w,n1,n2)
	@fact n1 in getNeighbours(w,n2) --> true
	@fact n2 in getNeighbours(w,n1) --> true

	# Prueba del constructor con uniones aleatorias
	p = 0.1
	srand(1)
	w = SmallWorldNet(num_nodes, num_neighs, p)
	@fact 9 in getNeighbours(w,7) --> true
end
