using FactCheck

# using RandomWalks

# Pruebas de las redes:

include("tests_nets.jl")


# Pruebas de lo algoritmos de distancia:

include("tests_paths.jl")

# Pruebas de las funciones de RW:

include("tests_rw.jl")


FactCheck.exitstatus()
