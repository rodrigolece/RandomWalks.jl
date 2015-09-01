
deg(w::SmallWorldNet, node::Int) = length(getNeighbours(w,node))

deg(z::Net2D, site::(Int,Int)) = length(z.neighbours[site])


function exactEnum2D(z::Net2D, p_mat::Array{Float64,2})
    new_p = zeros(p_mat)

    # Calculamos la proba de encuentro
    p = sum(diag(p_mat))

    # Extraemos esta probabilidad
    for ind in 1:z.num_nodes
        p_mat[ind,ind] = 0.
    end


    # Actualizamos las probabilidades

    for site in keys(z.neighbours)
        for neigh in z.neighbours[site]
            new_p[site...] += p_mat[neigh...]/deg(z,neigh)
        end
    end

    p, new_p
end

function firstEncounterEE(z::Net2D, first_node::Int, second_node::Int, num_iters::Int)
    p_encounter = Array(Float64,num_iters)

    # La condición inicial
    p_mat = zeros(z.num_nodes,z.num_nodes)
    p_mat[first_node,second_node] = 1.

    for iter in 1:num_iters
        p, p_mat = exactEnum2D(z, p_mat)
        p_encounter[iter] = p
    end

	# Descartamos primeras entradas que son cero ?

	p_encounter
end
