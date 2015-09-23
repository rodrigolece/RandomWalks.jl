
facts("Pruebas del módulo Nets") do
	num_nodes = 10 ; node = 1
	w = SmallWorldNet(num_nodes)
	@fact length(w.neighbours) --> num_nodes
	@fact getNeighbours(w,node) --> Vector{Int}[]

	w_lazy = SmallWorldNetWithNoStep(w)
	@fact length(w_lazy.neighbours) --> num_nodes
	@fact getNeighbours(w_lazy,node) --> [node]

	# Deberíamos de cambiar el tipo para que funcione con p = 0
	num_neighs = 1 ; p = 0.
	w = SmallWorldNet(num_nodes, num_neighs, p)

	@fact length(w.neighbours) --> num_nodes
	@fact length(getNeighbours(w,node)) --> 2*num_neighs

	# Pruebas de la condición de frontera cíclica
	@fact 2 in getNeighbours(w,1) --> true
	@fact num_nodes in getNeighbours(w,node) --> true

	n1 = 1 ; n2 = 5
	addEdge!(w,n1,n2)
	@fact n1 in getNeighbours(w,n2) --> true
	@fact n2 in getNeighbours(w,n1) --> true

	# Prueba del constructor con uniones aleatorias
	p = 0.1
	srand(1)
	w = SmallWorldNet(num_nodes, num_neighs, p)
	@fact 9 in getNeighbours(w,7) --> true

	# Pruebas de Net2D
	num_nodes = 3 ; num_neighs = 1 ; p = 0.
	w = SmallWorldNet(num_nodes, num_neighs, p)
	@fact deg(w, 1) --> 2*num_neighs

	z = Net2D(w) ; site = (2,2)
	@fact z.num_nodes --> num_nodes
	@fact z.neighbours[site...] --> [(1,2), (3,2), (2,1), (2,3)]
	@fact z.degrees[site...] --> deg(z,site)
end
