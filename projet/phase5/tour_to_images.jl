include("heldkarp.jl")
include("tools.jl")


function reconstruct_order(tour::Graph)
    lis_nodes = [1]
    node_actuel = Node{Vector{Any}}("1", Any[])
    derniere_edge = edges(tour)[1]
    edge_a_garder = edges(tour)[1]
    while length(lis_nodes) < length(nodes(tour))
        for edge in edges(tour)
            if sommets(edge)[1].name == node_actuel.name || sommets(edge)[2].name == node_actuel.name
                if sommets(edge)[1].name != sommets(derniere_edge)[1].name || sommets(edge)[2].name != sommets(derniere_edge)[2].name
                    edge_a_garder = edge
                end
            end
        end
        if name(node_actuel) == name(sommets(edge_a_garder)[1])
            node_actuel = sommets(edge_a_garder)[2]
        else
            node_actuel = sommets(edge_a_garder)[1]
        end
        derniere_edge = edge_a_garder
        push!(lis_nodes, parse(Int,name(node_actuel)))
    end
    lis_nodes
end

function save_tour(tour::Graph, file::String, view::Bool = false)
    array_tour = reconstruct_order(tour)
    path_tour = joinpath("shredder-julia","tsp", "tours",file)*".tour"
    path_shuffled = joinpath("shredder-julia","images", "shuffled",file)*".png"
    path_recons = joinpath("shredder-julia","images", "reconstructed",file)*".png"
    write_tour(path_tour, array_tour, Float32(poids_total(tour)))
    reconstruct_picture(path_tour,path_shuffled,path_recons,view = view)
end