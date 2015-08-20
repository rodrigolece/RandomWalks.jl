
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

function firstEncounterEE(w::SmallWorldNet, first_node::Int, second_node::Int, num_iters::Int)
    intrsct = Array(Float64, (w.num_nodes, num_iters))

    p1_vec = zeros(w.num_nodes) ; p1_vec[first_node] = 1.
    p2_vec = zeros(w.num_nodes) ; p2_vec[second_node] = 1.

    enum1 = iterExactEnum(w,p1_vec,num_iters+1)
    enum2 = iterExactEnum(w,p2_vec,num_iters)

    for iter in 1:num_iters
        # La camnata es asíncrona, las probas se calculan despúes de que el 1er caminanta da un paso
        intrsct[:,iter] = enum1[:,iter+1] .* enum2[:,iter]
    end

    # Suma sobre cada columna
    ps = sum(intrsct, 1)

	# Descartamos primeras entradas que son cero
	first_time, new_ps = discardZeros(ps)

	first_time, new_ps
end

function discardZeros(ps::Array{Float64,2})
    i = 1

    while ps[i] == 0
        i += 1
    end

    i, ps[i:end]
end
