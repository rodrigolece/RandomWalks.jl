
function exactEnum2D(z::Net2D, p_mat::Array{Float64,2}, old_p_mat::Array{Float64,2})
	nn = z.num_nodes
    # Calculamos la proba de encuentro
    p = sum(diag(p_mat))

    # Extraemos esta probabilidad
    for ind in 1:nn
        p_mat[ind,ind] = 0.
    end


    # Actualizamos las probabilidades

    for site_i in 1:nn, site_j in 1:nn
        contribution = p_mat[site_i,site_j] / z.degrees[site_i,site_j]
        p_mat[site_i,site_j] = 0.

        for neigh in z.neighbours[site_i,site_j]
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

	p_encounter#, p_mat
end

function meanFEEE(z::Net2D, first_node::Int, second_node::Int, t_max)
    # Las primeras probas se calculan con enumeración exacta
    times = 1:t_max

#     distrib , p_mat = firstEncounterEE(z, first_node, second_node, t_max)
    distrib = firstEncounterEE(z, first_node, second_node, t_max)

    # Y lo que queda es la cola exponencial

    α = 1/10*log(distrib[t_max-10]/distrib[t_max])
    tail = distrib[t_max]*( t_max/α + 1/α^2 )

    τ = sum(times .* distrib) + tail
end


function meanFEEEfromOrigin(z::Net2D, t_max::Int)
    out = Array(Float64, z.num_nodes)
    out[1] = 0.

    first_node = 1

    for second_node in 2:z.num_nodes
        out[second_node] = meanFEEE(z, first_node, second_node, t_max)
    end

    out
end

function meanFEEEfromOrigin(z::Net2D, t_max::Int, file::String)
    dict = Dict{ASCIIString, Any}()
    dict["num_nodes"] = z.num_nodes
    dict["t_max"] = t_max
    dict["means"] = meanFEEEfromOrigin(z, t_max)
    save(file, dict)
end


function meanFEEEconfigSpace(num_nodes::Int, num_neighs::Int, p::Float64, t_max::Int, num_configs::Int)
    w = SmallWorldNet(num_nodes, num_neighs, p)
    z = Net2D(w)

    avgs = meanFEEEfromOrigin(z, t_max)

    for i in 2:num_configs
        w = SmallWorldNet(num_nodes, num_neighs, p)
        z = Net2D(w)
        avgs += meanFEEEfromOrigin(z, t_max)
    end

    avgs / num_configs
end

function meanFEEEconfigSpace(num_nodes::Int, num_neighs::Int, p::Float64, t_max::Int, num_configs::Int, file::String)
    dict = Dict{ASCIIString, Any}()
    dict["num_nodes"] = num_nodes
    dict["num_neighs"] = num_neighs
    dict["p"] = p
    dict["t_max"] = t_max
    dict["num_configs"] = num_configs
    dict["means"] = meanFEEEconfigSpace(num_nodes, num_neighs, p, t_max, num_configs)
    save(file, dict)
end
