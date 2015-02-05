



## Para graficar la red ------------------------------- ##
function NodeLocations!(w::SmallWorldNet, xs::Vector{Float64}, ys::Vector{Float64})
    divi = 2pi / w.L
    angs = [0:divi:2pi-divi]
    
    for i in 1:w.L
        xs[i] = cos(pi/2 - angs[i])
        ys[i] = sin(pi/2 - angs[i])
    end
end

function CircleGraph(w::SmallWorldNet)
    plt.figure(figsize=(5,5))
    plt.xlim(-1.05, 1.05)
    plt.ylim(-1.05, 1.05)
    
    xs = Array(Float64,w.L) ; ys = Array(Float64,w.L)
    
    NodeLocations!(w,xs,ys)
    
    plt.plot(xs, ys, "ro")
    
    for n in 1:w.L
        for n2 in GetNeighbours(w,n)
            if n < n2
                plt.plot([xs[n], xs[n2]], [ys[n],ys[n2]], "k-")
            end
        end
    end
end