
facts("Pruebas de enumeración exacta") do
	# Para una red pequeña
	num_nodes = 4 ; num_neighs = 1 ; p = 0.
	w = SmallWorldNet(num_nodes, num_neighs, p)
	z = Net2D(w)

	first_node = 1 ; second_node = 3
	num_iters = 3
	@fact firstEncounterEE(z,first_node,second_node, num_iters) --> [0.0, 0.5, 0.25]

	# Para una red grande
	srand(1)
	num_nodes = 100 ; num_neighs = 1 ; p = 0.1
	w = SmallWorldNet(num_nodes, num_neighs, p)
	z = Net2D(w)

	first_node = 1 ; second_node = 34
	num_iters = 10
	f = firstEncounterEE(z,first_node,second_node, num_iters)
	@fact f[end-2:end] --> roughly( [0.0, 4.52112e-6, 2.26684e-5] ; atol=1e-5 )

	# meanFEEE
	t_max = 1000
	@fact meanFEEE(z, first_node, second_node, t_max) --> roughly(554.385; atol=1e-3)
end
