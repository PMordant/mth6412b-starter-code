include("rsl.jl")


"""Prend en argument un graphe et un noeud et crée un 1-tree minimal pour ce graphe avec 2 arêtes liées au noeud
"""
function min1tree(graph::Graph,racine::Node)
    lis_nodes = copy(nodes(graph))
    lis_edges = copy(edges(graph))
    filter!(n -> name(n)!= name(racine), lis_nodes)
    aretes_racine = find_edges(name(racine),graph)
    filter!(e -> name(sommets(e)[1]) != name(racine) && name(sommets(e)[2]) != name(racine), lis_edges)
    mst = prim(Graph(name(graph),lis_nodes,lis_edges)) #Calcul d'un MST sur le graphe privé du noeud racine
    

    min1 = Inf
    min2 = Inf
    edge1 = nothing
    edge2 = nothing
    for edge in aretes_racine
        if poids(edge) < min1
            edge2 = edge1
            min2 = min1
            edge1 = edge
            min1 = poids(edge)
        elseif poids(edge) < min2
            edge2 = edge
            min2 = poids(edge)
        end
    end #Calcul des 2 arêtes les plus légères reliées au noeud racine
    push!(edges(mst), edge1)
    push!(edges(mst), edge2)
    push!(nodes(mst), racine)
    mst
end

"""Prend en argument un graphe et renvoie le tableau des degrés de chaque noeud
"""
function degrees(graph::Graph)
    d = zeros(length(nodes(graph)))
    for edge in edges(graph)
        d[parse(Int, name(sommets(edge)[1]))] += 1
        d[parse(Int, name(sommets(edge)[2]))] += 1
    end
    d
end

"""Prend en argument un graphe non complet (typiquement un 1-tree ici) et renvoie un dictionnaire qui à chaque noeud associe la liste des
arêtes reliées à ce noeud.
"""
function array_edge_tree(tree)
    mat_edges = Dict{String,Any}()
    for node in nodes(tree)
        mat_edges[name(node)] = []
    end
    for edge in edges(tree)
        for sommet in sommets(edge)
            push!(mat_edges[name(sommet)], edge)
        end
    end
    mat_edges

end


"Prend en argument un 1-tree tree, la 'matrice d'adjacence' du 1-tree calculée avec array_edge_tree mat_tree
et la matrice d'adjacence du graphe initial mat_adjacence qu'on suppose complet.
Renvoie une tournée calculée en rajoutant une arête à tous les sommets de degré 1 rencontré"
function tree_to_tour(mat_adjacence, tree, mat_tree)
    d = degrees(tree)
    if d.-2 == zeros(length(nodes(tree))) #Cas de base : on a déjà une tournée
        tree
    else
        i_modif = "0"
        for i = 1 : length(nodes(tree))
            if d[i] == 1
                i_modif = string(i)
            end
        end #On détermine un i à modifier : correspond à un noeud de degré 1 (choix arbitraire non optimisé).

        sommet_prec = i_modif
        derniere_edge = mat_tree[i_modif][1]
        edge_suiv = derniere_edge
        sommet_suiv = sommet_prec
        for sommet in sommets(derniere_edge)
            if name(sommet) != sommet_prec
                sommet_suiv = name(sommet)
            end
        end 

        while d[parse(Int, sommet_suiv)] <= 2
            for edge in mat_tree[sommet_suiv]

                if (name(sommets(edge)[1]), name(sommets(edge)[2])) != (name(sommets(derniere_edge)[1]), name(sommets(derniere_edge)[2]))
                    edge_suiv = edge
                end #on détermine l'arête qui n'est pas celle d'où l'on vient et qui est reliée au sommet suivant
            end
            sommet_prec = sommet_suiv
            for sommet in sommets(edge_suiv)
                if name(sommet) != sommet_prec
                    sommet_suiv = name(sommet)
                end
            end #on update les sommets précédents, suivants.
            derniere_edge = edge_suiv
            #derniere_edge correspond à l'arête entre sommet_prec et sommet_suiv

            
        end
        #On remonte le 1-tree pour trouver le sommet de degré supérieur strictement à 2 le plus proche du noeud à modifier
        #On le garde en mémoire sous le nom sommet_suiv et on garde la dernière arête sous le nom derniere_edge

        poids_min = +Inf
        edge_to_del = derniere_edge
        edge_to_add = derniere_edge

        #On va parcourir les arêtes reliées au sommet suivant pour déterminer laquelle il est le moins coûteux d'enlever en en rajoutant
        #une entre l'autre sommet relié à sommet_suivant et le sommet initial.
        #Nécessite que le graphe soit complet.
        for edge in mat_tree[sommet_suiv]
            if (name(sommets(edge)[1]), name(sommets(edge)[2])) != (name(sommets(derniere_edge)[1]), name(sommets(derniere_edge)[2]))
                autre_sommet = sommet_suiv
                for sommet in sommets(edge)
                    if name(sommet) != sommet_suiv
                        autre_sommet = name(sommet)
                    end
                end
                if poids(mat_adjacence[parse(Int, autre_sommet),parse(Int,i_modif)]) - poids(mat_adjacence[parse(Int, autre_sommet),parse(Int, sommet_suiv)]) <= poids_min
                    edge_to_del = edge
                    edge_to_add = mat_adjacence[parse(Int, autre_sommet),parse(Int,i_modif)]
                end
            end
        end

        for sommet in sommets(edge_to_del)
            filter!(e -> name(sommets(e)[1]) != name(sommets(edge_to_del)[1]) || name(sommets(e)[2]) != name(sommets(edge_to_del)[2]), mat_tree[name(sommet)])
        end
        for sommet in sommets(edge_to_add)
            push!(mat_tree[name(sommet)],edge_to_add)
        end #On update mat_tree pour qu'elle colle au nouveau 1-tree


        filter!(e -> name(sommets(e)[1]) != name(sommets(edge_to_del)[1]) || name(sommets(e)[2]) != name(sommets(edge_to_del)[2]), edges(tree))
        push!(edges(tree), edge_to_add)
        #On update le 1_tree

        tree_to_tour(mat_adjacence,tree,mat_tree)
        #On effectue un appel récursif : on sait que le nombre de sommets de degré inférieur strictement à 2 a baissé de exactement 1 et 
        #le nombre d'arêtes du 1-tree n'a pas été modifié d'où la terminaison de la fonction et la garantie d'obtenir une tournée.
    end
        
    





