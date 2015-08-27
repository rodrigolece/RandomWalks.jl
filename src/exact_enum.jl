
deg(w::SmallWorldNet, node::Int) = length(getNeighbours(w,node))

function exactEnum(w::SmallWorldNet, p_vec::Vector{Float64})
    new_p = zeros(w.num_nodes)

    for node in 1:w.num_nodes
        for neigh in getNeighbours(w,node)
            new_p[node] += p_vec[neigh]/deg(w,neigh)
        end
    end

    new_p
end

function iterExactEnum(w::SmallWorldNet, p0_vec::Vector{Float64}, num_iters::Int)
    out = Array(Float64, (w.num_nodes, num_iters))
    out[:,1] = p0_vec

    for i in 2:num_iters
        out[:,i] = exactEnum(w,out[:,i-1])
    end

    out
end

function exactEnum2D(w::SmallWorldNet, p1_vec::Vector{Float64}, p2_vec::Vector{Float64})
    p_mat = p1_vec*p2_vec'

    encountered = diag(p_mat)
    p = sum(encountered)

    # Actualizamos las posiciones
    p1_vec = exactEnum(w,p1_vec - encountered)
    # Falta un criterio de que la caminata es asíncrona
    p2_vec = exactEnum(w,p2_vec - encountered)

    p, p1_vec, p2_vec
end

function firstEncounterEE(w::SmallWorldNet, first_node::Int, second_node::Int, num_iters::Int)
    out = Array(Float64,num_iters)

    p1_vec = zeros(w.num_nodes) ; p1_vec[first_node] = 1.
    p2_vec = zeros(w.num_nodes) ; p2_vec[second_node] = 1.

    for iter in 1:num_iters
        p, p1_vec, p2_vec = exactEnum2D(w,p1_vec,p2_vec)
        out[iter] = p
    end

	# Descartamos primeras entradas que son cero?

    out
end

function discardZeros(ps::Array{Float64,2})
    i = 1

    while ps[i] == 0
        i += 1
    end

	# Al tomar elementos con slice, obtenemos Vector
    i, ps[i:end]
end
