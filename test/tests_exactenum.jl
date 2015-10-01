
facts("Pruebas de enumeración exacta") do
	# Para un anillo
	num_nodes = 4 ; num_neighs = 1 ; p = 0.
	w = SmallWorldNet(num_nodes, num_neighs, p)
	z = Net2D(w)

	first_node = 1 ; second_node = 3
	num_iters = 3
	@fact firstEncounterEE(z,first_node,second_node, num_iters) --> [0.0, 0.5, 0.25]

	# Para una red con atajos
	srand(1)
	num_nodes = 10 ; num_neighs = 1 ; p = 0.1
	w = SmallWorldNet(num_nodes, num_neighs, p)
	z = Net2D(w)

	first_node = 1 ; second_node = 5
	num_iters = 4
	f = firstEncounterEE(z,first_node,second_node, num_iters)
	@fact f--> roughly( [0.0, 0.0, 0.0798333, 0.0933169] ; atol=1e-7 )

	# meanFEEE
	t_max = 200
	@fact meanFEEE(z, first_node, second_node, t_max) --> roughly(12.0306418 ; atol=1e-7)

	# meanFEEEfromOrigin
	meanFEEEfromOrigin(z, t_max, "test.jld")
	means = load("test.jld", "means")
	@fact means[1:6] --> roughly( [0.0, 5.06627, 8.74031, 10.693, 12.0306, 12.0807] ; atol=1e-4)

	# meanFEEEcofigSpace
	srand(1)
	num_configs = 10
	meanFEEEconfigSpace(num_nodes, num_neighs, p, t_max, num_configs, "test.jld")
	means = load("test.jld", "means")
	@fact means[1:6] --> roughly( [0.0, 5.03194, 8.44537, 9.73777, 11.2605, 11.6439] ; atol=1e-4)

end
