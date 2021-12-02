include("rsl.jl")
include("heldkarp.jl")
include("tools.jl")
using Test




path = joinpath("shredder-julia", "tsp", "instances")
for file in readdir(path)
    if file != ".gitignore"
        graph = create_graph(path*"\\"*file)
        graph_rsl,poids_rsl,_ = min_rsl(graph)
        println(file)
        println("Le poids minimal obtenu avec RSL est de "*string(poids_rsl))
        println("")
        println("")
        
    end
end