end



"""Prend en argument un graphe, un noeud de départ, un taux d'apprentissage et un nombre d'itérations (hyperparamètres à choisir pour
améliorer la performance de l'algorithme) et un booléen pour afficher ou non l'évolution de la valeur W tous les dixièmes de nb_iter.
Applique l'algorithme de Held et Karp sur ce graphe avec ces paramètres et transforme le 1_tree obtenu en tournée avec la fonction 
tree_to_tour avant de reconstruire le graphe pour avoir une tournée avec les poids exacts des arêtes.
"""
function heldkarp(graph::Graph, racine::Node, step_size::Float64,nb_iter::Int, afficher::Bool=false)
    T = typeof(data(racine))
    k = 0
    Pi = zeros(length(nodes(graph)))
    W = -Inf
    d = zeros(length(nodes(graph)))
    v = d.-2
    matrice_adjacence = mat_adjacence(graph)
    graph_modifie = Graph(name(graph),copy(nodes(graph)),copy(edges(graph)))
    min1_tree = min1tree(graph_modifie,racine)

    while v != zeros(length(nodes(graph))) && k <= nb_iter
        wk = poids_total(min1_tree) - 2*sum(Pi)
        W = max(W,wk)
        d = degrees(min1_tree)
        v = d.-2
        Pi = Pi + step_size * v


        lis_edges = Edge{T}[]
        for edge in edges(graph_modifie)
            push!(lis_edges, Edge(sommets(edge)[1], sommets(edge)[2], poids(edge) +  step_size*v[parse(Int, name(sommets(edge)[1]))] + step_size*v[parse(Int, name(sommets(edge)[2]))]))
        end

        graph_modifie= Graph(name(graph_modifie),nodes(graph_modifie),lis_edges)
        k += 1
        
        if afficher && k%(nb_iter//10) == 0
            println(W)
        end

        min1_tree = min1tree(graph_modifie,racine)


    end
    #println("Maximum obtenu pour w :" *string(W))
    tour = tree_to_tour(matrice_adjacence, min1_tree,array_edge_tree(min1_tree))

    lis_edges_reel = Edge{T}[]
    for edge in edges(tour)
        push!(lis_edges_reel, matrice_adjacence[parse(Int,name(sommets(edge)[1])),parse(Int,name(sommets(edge)[2]))])
    end #On reconstruit la bonne tournée avec les bons poids

    tour_reel = Graph(name(tour),nodes(tour),lis_edges_reel)
    tour_reel,poids_total(tour_reel)
end

""" Permet de prendre l'indice du noeud de départ plutôt que le noeud de départ en argument."""
function heldkarp(graph::Graph, ind_racine::Int, step_size::Float64,nb_iter::Int, afficher::Bool=false)
    heldkarp(graph,nodes(graph)[ind_racine],step_size,nb_iter,afficher)
end

""" Applique l'algorithme de Held et Karp sur le graphe en utilisant tous les noeuds de départ pour un taux d'apprentissage et un 
nombre d'itérations maximal passés en argument. """
function test_hk(graphe::Graph,step_size::Float64,nb_iter::Int)  
    poids_min = Inf
    T = typeof(graphe.nodes[1].data)
    graph_min = Graph("",Node{T}[],Edge{T}[])
    node_min = nodes(graphe)[1]

    for node in nodes(graphe)
        arbre,poids_arbre = heldkarp(graphe,node,step_size,nb_iter, false)
        if poids_arbre < poids_min
            graph_min = arbre
            poids_min = poids_arbre
            node_min = node
            println("Amélioré")
        end
        println(name(node)* " : "*string(poids_arbre))
    end

    graph_min, poids_min, node_min
end


