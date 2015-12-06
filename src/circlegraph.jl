using PyPlot
using PyCall

## Para ubicar los nodos de la red --------------------- ##
function nodeLocations{T<:ComplexNetwork}(w::T)
    divi = 2pi / w.num_nodes
	angs = linspace(0,2pi-divi, w.num_nodes)

	xs = Array(Float64,w.num_nodes) ; ys = Array(Float64,w.num_nodes)

    for i in 1:w.num_nodes
        xs[i] = cos(pi/2 - angs[i])
        ys[i] = sin(pi/2 - angs[i])
    end

	return xs, ys
end


## Para graficar la red ------------------------------- ##
function circleGraph{T<:ComplexNetwork}(w::T)
    fig = figure(figsize=(5,5))
	axes = fig[:gca]()[:axes]
	axes[:get_xaxis]()[:set_visible](false)
	axes[:get_yaxis]()[:set_visible](false)

	δ = 0.05
    xlim(-1-δ, 1+δ)
    ylim(-1-δ, 1+δ)

    xs, ys = nodeLocations(w)

	for n in 1:w.num_nodes
        neighs = getNeighbours(w,n)
        close_neighs = neighs[1:2w.num_neighs]
        shortcuts = neighs[2w.num_neighs+1:end]

        for n2 in close_neighs
            if n < n2
                plot([xs[n], xs[n2]], [ys[n],ys[n2]], "k")
            end
        end

        for n2 in shortcuts
            if n < n2
                plot([xs[n], xs[n2]], [ys[n],ys[n2]], "0.5")
            end
        end
    end

	plot(xs, ys, "ro")
    fig
end

function circleGraph{T<:ComplexNetwork}(w::T, name::AbstractString)
    fig = circleGraph(w)
	savefig(name*".pdf", bbox_inches="tight")
end



function circleGraphShowOrigin{T<:ComplexNetwork}(w::T)
    fig = figure(figsize=(5,5.1))
	axes = fig[:gca]()[:axes]
	axes[:get_xaxis]()[:set_visible](false)
	axes[:get_yaxis]()[:set_visible](false)

	δ = 0.05
    xlim(-1-δ, 1+δ)
    ylim(-1-δ, 1.1+δ)

    xs, ys = nodeLocations(w)

	for n in 1:w.num_nodes
        neighs = getNeighbours(w,n)
        close_neighs = neighs[1:2w.num_neighs]
        shortcuts = neighs[2w.num_neighs+1:end]

        for n2 in close_neighs
            if n < n2
                plot([xs[n], xs[n2]], [ys[n],ys[n2]], "k")
            end
        end

        for n2 in shortcuts
            if n < n2
                plot([xs[n], xs[n2]], [ys[n],ys[n2]], "0.5")
            end
        end
    end

    plot(xs[2:end], ys[2:end], "ro")
    plot(xs[1], ys[1], "ko")
    text(-0.02,1.05,"0")
    fig
end

function circleGraphShowOrigin{T<:ComplexNetwork}(w::T, name::AbstractString)
    fig = circleGraphShowOrigin(w)
	savefig(name*".pdf", bbox_inches="tight")
end
