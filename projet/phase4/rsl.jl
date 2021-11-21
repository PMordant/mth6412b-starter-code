include("prim.jl")


"""Prend en argument un arbre de recouvrement graphe et un noeud racine. Parcourt l'arbre en préordre et renvoie la liste des noeuds
visités dans l'ordre 
"""
function preordre(graphe::Graph, racine::Node)
    lis_noeuds = [racine]
    lis_edges = find_edges(name(racine),graphe)
    edges_graph = copy(edges(graphe))
    for edge in lis_edges
        if name(sommets(edge)[1]) == name(racine)
            autre_sommet = sommets(edge)[2]
        else
            autre_sommet = sommets(edge)[1]
        end
        edges2 = filter!(e -> sommets(e) != sommets(edge), edges_graph)
        graph2 = Graph("Graphe fils", nodes(graphe), edges2)
        lis_noeuds = vcat(lis_noeuds, preordre(graph2,autre_sommet))    
    end
    lis_noeuds
end



"""Utilise l'algorithme RSL sur un graphe graphe, en prenant comme noeud de départ racine et en utilisant l'algorithme de Prim ou 
de Kruskal selon la valeur de la chaîne de caractères algo ('Prim' -> Prim, autre chose -> Kruskal)
"""
function rsl(graphe::Graph, racine::Node, algo::String)
    mat_edges = mat_adjacence(graphe)
    copy_graph = Graph(name(graphe),copy(nodes(graphe)), copy(edges(graphe)))
    if algo == "prim"
        arbre = prim(copy_graph,racine)
    else
        arbre = kruskal(copy_graph)
    end
    lis_noeuds = preordre(arbre,racine)

    T = typeof(data(racine))
    lis_aretes = Edge{T}[]

    for i in 1:length(lis_noeuds)-1
        push!(lis_aretes, mat_edges[parse(Int, name(lis_noeuds[i])), parse(Int, name(lis_noeuds[i+1])) ])
    end
    push!(lis_aretes, mat_edges[parse(Int, name(lis_noeuds[length(lis_noeuds)])), parse(Int, name(lis_noeuds[1]))])


    tournee = Graph("Tour_RSL"*name(graphe), nodes(graphe), lis_aretes)
    tournee
end


function test_conditions(graph::Graph)
    mat = mat_adjacence(graph)
    n = length(nodes(graph))
    verif = true
    i_err = 0
    j_err = 0
    k_err = 0
    for i in 1:n 
        for j in i+1:n
            for k in 1:n
                if k !=i && k != j 
                    if poids(mat[i,j]) > poids(mat[i,k]) + poids(mat[k,j])
                        verif = false
                        i_err = i
                        j_err = j
                        k_err = k
                    end
                end
            end
        end
    end
    verif,i_err,j_err,k_err

end
"""Pour un graphe, utilise l'algorithme de RSL en prenant chaque noeud comme noeud de départ et en utilisant Prim et Kruskal et renvoie
la tournée de poids minimal trouvée
"""
function min_rsl(graphe::Graph)
    T = typeof(data(nodes(graphe)[1]))
    poids_min = Inf
    graph_min = Graph("",Node{T}[],Edge{T}[])
    racine_min = nothing
    verif = test_conditions(graphe)
    if !verif[1]
        println("Conditions non vérifiées sur les indices "*string(verif[2])*", "*string(verif[3])*", "*string(verif[4])*" : pas de garanties sur le résultat de RSL")
    end
    for node in nodes(graphe)
        racine = node
        graph1 = rsl(graphe,racine,"prim")
        graph2 = rsl(graphe,racine,"kruskal")
        if poids_total(graph1) < poids_min
            graph_min = graph1
            poids_min = poids_total(graph1)
            racine_min = racine
        end
        if poids_total(graph2) < poids_min
            graph_min = graph2
            poids_min = poids_total(graph2)
            racine_min = racine
        end
    end
    graph_min,poids_min,racine_min
end




