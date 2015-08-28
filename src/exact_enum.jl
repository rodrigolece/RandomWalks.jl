
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
    encountered = p1_vec .*p2_vec
    p = sum(encountered)

    # Actualizamos las posiciones
    p1_vec = exactEnum(w,p1_vec - encountered)
    # Falta un criterio de que la caminata es asíncrona
    p2_vec = exactEnum(w,p2_vec - encountered)

    p, p1_vec, p2_vec
end

function firstEncounterEE(w::SmallWorldNet, first_node::Int, second_node::Int, num_iters::Int)
    p_encounter = Array(Float64,num_iters)

    p1_vec = zeros(w.num_nodes) ; p1_vec[first_node] = 1.
    p2_vec = zeros(w.num_nodes) ; p2_vec[second_node] = 1.

    for iter in 1:num_iters
        p, p1_vec, p2_vec = exactEnum2D(w,p1_vec,p2_vec)
        p_encounter[iter] = p
    end

	# Descartamos primeras entradas que son cero ?
	# first_time, p_encounter = discardZeros(p_encounter)

	p_encounter
end

function firstEncounterEE(w::SmallWorldNet, first_node::Int, second_node::Int, num_iters::Int, file::String)
	dict = Dict{ASCIIString, Any}()
	dict["first_node"] = first_node
	dict["second_node"] = second_node
	dict["num_iters"] = num_iters
	dict["p_encounter"] = firstEncounterEE(w, first_node, second_node, num_iters)
	save(file, dict)
end

function meanFEEE(file::String)
	num_iters = load(file, "num_iters")
	p_encounter = load(file, "p_encounter")

    times = [1:num_iters]

    sum(times .* p_encounter)
end

function discardZeros(ps::Vector{Float64})
    i = 1

    while ps[i] == 0
        i += 1
    end

	# Al tomar elementos con slice, obtenemos Vector
    i, ps[i:end]
end
