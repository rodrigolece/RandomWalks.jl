

## ------------------------------------------------------- ##
## ------------------------------------------------------- ##
## --------- Funciones de caminatas aleatorias ----------- ##
## ------------------------------------------------------- ##
## ------------------------------------------------------- ##

function RandomStep(w::SmallWorldNet, n::Int64)
    t = GetNeighbours(w,n)
    return t[rand(1:length(t))]
end

function RandomWalk(w::SmallWorldNet, n0::Int64, N::Int64)
    if !HasNode(w,n0)
        print("n0 = $n0 not in network")
        return
    end
    
    trayec = Array(Int64,N+1)
    trayec[1] = n0
    
    for i in 1:N
        trayec[i+1] = RandomStep(w,trayec[i])
    end

    return trayec
end

## La distribución de la caminata aleatoria -------------- ##

function HistRandomWalk(w::SmallWorldNet, n0::Int64, N::Int64)
    a, b = minimum(GetNodes(w)), maximum(GetNodes(w))
    
    plt.figure(figsize=(5,3))
    plt.grid()
    plt.xlim(a,b+1)
    plt.hist(RandomWalk(w,n0,N),b-a+1,(a,b+1),normed=true)
end


## ----------------------------------------------------- ##
## ------------------- 2 Caminantes -------------------- ##
## ----------------------------------------------------- ##

function RandomWalk2(w::SmallWorldNet, n1::Int64, n2::Int64)
    if HasNode(w,n1) == false
        print("n1 = $n1 not in network")
        return
    elseif HasNode(w,n2) == false
        print("n2 = $n2 not in network")
        return
    elseif n1 == n2
        print("Only one node given")
        return
    end
    
    t = 0
    
    while n1 != n2
        n1 = RandomStep(w, n1)
        if n1 == n2
            return t+1
        else
            n2 = RandomStep(w, n2)
            t += 1
        end
    end
    
    return t
end

function RunsRandom2(w::SmallWorldNet, n1::Int64, n2::Int64, N::Int64)
    corridas = Int64[]
    sizehint(corridas, N)
    for i in 1:N
        push!(corridas, RandomWalk2(w,n1,n2))
    end
    return corridas
end

function AvgRandomWalk2(w::SmallWorldNet, n1::Int64, n2::Int64, N::Int64)
    d = PathLengthsFromNode(w,n1)[n2]
    corridas = RunsRandom2(w,n1,n2,N)
    μ = mean(corridas)
    σ = std(corridas)
    
    return d, μ, σ/sqrt(N)
end

## Para graficar la convergencia del promedio -------- ## 

function ConvergenceAvgRandomWalk2(w::SmallWorldNet, n1::Int64, n2::Int64, Ns::Vector{Int64})
    plt.figure(figsize=(5,3))
    plt.xlim(10^(Ns[1]-0.1), 10^(Ns[end]+0.1))
    plt.grid()
    
    Ns = [10^i for i in Ns]
    tiempos = Float64[]
    errores = Float64[]
    d = PathLengthsFromNode(w,n1)[n2]
    for N in Ns
        a = AvgRandomWalk2(w,n1,n2,N)
        push!(tiempos, a[2])
        push!(errores, a[3])
    end
    
    plt.title("($n1, $n2) d=$d")
    plt.semilogx(Ns, tiempos, "bo-")
    plt.errorbar(Ns, tiempos, yerr = errores)
end

# La distribución de tiempos de 2 caminantes ------------ ##

function HistRandomWalk2(w::SmallWorldNet, n1::Int64, n2::Int64, N::Int64, bins::Int64)
    d = PathLengthsFromNode(w,n1)[n2]
    corridas = RunsRandom2(w,n1,n2,N)
    μ = mean(corridas)
    
    plt.figure(figsize=(5,3))
    plt.title("($n1, $n2) d=$d")
    a = plt.hist(corridas, bins, (1,bins+1))
    top = maximum( a[1] )
    plt.plot([μ,μ], [0,top], "r--")
    return a
end


## ----------------------------------------------------- ##
## ------------------ Primera llegada ------------------ ##
## ----------------------------------------------------- ##

function RandomWalkUntil(w::SmallWorldNet, n0::Int64, nf::Int64)
    if HasNode(w,n0) == false
        print("n0 = $n0 not in network")
        return
    elseif HasNode(w,nf) == false
        print("Infinite cycle, nf = $nf not in network")
        return
    end
    
    t = 0
    n = n0
    
    while n != nf
        n = RandomStep(w,n)
        t += 1
    end

    return t
end

function RunsUntil(w::SmallWorldNet, n0::Int64, nf::Int64, N::Int64)
    corridas = Int64[]
    sizehint(corridas, N)
    for i in 1:N
        push!(corridas, RandomWalkUntil(w,n0,nf))
    end
    return corridas
end

function AvgRandomWalkUntil(w::SmallWorldNet, n0::Int64, nf::Int64, N::Int64)
    d = PathLengthsFromNode(w,n0)[nf]
    corridas = RunsUntil(w,n0,nf,N)
    μ = mean(corridas)
    σ = std(corridas)
    
    return d, μ, σ/sqrt(N)
end

## La distibución de tiempos de primera llegada -------------- ##

function HistRandomWalkUntil(w::SmallWorldNet, n0::Int64, nf::Int64, N::Int64, bins::Int64)
    d = PathLengthsFromNode(w,n0)[nf]
    corridas = RunsUntil(w,n0,nf,N)
    μ = mean(corridas)
    
    plt.figure(figsize=(5,3))
    plt.title("($n0, $nf) d=$d")
    a = plt.hist(corridas, bins, (1,bins+1)) 
    top = maximum( a[1] )
    plt.plot([μ,μ], [0,top], "r--")
    return a
end