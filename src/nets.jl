
## El tipo SmallWorldNet con el constructor básico ----- ##
type SmallWorldNet
    num_nodes::Int
    num_neighs::Int
	# La probabilidad con la que se hacen uniones de largo alcance
    p::Float64
    neighbours::Vector{Vector{Int}}

    function SmallWorldNet(num_nodes::Int)
        neighbours = Array(Vector{Int},num_nodes)
        fill!(neighbours, [])
        new(num_nodes, 0, 0., neighbours)
    end
end

show(io::IO, w::SmallWorldNet) = println(io, "Nodes:$(w.num_nodes) Neighs:$(w.num_neighs) p:$(w.p)")


# Las funciones de la red --------------------------- ##

function hasNode(w::SmallWorldNet, n::Int)
    n <= length(w.neighbours) ? true : false
end

function addNode!(w::SmallWorldNet)
    push!(w.neighbours, [])
end

# function getNodes(w::SmallWorldNet)
#     [1:length(w.neighbours)]
# end

function getNeighbours(w::SmallWorldNet, n::Int)
    w.neighbours[n]
end

function addEdge!(w::SmallWorldNet, n1::Int, n2::Int)
    if n1 == n2
        #print("Only one node given: ",n1)
        return
    elseif n2 in getNeighbours(w, n1)
        #print("Edge already defined")
        return
    else
        push!(w.neighbours[n1], n2)
        push!(w.neighbours[n2], n1)
    end
end


## El constructor completo-------------------------- ##

function addNeighbourEdges!(w::SmallWorldNet)
    for n in 1:w.num_nodes
		vecinos_cada_lado = div(w.num_neighs, 2)

		# Vecinos a la izquierda
        for n2 in n - vecinos_cada_lado:n-1
            addEdge!(w, n, mod1(n2,w.num_nodes))
        end

		# Vecinos a la derecha
		for n2 in n+1:n+vecinos_cada_lado
			addEdge!(w, n, mod1(n2,w.num_nodes))
		end
    end
end

function addRandomEdges!(w::SmallWorldNet)
    cont = 1.
    while cont <= w.p*w.num_nodes*w.num_neighs/2
        n1 = rand(1:w.num_nodes)
        n2 = rand(1:w.num_nodes)
        if n1 != n2
            addEdge!(w, n1, n2)
            cont += 1
        end
    end
end

function SmallWorldNet(num_nodes::Int, num_neighs::Int, p::Float64)
    w = SmallWorldNet(num_nodes)
    w.num_neighs = num_neighs
    w.p = p

    addNeighbourEdges!(w)
    addRandomEdges!(w)

    return w
end

## La función para agregar a un nodo como su vecino, para caminatas "flojas"-------------------- ##
# Se usa tramposamente como constructor, la mayúscula es un abuso de notación

function SmallWorldNetWithNoStep(w::SmallWorldNet)
    w_lazy = SmallWorldNet(w.num_nodes)
    for i in 1:w_lazy.num_nodes
        w_lazy.neighbours[i] = [w.neighbours[i]..., i]
    end
    return w_lazy
end
