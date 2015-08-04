module CircleGraph

using Nets
using PyPlot

export circleGraph

## Para graficar la red ------------------------------- ##
function nodeLocations(w::SmallWorldNet)
    divi = 2pi / w.num_nodes
    angs = [0:divi:2pi-divi]

	xs = Array(Float64,w.num_nodes) ; ys = Array(Float64,w.num_nodes)

    for i in 1:w.num_nodes
        xs[i] = cos(pi/2 - angs[i])
        ys[i] = sin(pi/2 - angs[i])
    end

	return xs, ys
end

function circleGraph(w::SmallWorldNet)
    plt.figure(figsize=(5,5))
    plt.xlim(-1.05, 1.05)
    plt.ylim(-1.05, 1.05)

    xs, ys = nodeLocations(w)

    plt.plot(xs, ys, "ro")

	# Tal vez esto se puede hacer con un sólo llamado a plot, construyendo una matriz antes
    for n in 1:w.num_nodes
        for n2 in getNeighbours(w,n)
            if n < n2
                plt.plot([xs[n], xs[n2]], [ys[n],ys[n2]], "k-")
            end
        end
    end
end

end
