
## Distancia entre nodos -------------------------- ##

function PathLengthsFromNode(w::SmallWorldNet, n::Int64)
    d = 0 
    distances = [n => d]
    currentShell = [n]
    
    while length(currentShell) > 0
        nextShell = Int64[]
        for m in currentShell
            for p in GetNeighbours(w, m)
                if !(p in keys(distances))  #si p no está en el diccionario:
                    push!(nextShell, p)
                    distances[p] = d+1
                end
            end
        end
        d += 1
        currentShell = nextShell
    end
    
    return distances
end

function AllPathLengths(w::SmallWorldNet)
    out = zeros(fld(w.L,w.Z)+1) #La longitud maxima 
    
    for n in GetNodes(w)
        for n2 in values(PathLengthsFromNode(w, n))
            out[n2+1] += 1
        end
    end
    
    out /= 2 ; out[1]*=2 #Todas las distancias se cuentan dos veces
    return out           #excepto la distancia de un nodo a él mismo
end

function AvgPathLength(w::SmallWorldNet)
    distrib = AllPathLengths(w)
    p = 0.
    total = 0.
    
    for i in 1:length(distrib)
        p += (i-1)*distrib[i]
        total += distrib[i]
    end
    
    p /= total
end

function MaxPathLength(w::SmallWorldNet)
    distrib = AllPathLengths(w)
    N = length(distrib)

    for i in 1:N
        if distrib[N-i] != 0.
            return N-i-1 #el -1 se debe a que distrib[1] es la distancia 0
        end
    end
end
        
