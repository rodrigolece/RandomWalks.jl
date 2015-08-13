
function randomStep(w::SmallWorldNet, node::Int)
    t = getNeighbours(w,node)
    return t[rand(1:length(t))]
end

function randomWalk(w::SmallWorldNet, node::Int, num_iters::Int)
    if !hasNode(w,node)
        print("node = $node not in network")
        return
    end

    trayec = Array(Int,num_iters+1)
    trayec[1] = node

    for i in 1:num_iters
        trayec[i+1] = randomStep(w,trayec[i])
    end

    return trayec
end

## La distribución de la caminata aleatoria -------------- ##

function histRandomWalk(w::SmallWorldNet, node::Int, num_iters::Int)
    a, b = 1, w.num_nodes

    plt.figure(figsize=(5,3))
    plt.grid()
    plt.xlim(a,b+1)
    plt.hist(randomWalk(w,node,num_iters),b-a+1,(a,b+1),normed=true)
end


## ----------------------------------------------------- ##
## ------------------- 2 Caminantes -------------------- ##
## ----------------------------------------------------- ##

function randomWalk2(w::SmallWorldNet, first_node::Int, second_node::Int)
    if !hasNode(w,first_node)
        print("1st node = $first_node not in network")
        return
    elseif !hasNode(w,second_node)
        print("2nd node = $second_node not in network")
        return
	# Tal vez este caso no me interesa como error
    elseif first_node == second_node
        print("Only one node given")
        return
    end

    t = 0

    while first_node != second_node
        first_node = randomStep(w, first_node)
        if first_node == second_node
            return t+1
        else
            second_node = randomStep(w, second_node)
            t += 1
        end
    end

    return t
end

function runsRandom2(w::SmallWorldNet, first_node::Int, second_node::Int, num_iters::Int)
    runs = Int[]
    sizehint(runs, num_iters)
    for i in 1:num_iters
        push!(runs, randomWalk2(w,first_node,second_node))
    end
    return runs
end



function allRWfromOrigin(w::SmallWorldNet, num_iters::Int)
    out = Array(Int, (num_iters,w.num_nodes-1))

    first_node = 1

    for (i,second_node) in enumerate(2:w.num_nodes)
        out[:,i] = runsRandom2(w,first_node,second_node,num_iters)
    end

    out
end

function allRWfromOrigin(w::SmallWorldNet, num_iters::Int, file::String)
	dict = Dict{ASCIIString, Any}()
	dict["num_nodes"] = w.num_nodes
	dict["num_iters"] = num_iters
	dict["runs"] = allRWfromOrigin(w, num_iters)
    save(file, dict)
end

function avgRWfromOrigin(file::String)
	num_nodes = load(file, "num_nodes")
	num_iters = load(file, "num_iters")
	runs = load(file, "runs")

	out = Array(Float64, (num_nodes-1, 2))

	μs = [mean(runs[:,i]) for i in 1:num_nodes-1]
	σs = [stdm(runs[:,i], μs[i]) for i in 1:num_nodes-1]

	out[:,1] = μ
	out[:,2] = σs/sqrt(num_iters)

	out
end



function avgRandomWalk2(w::SmallWorldNet, first_node::Int, second_node::Int, num_iters::Int)
    distance = pathLengthsFromNode(w,first_node)[second_node]
    runs = runsRandom2(w,first_node,second_node,num_iters)
    μ = mean(runs)
    σ = stdm(runs, μ)

    return distance, μ, σ/sqrt(num_iters)
end

## Para graficar la convergencia del promedio -------- ##

# ----No corregida, usa PyPlot ----#
function convergenceAvgRandomWalk2(w::SmallWorldNet, n1::Int, n2::Int, Ns::Vector{Int})
    plt.figure(figsize=(5,3))
    plt.xlim(10^(Ns[1]-0.1), 10^(Ns[end]+0.1))
    plt.grid()

    Ns = [10^i for i in Ns]
    tiempos = Float64[]
    errores = Float64[]
    d = pathLengthsFromNode(w,n1)[n2]
    for N in Ns
        a = avgRandomWalk2(w,n1,n2,N)
        push!(tiempos, a[2])
        push!(errores, a[3])
    end

    plt.title("($n1, $n2) d=$d")
    plt.semilogx(Ns, tiempos, "bo-")
    plt.errorbar(Ns, tiempos, yerr = errores)
end

# La distribución de tiempos de 2 caminantes ------------ ##

# ----No corregida, usa PyPlot ----#
function histRandomWalk2(w::SmallWorldNet, n1::Int, n2::Int, N::Int, bins::Int)
    d = pathLengthsFromNode(w,n1)[n2]
    corridas = runsRandom2(w,n1,n2,N)
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

function randomWalkUntil(w::SmallWorldNet, init_node::Int, target_node::Int)
    if !hasNode(w,init_node)
        print("Initial node = $init_node not in network")
        return
    elseif !hasNode(w,target_node)
		print("Infinite cycle, target node = $target_node not in network")
		return
    end

    t = 0
    n = init_node

    while n != target_node
        n = randomStep(w,n)
        t += 1
    end

    return t
end

function runsUntil(w::SmallWorldNet, init_node::Int, target_node::Int, num_iters)
    runs = Int[]
    sizehint(runs, num_iters)
    for i in 1:num_iters
        push!(runs, randomWalkUntil(w,init_node,target_node))
    end
    return runs
end

function avgRandomWalkUntil(w::SmallWorldNet, init_node::Int, target_node::Int, num_iters)
    distance = pathLengthsFromNode(w,init_node)[target_node]
    runs = runsUntil(w,init_node,target_node,num_iters)
    μ = mean(runs)
    σ = std(runs)

    return distance, μ, σ/sqrt(num_iters)
end

## La distibución de tiempos de primera llegada -------------- ##

# ----No corregida, usa PyPlot ----#
function histRandomWalkUntil(w::SmallWorldNet, n0::Int, nf::Int, N::Int, bins::Int)
    d = pathLengthsFromNode(w,n0)[nf]
    corridas = runsUntil(w,n0,nf,N)
    μ = mean(corridas)

    plt.figure(figsize=(5,3))
    plt.title("($n0, $nf) d=$d")
    a = plt.hist(corridas, bins, (1,bins+1))
    top = maximum( a[1] )
    plt.plot([μ,μ], [0,top], "r--")
    return a
end
