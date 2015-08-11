
## Distancia entre nodos -------------------------- ##

function pathLengthsFromNode(w::SmallWorldNet, n::Int)
    d = 0
    distances = [n => d]
    current_shell = [n]

    while length(current_shell) > 0
        next_shell = Int[]
        for m in current_shell
            for p in getNeighbours(w, m)
                if !(p in keys(distances))  #si p no está en el diccionario:
                    push!(next_shell, p)
                    distances[p] = d+1
                end
            end
        end
        d += 1
        current_shell = next_shell
    end

    return distances
end

function allPathLengths(w::SmallWorldNet)
    full_dict = Dict{(Int,Int),Int}()

    for first_node in 1:w.num_nodes
        distances = pathLengthsFromNode(w, first_node)

        for second_node in keys(distances)
            full_dict[(min(n, n2), max(n, n2))] = distances[n2] #tomar min/max evita duplicar
        end
    end

    return full_dict
end

function pathLengthsHist(w::SmallWorldNet)
    out = zeros(Int, fld(w.num_nodes, w.num_neighs) + 1) #La longitud maxima

    for n in 1:w.num_nodes
        for n2 in values(pathLengthsFromNode(w, n))
            out[n2+1] += 1
        end
    end

    out = int(out/2) ; out[1]*=2 #Todas las distancias se cuentan dos veces
    return out           		#excepto la distancia de un nodo a él mismo
end

function avgPathLength(w::SmallWorldNet)
    distrib = pathLengthsHist(w)
    p = 0.
    total = 0

    for i in 1:length(distrib)
        p += (i-1)*distrib[i] #el -1 se debe a que distrib[1] es la distancia 0
        total += distrib[i]
    end

    p /= total
end

function maxPathLength(w::SmallWorldNet)
    distrib = pathLengthsHist(w)
    N = length(distrib)

	# La distancia máxima es la mayor entrada distinta de cero
    for i in 1:N
        if distrib[N-i] != 0
            return N-i-1 #el -1 se debe a que distrib[1] es la distancia 0
        end
    end
end
