
facts("Pruebas de las funciones de caminatas aleatorias") do
	srand(1)
	num_nodes = 10 ; num_neighs = 1 ; p = 0.1
	w = SmallWorldNet(num_nodes, num_neighs, p)

	node = 1 ; srand(1)
	@fact randomStep(w,node) --> 10

	num_iters = 5 ; srand(1)
	walk = randomWalk(w,node,num_iters)
	@fact walk --> [1, 10, 1, 2, 3]

	z = Net2D(w) ; site = (2,2) ; srand(1)
	@fact randomStep(z, site) --> (2,1)

	num_iters = 5 ; srand(1)
	walk = randomWalk(z, site, num_iters)
	@fact walk[1] --> site
	@fact walk[end] --> (2,7)

	# ------------------------------------- #
	# --- Funciones para dos caminantes --- #
	# ------------------------------------- #
	first_node = 1 ; second_node = 6 ; srand(1)
	@fact firstEncounter(w,first_node,second_node) --> 30

	num_iters = 5 ; srand(1)
	runs = runsFirstEncounter(w,first_node,second_node,num_iters)
	@fact runs --> [30, 8, 8, 4, 6]

	num_iters = 100 ; srand(1)
	@fact meanFE(w,first_node,second_node,num_iters) --> roughly( [10.8, 0.88]; atol = 1e-2)

	num_iters = 1; srand(1)
	@fact allFEfromOrigin(w,num_iters) --> [11  19  2  32  5  23  7  2  1]

	num_iters = 10 ; num_configs = 10 ; srand(1)
	meanFEconfigSpace(num_nodes, num_neighs, p, num_iters, num_configs, "test.jld")
	means = load("test.jld", "means")
	@fact means[1:4] --> roughly( [0.0, 4.36, 7.8, 10.31] ; atol=1e-2)


	# ------------------------------------- #
	# ----- Funciones para 1a llegada ----- #
	# ------------------------------------- #
	init_node = 1 ; target_node = 6 ; srand(1)
	@fact firstPassage(w,init_node,target_node) --> 33

	num_iters = 10 ; srand(1)
	runs = runsFirstPassage(w,init_node,target_node,num_iters)
	@fact length(runs) --> num_iters
	@fact runs[1] --> 33
	@fact runs[end] --> 46

	num_iters = 100 ; srand(1)
	@fact meanFP(w,init_node,target_node,num_iters) --> (4,23.07,1.6706772956686238)

	num_iters = 1; srand(1)
	@fact allFPfromOrigin(w,num_iters) --> [3 2 15 12 23 58 24 2 5]

	num_iters = 10 ; num_configs = 10 ; srand(1)
	meanFPconfigSpace(num_nodes, num_neighs, p, num_iters, num_configs, "test.jld")
	means = load("test.jld", "means")
	@fact means[1:4] --> roughly( [0.0, 7.33, 16.0, 18.52] ; atol = 1e-2)

end
