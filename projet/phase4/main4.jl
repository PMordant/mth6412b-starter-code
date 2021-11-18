include("rsl.jl")
include("heldkarp.jl")
using Test

dict_args_hk = Dict("bayg29.tsp" => Any[16,0.01,10000],
                    "bays29.tsp" => Any[13,0.01,10000],
                    "brazil58.tsp" => Any[38,1.,10000],
                    "brg180.tsp" => Any[1,1.,0],
                    "dantzig42.tsp" => Any[35,0.1,1000],
                    "fri26.tsp" => Any[19,1.,10000],
                    "gr17.tsp" => Any[7,0.01,100000],
                    "gr21.tsp" => Any[1,0.1,10000],
                    "gr24.tsp" => Any[8,0.1,10000],
                    "gr48.tsp" => Any[11,0.01,50000],
                    "gr120.tsp" => Any[61,1.,1000],
                    "hk48.tsp" => Any[17,0.1,10000],
                    "pa561.tsp" => Any[1,1.,0],
                    "swiss42.tsp" => Any[40,0.1,10000]
)

dict_resul_opti = Dict()
path_resul_opti = joinpath("projet","instances", "solutions_stsp.txt")
file_resul_opti = open(path_resul_opti, "r")
for line in eachline(file_resul_opti)
    line = strip(line)
    data = split(line,":")
    if length(data) >= 2
        dict_resul_opti[data[1]] = parse(Int, data[2])
    end
end




path = joinpath("projet", "instances", "stsp")
for file in readdir(path)
    if file != "brg180.tsp"

        println(file*":")
        graph_file = create_graph(joinpath(path,file))
        arbre_rsl,poids_rsl,noeud_rsl = min_rsl(graph_file)
        arbre_hk,poids_hk = heldkarp(graph_file,dict_args_hk[file]..., false)


        println("Le poids minimal obtenu avec RSL est de "*string(poids_rsl))
        println("Le poids minimal obtenu avec HK est de "*string(poids_hk))
        println("Le poids optimal connu est de "*string(dict_resul_opti[split(file,".")[1]*" "]))
        println("")
        println("")
    end
end
