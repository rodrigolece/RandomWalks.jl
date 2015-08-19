
facts("Pruebas de las funciones de caminatas aleatorias") do
	srand(1)
	num_nodes = 10 ; num_neighs = 1 ; p = 0.1
	w = SmallWorldNet(num_nodes, num_neighs, p)

	node = 1 ; srand(1)
	@fact randomStep(w,node) --> 10

	num_iters = 10 ; srand(1)
	walk = randomWalk(w,node,num_iters)
	@fact length(walk) --> num_iters + 1
	@fact walk[1] --> node
	@fact walk[end] --> 3

	# ------------------------------------- #
	# --- Funciones para dos caminantes --- #
	# ------------------------------------- #
	first_node = 1 ; second_node = 6 ; srand(1)
	@fact firstEncounter(w,first_node,second_node) --> 5

	num_iters = 10 ; srand(1)
	runs = runsFirstEncounter(w,first_node,second_node,num_iters)
	@fact length(runs) --> num_iters
	@fact runs[1] --> 5
	@fact runs[end] --> 3

	num_iters = 100 ; srand(1)
	@fact meanFE(w,first_node,second_node,num_iters) --> (4,10.88,0.7703180505413975)

	num_iters = 1; srand(1)
	@fact allFEfromOrigin(w,num_iters) --> [9 2 30 15 4 8 9 19 1]

# 	@fact meanFEfromOrigin

	num_iters = 10 ; num_configs = 10 ; srand(1)
	@fact meanFEConfigSpace(num_nodes,num_neighs,p,num_iters,num_configs) --> roughly([0.0,4.46,6.18,9.79,9.47,10.49,9.59,8.94,8.07,5.05])

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
	@fact meanFP(w,init_node,target_node,num_iters) --> (4,23.07,1.670677295668624)

	num_iters = 1; srand(1)
	@fact allFPfromOrigin(w,num_iters) --> [3 2 15 12 23 58 24 2 5]

# 	@fact meanFPfromOrigin

	num_iters = 10 ; num_configs = 10 ; srand(1)
	@fact meanFPConfigSpace(num_nodes,num_neighs,p,num_iters,num_configs) --> roughly([0.0, 7.33, 16.0, 18.52, 19.59, 26.04, 21.12, 19.5 , 14.88, 9.67])

end
