include("heldkarp.jl")
include("tools.jl")

"""Prend en argument une tournée et renvoie les sommets dans l'ordre en partant du noeud 1 (ordre choisi au hasard)
"""
function reconstruct_order(tour::Graph)
    lis_nodes = [1]
    node_actuel = Node{Vector{Any}}("1", Any[])
    derniere_edge = edges(tour)[1]
    edge_a_garder = edges(tour)[1]

    while length(lis_nodes) < length(nodes(tour))
        for edge in edges(tour)
            if name(sommets(edge)[1]) == name(node_actuel) || name(sommets(edge)[2]) == name(node_actuel)
                if name(sommets(edge)[1]) != name(sommets(derniere_edge)[1]) || name(sommets(edge)[2]) != name(sommets(derniere_edge)[2])
                    edge_a_garder = edge
                end
            end 
        end #On parcourt la liste de toutes les arêtes pour retrouver l'arête menant au noeud suivant 
        # (l'arête reliée à node_actuel qui n'est pas derniere_edge) 
        # (choisie au hasard à la première itération parmi les 2 arêtes reliées à 1)


        if name(node_actuel) == name(sommets(edge_a_garder)[1])
            node_actuel = sommets(edge_a_garder)[2]
        else
            node_actuel = sommets(edge_a_garder)[1]
        end 
        derniere_edge = edge_a_garder #On actualise la valeur de node_actuel et de derniere_edge


        push!(lis_nodes, parse(Int,name(node_actuel))) #on rajoute node_actuel à la liste des noeuds parcourus
    end

    lis_nodes
end

"""¨Prend en argument une tournée ainsi que le nom de l'instance (sous la forme 'abstract-light-painting') et reconstruit 
l'image associée.
"""
function save_tour(tour::Graph, file::String, view::Bool = false)
    array_tour = reconstruct_order(tour)
    path_tour = joinpath("shredder-julia","tsp", "tours",file)*".tour"
    path_shuffled = joinpath("shredder-julia","images", "shuffled",file)*".png"
    path_recons = joinpath("shredder-julia","images", "reconstructed",file)*".png"
    write_tour(path_tour, array_tour, Float32(poids_total(tour)))
    reconstruct_picture(path_tour,path_shuffled,path_recons,view = view)
end