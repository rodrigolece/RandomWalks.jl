
## Distancia entre nodos -------------------------- ##

function pathLengthsFromNode(w::SmallWorldNet, n::Int)
    d = 0
    distances = Dict(n => d)
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

    distances
end

function allPathLengths(w::SmallWorldNet)
    full_dict = Dict{Tuple{Int,Int},Int}()

    for first_node in 1:w.num_nodes
        distances = pathLengthsFromNode(w, first_node)

        for second_node in keys(distances)
			# Tomar min/max evita duplicar
			ordered = min(first_node, second_node), max(first_node, second_node)
            full_dict[ordered] = distances[second_node]
        end
    end

    full_dict
end

function pathLengthsHist(w::SmallWorldNet)
    out = zeros(Int, fld(w.num_nodes, 2*w.num_neighs) + 1) #La longitud maxima

    for n in 1:w.num_nodes
        for n2 in values(pathLengthsFromNode(w, n))
            out[n2+1] += 1
        end
    end

    out = round(Int, out/2) ; out[1]*=2 #Todas las distancias se cuentan dos veces excepto la distancia de un nodo a él mismo

	out
end

function avgPathLength(w::SmallWorldNet)
    distrib = pathLengthsHist(w)
    p = 0.
    total = 0

    for i in eachindex(distrib)
        p += (i-1)*distrib[i] #el -1 se debe a que distrib[1] es la distancia 0
        total += distrib[i]
    end

    p / total
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


function pathLengths2D(w::SmallWorldNet)
    nn = w.num_nodes
    dict_distances = allPathLengths(w)

    out = Array(Int, (nn,nn))

    for i in 1:nn, j in 1:nn
        ordered = min(i,j), max(i,j)
        out[i,j] = dict_distances[ordered]
    end

    out
end
