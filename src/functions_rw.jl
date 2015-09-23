
function randomStep(w::SmallWorldNet, node::Int)
    choices = getNeighbours(w,node)

	choices[rand(1:length(choices))]
end

function randomStep(z::Net2D, site::Tuple{Int,Int})
    choices = z.neighbours[site...]

    choices[rand(1:length(choices))]
end


function randomWalk(w::SmallWorldNet, node::Int, num_iters::Int)
    out = Array(Int,num_iters)
    out[1] = node

    for i in 2:num_iters
        out[i] = randomStep(w,out[i-1])
    end

    out
end

function randomWalk(z::Net2D, site::Tuple{Int,Int}, num_iters::Int)
    out = Array(Tuple{Int,Int},num_iters)
    out[1] = site

    for i in 2:num_iters
        out[i] = randomStep(z,out[i-1])
    end

    out
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

function firstEncounter(w::SmallWorldNet, first_node::Int, second_node::Int)
    t = 0

    while first_node != second_node
		for _ in 1:2 # En un paso hay dos movimientos
			# Escogemos a un caminante y lo movemos
			if rand() < 0.5
				first_node = randomStep(w, first_node)
			else
				second_node = randomStep(w, second_node)
			end

			if first_node == second_node
				return t+1
			end
		end

		t += 1
	end
end

function runsFirstEncounter(w::SmallWorldNet, first_node::Int, second_node::Int, num_iters::Int)
    runs = Int[]
    sizehint!(runs, num_iters)

    for i in 1:num_iters
        push!(runs, firstEncounter(w,first_node,second_node))
    end

    runs
end

# Nos gutaría que esta función utilizara la de abajo que calcula promedios y escribe con JLD
function meanFE(w::SmallWorldNet, first_node::Int, second_node::Int, num_iters::Int)
    runs = runsFirstEncounter(w,first_node,second_node,num_iters)
    μ = mean(runs)
    σ = stdm(runs, μ)

    [ μ, σ/sqrt(num_iters) ]
end



function allFEfromOrigin(w::SmallWorldNet, num_iters::Int)
    out = Array(Int, (num_iters,w.num_nodes-1))

    first_node = 1

    for (i,second_node) in enumerate(2:w.num_nodes)
        out[:,i] = runsFirstEncounter(w,first_node,second_node,num_iters)
    end

    out
end

function allFEfromOrigin(w::SmallWorldNet, num_iters::Int, file::String)
	dict = Dict{ASCIIString, Any}()
	dict["num_nodes"] = w.num_nodes
	dict["num_iters"] = num_iters
	dict["runs"] = allFEfromOrigin(w, num_iters)
    save(file, dict)
end

function meanFEfromOrigin(file::String)
	num_nodes = load(file, "num_nodes")
	num_iters = load(file, "num_iters")
	runs = load(file, "runs")

	out = Array(Float64, (num_nodes, 2))
	out[1,:] = [0.,0.] # Esto nos facilita manejar las dimensiones

	μs = [mean(runs[:,i]) for i in 1:num_nodes-1]
	σs = [stdm(runs[:,i], μs[i]) for i in 1:num_nodes-1]

	out[2:end,1] = μs
	out[2:end,2] = σs/sqrt(num_iters)

	out
end


function meanFEconfigSpace(num_nodes::Int, num_neighs::Int, p::Float64, num_iters::Int, num_configs::Int)
    w = SmallWorldNet(num_nodes,num_neighs,p)
    allFEfromOrigin(w, num_iters, "/tmp/tmp.jld")
    avgs = meanFEfromOrigin("/tmp/tmp.jld")[:,1]
    # Cómo se calcula el error?

    for i in 2:num_configs
        w = SmallWorldNet(num_nodes,num_neighs,p)
        allFEfromOrigin(w, num_iters, "/tmp/tmp.jld")
        avgs += meanFEfromOrigin("/tmp/tmp.jld")[:,1]
    end

    avgs / num_configs
