
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
