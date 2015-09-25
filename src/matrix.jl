
function meanFPmatrix(w::SmallWorldNet)
    nn = w.num_nodes

    c = ones(nn)
    c[1] = 0.

    # La diagonal
    sparse_I = collect(1:nn)
    sparse_J = collect(1:nn)
    sparse_V = ones(nn)

    for node in 2:nn
        d = deg(w, node)
        append!(sparse_I, node*ones(Int, d))

        neighs = getNeighbours(w, node)
        append!(sparse_J, neighs)

        append!(sparse_V, -ones(d)/d)
    end


    sparse(sparse_I, sparse_J, sparse_V) \ c
end

function meanFPMconfigSpace(num_nodes::Int, num_neighs::Int, p::Float64, num_configs::Int)
    w = SmallWorldNet(num_nodes, num_neighs, p)

    out = meanFPmatrix(w)[1:num_nodes]

    for i in 2:num_configs
        w = SmallWorldNet(num_nodes, num_neighs, p)

        out += meanFPmatrix(w)[1:num_nodes]
    end

    out / num_configs
end



translateIndex(i, j, num_nodes) = i + num_nodes*(j-1)
translateIndex(tup, num_nodes) = translateIndex(tup..., num_nodes)

function meanFEmatrix(z::Net2D)
    nn = z.num_nodes

    c = ones(nn^2)
    for ind in 1:nn
        m = translateIndex(ind, ind, nn)
        c[m] = 0.
    end

    # La diagonal
    sparse_I = collect(1:nn^2)
    sparse_J = collect(1:nn^2)
    sparse_V = ones(nn^2)

    for site_i in 1:nn, site_j in 1:nn
        if site_i == site_j
            continue
        end

        d = deg(z, site_i, site_j)

        # Transformamos el par ordenado en un índice lineal
        m = translateIndex(site_i, site_j, nn)

        append!(sparse_I, m*ones(Int, d))

        neighs = z.neighbours[site_i, site_j]

        tmpJ = map(tup -> translateIndex(tup, nn), neighs)
        append!(sparse_J, tmpJ)

        append!(sparse_V, -ones(d)/d)
    end


    M = sparse(sparse_I, sparse_J, sparse_V)
#     @show full(M)
    reshape(M \ c, (nn,nn))
end

function meanFEMconfigSpace(num_nodes::Int, num_neighs::Int, p::Float64, num_configs::Int)
    w = SmallWorldNet(num_nodes, num_neighs, p)
    z = Net2D(w)

    out = meanFEmatrix(z)[1:num_nodes]

    for i in 2:num_configs
        w = SmallWorldNet(num_nodes, num_neighs, p)
        z = Net2D(w)

        out += meanFEmatrix(z)[1:num_nodes]
    end

    out / num_configs
end