end

function meanFEconfigSpace(num_nodes::Int, num_neighs::Int, p::Float64, num_iters::Int, num_configs::Int, file::String)
    dict = Dict{ASCIIString, Any}()
    dict["num_nodes"] = num_nodes
    dict["num_neighs"] = num_neighs
    dict["p"] = p
    dict["num_iters"] = num_iters
    dict["num_configs"] = num_configs
    dict["means"] = meanFEconfigSpace(num_nodes, num_neighs, p, num_iters, num_configs)
    save(file, dict)
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

function firstPassage(w::SmallWorldNet, init_node::Int, target_node::Int)
    t = 0
    n = init_node

    while n != target_node
        n = randomStep(w,n)
        t += 1
    end

    t
end

function runsFirstPassage(w::SmallWorldNet, init_node::Int, target_node::Int, num_iters)
    runs = Int[]
    sizehint!(runs, num_iters)

    for i in 1:num_iters
        push!(runs, firstPassage(w,init_node,target_node))
    end

    runs
end

function meanFP(w::SmallWorldNet, init_node::Int, target_node::Int, num_iters)
    distance = pathLengthsFromNode(w,init_node)[target_node]
    runs = runsFirstPassage(w,init_node,target_node,num_iters)
    μ = mean(runs)
    σ = std(runs)

    distance, μ, σ/sqrt(num_iters)
end



function allFPfromOrigin(w::SmallWorldNet, num_iters::Int)
    out = Array(Int, (num_iters,w.num_nodes-1))

    init_node = 1

    for (i,target_node) in enumerate(2:w.num_nodes)
        out[:,i] = runsFirstPassage(w,init_node,target_node,num_iters)
    end

    out
end

function allFPfromOrigin(w::SmallWorldNet, num_iters::Int, file::String)
	dict = Dict{ASCIIString, Any}()
	dict["num_nodes"] = w.num_nodes
	dict["num_iters"] = num_iters
	dict["runs"] = allFPfromOrigin(w, num_iters)
    save(file, dict)
end

function meanFPfromOrigin(file::String)
	num_nodes = load(file, "num_nodes")
	num_iters = load(file, "num_iters")
	runs = load(file, "runs")

	out = Array(Float64, (num_nodes, 2))
	out[1,:] = [0.,0.] # Esto nos facilita manejar las dimensiones

	μs = [mean(runs[:,i]) for i in 1:num_nodes-1]
	σs = [stdm(runs[:,i], μs[i]) for i in 1:num_nodes-1]

	out[2:end,1] = μs
	out[2:end,2] = σs/sqrt(num_iters)

	out
end


function meanFPconfigSpace(num_nodes::Int, num_neighs::Int, p::Float64, num_iters::Int, num_configs::Int)
    w = SmallWorldNet(num_nodes,num_neighs,p)
    allFPfromOrigin(w, num_iters, "/tmp/tmp.jld")
    avgs = meanFPfromOrigin("/tmp/tmp.jld")[:,1]
    # Cómo se calcula el error?

    for i in 2:num_configs
        w = SmallWorldNet(num_nodes,num_neighs,p)
        allFPfromOrigin(w, num_iters, "/tmp/tmp.jld")
        avgs += meanFPfromOrigin("/tmp/tmp.jld")[:,1]
    end

    avgs / num_configs
end

function meanFPconfigSpace(num_nodes::Int, num_neighs::Int, p::Float64, num_iters::Int, num_configs::Int, file::String)
    dict = Dict{ASCIIString, Any}()
    dict["num_nodes"] = num_nodes
    dict["num_neighs"] = num_neighs
    dict["p"] = p
    dict["num_iters"] = num_iters
    dict["num_configs"] = num_configs
    dict["means"] = meanFPconfigSpace(num_nodes, num_neighs, p, num_iters, num_configs)
    save(file, dict)
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
