import Base.length, Base.push!, Base.popfirst!
import Base.show
include("kruskal.jl")
include("heuristiques.jl")



function popfirst!(d::Dict)
    lowest = collect(keys(d))[1]
    for key in keys(d)
        if d[key] < d[lowest]
            lowest = key
        end
    end
    min_weight = pop!(d,lowest)
    lowest,min_weight
end

"""Prend en argument un nom de fichier d'une instance tsp et utilise l'algorithme de Prim sur cette instance"""
function prim(filename::String)
    graph = create_graph(filename)
    prim(graph)
end



function prim(graph::Graph, node_depart::Node=graph.nodes[1])
    T = typeof(data(nodes(graph)[1]))
    
    connex_deja_traitee = Connex(Node{Any}[]) # Initialisation de la composante connexe déjà traitée
    arete_arbre_min = Edge{T}[]     #Initialisation de la liste des arêts de l'arbre de recouvrement minimal


    dico_min_weights = Dict{String,Any}()
    dico_parents = Dict{String,Any}()
    dico_rangs = Dict{String, Any}()

    for node in nodes(graph)
        
        push!(dico_min_weights, name(node) => Inf)
        push!(dico_parents, name(node) => nothing)
        push!(dico_rangs, name(node) => 0)
    
    end #Dictionnaires des parents et des rangs initialisés


    #On commence l'algorithme en traitant le noeud de départ. 
    delete!(dico_min_weights, name(node_depart)) 
    edges_connected = find_edges(name(node_depart), graph)
    for edge in edges_connected
        autre_sommet = " "
        if edge.sommet1.name != name(node_depart)
            autre_sommet = name(sommets(edge)[1])
        else
            autre_sommet = name(sommets(edge)[2])
        end
        dico_min_weights[autre_sommet] = poids(edge)
    end

    dico_parents[name(node_depart)] = name(node_depart)
    dico_rangs[name(node_depart)] = 0
    add_node!(connex_deja_traitee, Node{Any}(name(node_depart), nothing))

    while isempty(dico_min_weights) == false 
        
        #Tant qu'il reste un noeud non traité, on récupère le noeud à plus faible distance de la composante connexe déjà traitée et 
        #on effectue une itération en retrouvant UNE arête à garder qui donnait cette distance minimale et, pour chaque arête connectée
        #à ce sommet et à un sommet pas encore parcouru, en modifiant la distance à la composante connexe déjà traitée si besoin.

        node_to_add, min_weight = popfirst!(dico_min_weights)
        edges_connected = find_edges(node_to_add, graph)
        arete_a_garder = nothing

        for edge in edges_connected
            autre_sommet = " "
            if name(sommets(edge)[1]) != node_to_add
                autre_sommet = name(sommets(edge)[1])
            else
                autre_sommet = name(sommets(edge)[2])
            end

            if haskey(dico_min_weights, autre_sommet)
                if poids(edge) < dico_min_weights[autre_sommet]
                    dico_min_weights[autre_sommet] = poids(edge)
                end
            else   
                if poids(edge) == min_weight
                    arete_a_garder = edge
                end
            end
        end   

        push!(arete_arbre_min, arete_a_garder)

        heuristique1!(dico_rangs,dico_parents,connex_deja_traitee,Connex([Node{Any}(node_to_add, nothing)]))
        #Rajout du noeud



    end
    Graph(name(graph), nodes(graph), arete_arbre_min)


end

