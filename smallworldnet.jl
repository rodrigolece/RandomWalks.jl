


## El tipo SmallWorldNet con el constructor básico ----- ##
type SmallWorldNet
    L::Int64
    Z::Int64
    p::Float64
    neighbours::Vector{Vector{Int64}}

    function SmallWorldNet(L::Int64)
        neighbours = Array(Vector{Int64},L)
        fill!(neighbours, [])
        new(L, 0, 0., neighbours)
    end
end
        
import Base.show
 
show(io::IO, w::SmallWorldNet) = println(io, "L:$(w.L) Z:$(w.Z) p:$(w.p)")


## Las funciones de la red --------------------------- ##

function HasNode(w::SmallWorldNet, n::Int64)
    n <= length(w.neighbours) ? true : false
end

function AddNode!(w::SmallWorldNet)
    push!(w.neighbours, [])
end

function GetNodes(w::SmallWorldNet)
    [1:length(w.neighbours)]
end

function GetNeighbours(w::SmallWorldNet, n::Int64)
    w.neighbours[n]
end

function AddEdge!(w::SmallWorldNet, n1::Int64, n2::Int64)
    if n1 == n2
        #print("Only one node given: ",n1)
        return
    elseif n2 in GetNeighbours(w, n1)
        #print("Edge already defined")
        return
    else
        push!(w.neighbours[n1], n2) 
        push!(w.neighbours[n2], n1)
    end
end


## El constructor completo-------------------------- ##

function AddNeighbourEdges!(w::SmallWorldNet)
    modulo = Dict{Int64,Int64}()
    for i in 0:w.L-1
        modulo[-i] = w.L - i
        modulo[i+1] = i+1
        modulo[w.L+i] = i
    end
    
    for n in 1:w.L
        rango = [n - div(w.Z,2):n-1, n+1:n + div(w.Z,2)]
        traducido = [modulo[t] for t in rango]
        for n2 in traducido
            AddEdge!(w, n, n2)
        end
    end 
end

function AddRandomEdges!(w::SmallWorldNet)
    cont = 1.
    while cont <= w.p*w.L*w.Z/2
        n1 = rand(1:w.L)
        n2 = rand(1:w.L)
        if n1 != n2
            AddEdge!(w, n1, n2)
            cont += 1
        end
    end
end     
    
function SmallWorldNet(L::Int64, Z::Int64, p::Float64)
    w = SmallWorldNet(L)
    w.Z = Z
    w.p = p
    
    AddNeighbourEdges!(w)
    AddRandomEdges!(w)

    return w
end

## La función para agregar a un nodo como du vecino, para caminatas que pueden no dar paso ------------------------------------------------- ##

function SmallWorldNetWithNoStep(w::SmallWorldNet)
    wc = SmallWorldNet(w.L)
    for i in 1:w.L
        wc.neighbours[i] = push!([copy(w.neighbours[i])...],i)
    end
    return wc 
end
