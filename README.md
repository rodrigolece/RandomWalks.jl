# RandomWalks.jl

![Build status](https://travis-ci.org/rodrigolece/RandomWalks.jl.svg?branch=master)
[![Coverage Status](https://coveralls.io/repos/rodrigolece/RandomWalks.jl/badge.svg?branch=master&service=github)](https://coveralls.io/github/rodrigolece/RandomWalks.jl?branch=master)

La red de mundo pequeño está implementada en el tipo `SmallWorldNet` (en `src/nets.jl`). El resto de las funciones trabajan con este tipo y sirven para:

- Graficarla (`src/circlegraph.jl`)
- Calcular distancias entre nodos (`src/pathlengths.jl`)
- Hacer simulaciones de caminatas aleatorias (`src/functions_rw.jl`)
