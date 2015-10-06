module RandomWalks


using JLD

import Base:
	show


export
	ComplexNetwork,
	hasNode, addNode!, getNeighbours, addEdge!,
	SmallWorldNet, SmallWorldNetWithNoStep,
	BarabasiAlbert, BarabasiAlbertWithNoStep,
	Net2D,
# 	circleGraph,
	pathLengthsFromNode, allPathLengths, pathLengthsHist, avgPathLength, maxPathLength, pathLengths2D, classifyWithDistance,
	randomStep, randomWalk,# histRandomWalk,
	firstEncounter, runsFirstEncounter, meanFE,# convergenceAvgRandomWalk2, histRandomWalk2,
	allFEfromOrigin, meanFEfromOrigin, meanFEconfigSpace,
	firstPassage, runsFirstPassage, meanFP,# histRandomWalkUntil
	allFPfromOrigin, meanFPfromOrigin, meanFPconfigSpace,
	deg, firstEncounterEE, meanFEEE, meanFEEEfromOrigin, meanFEEEconfigSpace,
	meanFPmatrix, meanFPMconfigSpace, meanFEmatrix, meanFEMconfigSpace


include("nets.jl")
# include("circlegraph.jl")
include("pathlengths.jl")
include("functions_rw.jl")
include("exact_enum.jl")
include("matrix.jl")



end # module RandomWalks
