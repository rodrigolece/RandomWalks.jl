using FactCheck

using Nets
using RandomWalks

facts("Pruebas de las funciones de caminatas aleatorias") do
	srand(1)
	num_nodes = 10 ; num_neighs = 2 ; p = 0.1
	w = SmallWorldNet(num_nodes, num_neighs, p)

	node = 1 ; srand(1)
	@fact randomStep(w,node) --> 10

	num_iters = 10 ; srand(1)
	walk = randomWalk(w,node,num_iters)
	@fact length(walk) --> num_iters + 1
	@fact walk[1] --> node
	@fact walk[end] --> 3

	# Funciones para 2 caminantes
	first_node = 1 ; second_node = 6 ; srand(1)
	@fact randomWalk2(w,first_node,second_node) --> 5

	num_iters = 10 ; srand(1)
	runs = runsRandom2(w,first_node,second_node,num_iters)
	@fact length(runs) --> num_iters
	@fact runs[1] --> 5
	@fact runs[end] --> 3

	num_iters = 100 ; srand(1)
	@fact avgRandomWalk2(w,first_node,second_node,num_iters) --> (4,10.88,0.7703180505413975)

	# Funciones para primera llegada
	init_node = 1 ; target_node = 6 ; srand(1)
	@fact randomWalkUntil(w,init_node,target_node) --> 33

	num_iters = 10 ; srand(1)
	runs = runsUntil(w,init_node,target_node,num_iters)
	@fact length(runs) --> num_iters
	@fact runs[1] --> 33
	@fact runs[end] --> 46

	num_iters = 100 ; srand(1)
	@fact avgRandomWalkUntil(w,init_node,target_node,num_iters) --> (4,23.07,1.670677295668624)
end