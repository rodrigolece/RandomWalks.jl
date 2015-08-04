module Nets

export SmallWorldNet#, SmallWorldNetWithNoStep
# export hasNode, addNode!, addEdge!, getNeighbours

## El tipo SmallWorldNet con el constructor básico ----- ##
type SmallWorldNet
    num_nodes::Int64
    num_neighs::Int64
	# La probabilidad con la que se hacen uniones de largo alcance
    p::Float64
    neighbours::Vector{Vector{Int64}}

    function SmallWorldNet(num_nodes::Int64)
        neighbours = Array(Vector{Int64},num_nodes)
        fill!(neighbours, [])
        new(num_nodes, 0, 0., neighbours)
    end
end

import Base.show

show(io::IO, w::SmallWorldNet) = println(io, "Nodes:$(w.num_nodes) Neighs:$(w.num_neighs) p:$(w.p)")


## Las funciones de la red --------------------------- ##

# function hasNode(w::SmallWorldNet, n::Int64)
#     n <= length(w.neighbours) ? true : false
# end

# function addNode!(w::SmallWorldNet)
#     push!(w.neighbours, [])
# end

# # function getNodes(w::SmallWorldNet)
# #     [1:length(w.neighbours)]
# # end

# function getNeighbours(w::SmallWorldNet, n::Int64)
#     w.neighbours[n]
# end

# function addEdge!(w::SmallWorldNet, n1::Int64, n2::Int64)
#     if n1 == n2
#         #print("Only one node given: ",n1)
#         return
#     elseif n2 in getNeighbours(w, n1)
#         #print("Edge already defined")
#         return
#     else
#         push!(w.neighbours[n1], n2)
#         push!(w.neighbours[n2], n1)
#     end
# end


# ## El constructor completo-------------------------- ##

# function addNeighbourEdges!(w::SmallWorldNet)
# 	# Esto se cambia con mod1
#     modulo = Dict{Int64,Int64}()
#     for i in 0:w.num_nodes-1
#         modulo[-i] = w.num_nodes - i
#         modulo[i+1] = i+1
#         modulo[w.num_nodes+i] = i
#     end

#     for n in 1:w.num_nodes
#         rango = [n - div(w.num_neighs,2):n-1, n+1:n + div(w.num_neighs,2)]
#         traducido = [modulo[t] for t in rango]
#         for n2 in traducido
#             AddEdge!(w, n, n2)
#         end
#     end
# end

# function addRandomEdges!(w::SmallWorldNet)
#     cont = 1.
#     while cont <= w.p*w.num_nodes*w.num_neighs/2
#         n1 = rand(1:w.num_nodes)
#         n2 = rand(1:w.num_nodes)
#         if n1 != n2
#             AddEdge!(w, n1, n2)
#             cont += 1
#         end
#     end
# end

# function SmallWorldNet(num_nodes::Int64, num_neighs::Int64, p::Float64)
#     w = SmallWorldNet(num_nodes)
#     w.num_neighs = num_neighs
#     w.p = p

#     AddNeighbourEdges!(w)
#     AddRandomEdges!(w)

#     return w
# end

# ## La función para agregar a un nodo como su vecino, para caminatas "flojas"-------------------- ##
# # Se usa tramposamente como constructor, la mayúscula es un abuso de notación

# function SmallWorldNetWithNoStep(w::SmallWorldNet)
#     wc = SmallWorldNet(w.num_nodes)
#     for i in 1:w.num_nodes
#         wc.neighbours[i] = push!([copy(w.neighbours[i])...],i)
#     end
#     return wc
# end

end
