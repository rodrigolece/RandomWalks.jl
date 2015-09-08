
deg(w::SmallWorldNet, node::Int) = length(getNeighbours(w,node))

deg(z::Net2D, site::(Int,Int)) = length(z.neighbours[site])


function exactEnum2D(z::Net2D, p_mat::Array{Float64,2}, old_p_mat::Array{Float64,2})
    # Calculamos la proba de encuentro
    p = sum(diag(p_mat))

    # Extraemos esta probabilidad
    for ind in 1:z.num_nodes
        p_mat[ind,ind] = 0.
    end


    # Actualizamos las probabilidades

    for (site, neighs) in z.neighbours
        contribution = p_mat[site...]/deg(z,site)
        p_mat[site...] = 0.

        for neigh in neighs
            # Estamos suponiendo que old_p_mat siempre es un arreglo de ceros
            old_p_mat[neigh...] += contribution
        end

    end

    # Se hace el swap de las matrices
    p, old_p_mat, p_mat
end

function firstEncounterEE(z::Net2D, first_node::Int, second_node::Int, num_iters::Int)
    p_encounter = Array(Float64,num_iters)

    # La condición inicial
    p_mat = zeros(z.num_nodes,z.num_nodes)
    p_mat[first_node,second_node] = 1.

    old_p_mat = zeros(p_mat)

    for iter in 1:num_iters
        p, p_mat, old_p_mat = exactEnum2D(z, p_mat, old_p_mat)
        p_encounter[iter] = p
    end

	p_encounter, p_mat
end
