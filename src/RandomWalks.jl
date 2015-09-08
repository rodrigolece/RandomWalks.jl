module RandomWalks


using JLD

import Base:
	show


export
	SmallWorldNet, SmallWorldNetWithNoStep,
	hasNode, addNode!, addEdge!, getNeighbours,
	Net2D,
# 	circleGraph,
	pathLengthsFromNode, allPathLengths, pathLengthsHist, avgPathLength, maxPathLength,
	randomStep, randomWalk,# histRandomWalk,
	firstEncounter, runsFirstEncounter, meanFE,# convergenceAvgRandomWalk2, histRandomWalk2,
	allFEfromOrigin, meanFEfromOrigin, meanFEConfigSpace,
	firstPassage, runsFirstPassage, meanFP,# histRandomWalkUntil
	allFPfromOrigin, meanFPfromOrigin, meanFPConfigSpace,
	deg, firstEncounterEE, meanFEEE


include("nets.jl")
# include("circlegraph.jl")
include("pathlengths.jl")
include("functions_rw.jl")
include("exact_enum.jl")



end # module RandomWalks
