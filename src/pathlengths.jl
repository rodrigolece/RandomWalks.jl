
## Distancia entre nodos -------------------------- ##

function pathLengthsFromNode{T<:ComplexNetwork}(w::T, n::Int)
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

function allPathLengths{T<:ComplexNetwork}(w::T)
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

function pathLengthsHist{T<:ComplexNetwork}(w::T)
	nn = w.num_nodes
    oversized = zeros(Int, nn)

    for n in 1:nn
        for n2 in values(pathLengthsFromNode(w, n))
            oversized[n2+1] += 1
        end
    end

	# La última entrada distinta de cero
	i = 0
    while i != nn
        if oversized[nn-i] != 0
            break
		else
			i += 1
        end
    end

	last_entry = nn - i
	out = oversized[1:last_entry]

    out = round(Int, out/2) ; out[1]*=2 #Todas las distancias se cuentan dos veces excepto la distancia de un nodo a él mismo

	out
end

function avgPathLength{T<:ComplexNetwork}(w::T)
    distrib = pathLengthsHist(w)
    p = 0.
    total = 0

    for i in eachindex(distrib)
        p += (i-1)*distrib[i] #el -1 se debe a que distrib[1] es la distancia 0
        total += distrib[i]
    end

    p / total
end

function maxPathLength{T<:ComplexNetwork}(w::T)
	length(pathLengthsHist(w)) - 1 #el -1 se debe a que el primer elemento es la distancia 0
end


function pathLengths2D{T<:ComplexNetwork}(w::T)
    nn = w.num_nodes
    dict_distances = allPathLengths(w)

    out = Array(Int, (nn,nn))

    for i in 1:nn, j in 1:nn
        ordered = min(i,j), max(i,j)
        out[i,j] = dict_distances[ordered]
    end

    out
end
