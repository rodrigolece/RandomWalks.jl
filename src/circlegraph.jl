using PyPlot

## Para graficar la red ------------------------------- ##
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

function circleGraph{T<:ComplexNetwork}(w::T)
    figure(figsize=(5,5))
	δ = 0.05
    xlim(-1-δ, 1+δ)
    ylim(-1-δ, 1+δ)

    xs, ys = nodeLocations(w)

	# Tal vez esto se puede hacer con un sólo llamado a plot, construyendo una matriz antes
    for n in 1:w.num_nodes
        for n2 in getNeighbours(w,n)
            if n < n2
                plot([xs[n], xs[n2]], [ys[n],ys[n2]], "k-")
            end
        end
    end

	plot(xs, ys, "ro")
end
