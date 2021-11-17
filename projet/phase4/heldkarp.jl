include("prim.jl")

function min1tree(graph::Graph,racine::Node)
    lis_nodes = copy(graph.nodes)
    lis_edges = copy(graph.edges)
    filter!(n -> n.name!= racine.name, lis_nodes)
    aretes_racine = find_edges(racine.name,graph)
    filter!(e -> e.sommet1.name != racine.name && e.sommet2.name != racine.name, lis_edges)
    mst = prim(Graph(graph.name,lis_nodes,lis_edges))

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
    end
    push!(mst.edges, edge1)
    push!(mst.edges, edge2)
    push!(mst.nodes, racine)
    mst
end

function degrees(graph::Graph)
    d = zeros(length(graph.nodes))
    for edge in graph.edges
        d[parse(Int, edge.sommet1.name)] += 1
        d[parse(Int, edge.sommet2.name)] += 1
    end
    d
end

function array_edge_tree(tree)
    mat_edges = Dict{String,Any}()
    for node in nodes(tree)
        mat_edges[node.name] = []
    end
    for edge in edges(tree)
        for sommet in sommets(edge)
            push!(mat_edges[sommet.name], edge)
        end
    end
    mat_edges

end

function tree_to_tour(mat_adjacence, tree, mat_tree)
    d = degrees(tree)
    if d.-2 == zeros(length(nodes(tree)))
        tree
    else
        i_modif = "0"
        for i = 1 : length(nodes(tree))
            if d[i] == 1
                i_modif = string(i)
            end
        end

        sommet_prec = i_modif
        derniere_edge = mat_tree[i_modif][1]
        edge_suiv = derniere_edge
        sommet_suiv = sommet_prec
        for sommet in sommets(derniere_edge)
            if sommet.name != sommet_prec
                sommet_suiv = sommet.name
            end
        end

        while d[parse(Int, sommet_suiv)] <= 2
            for edge in mat_tree[sommet_suiv]

                if (edge.sommet1.name, edge.sommet2.name) != (derniere_edge.sommet1.name, derniere_edge.sommet2.name)
                    edge_suiv = edge
                end
            end
            sommet_prec = sommet_suiv
            for sommet in sommets(edge_suiv)
                if sommet.name != sommet_prec
                    sommet_suiv = sommet.name
                end
            end
            derniere_edge = edge_suiv
                

            
        end

        poids_min = +Inf
        edge_to_del = derniere_edge
        edge_to_add = derniere_edge

        for edge in mat_tree[sommet_suiv]
            if (edge.sommet1.name, edge.sommet2.name) != (derniere_edge.sommet1.name, derniere_edge.sommet2.name)
                autre_sommet = sommet_suiv
                for sommet in sommets(edge)
                    if sommet.name != sommet_suiv
                        autre_sommet = sommet.name
                    end
                end
                if poids(mat_adjacence[parse(Int, autre_sommet),parse(Int,i_modif)]) - poids(mat_adjacence[parse(Int, autre_sommet),parse(Int, sommet_suiv)]) <= poids_min
                    edge_to_del = edge
                    edge_to_add = mat_adjacence[parse(Int, autre_sommet),parse(Int,i_modif)]
                end
            end
        end

        for sommet in sommets(edge_to_del)
            filter!(e -> e.sommet1.name != edge_to_del.sommet1.name || e.sommet2.name != edge_to_del.sommet2.name, mat_tree[sommet.name])
        end
        for sommet in sommets(edge_to_add)
            push!(mat_tree[sommet.name],edge_to_add)
        end


        filter!(e -> e.sommet1.name != edge_to_del.sommet1.name || e.sommet2.name != edge_to_del.sommet2.name, edges(tree))
        push!(edges(tree), edge_to_add)

        tree_to_tour(mat_adjacence,tree,mat_tree)
    end
        
    





end




function heldkarp(graph::Graph, racine::Node, step_size::Float64,nb_iter::Int, afficher::Bool)
    T = typeof(racine.data)
    k = 0
    Pi = zeros(length(graph.nodes))
    W = -Inf
    d = zeros(length(graph.nodes))
    v = d.-2
    matrice_adjacence = mat_adjacence(graph)
    graph_modifie = Graph(graph.name,copy(graph.nodes),copy(graph.edges))
    min1_tree = min1tree(graph_modifie,racine)
    step_effectif = step_size

    while v != zeros(length(graph.nodes)) && k <= nb_iter
        wk = poids_total(min1_tree) - 2*sum(Pi)
        W = max(W,wk)
        d = degrees(min1_tree)
        v = d.-2
        if k<= nb_iter/10
            step_effectif = 100*step_size
        elseif k <= nb_iter/2
            step_effectif = 10*step_size
        else 
            step_effectif = step_size
        end

        Pi = Pi + step_effectif * v
        lis_edges = Edge{T}[]
        for edge in graph_modifie.edges
            push!(lis_edges, Edge(edge.sommet1, edge.sommet2, edge.poids +  step_size*v[parse(Int, edge.sommet1.name)] + step_size*v[parse(Int, edge.sommet2.name)]))
        end
        graph_modifie= Graph(graph_modifie.name,graph_modifie.nodes,lis_edges)
        k += 1
        if afficher && k%(nb_iter//10) == 0
            println(W)
        end
        min1_tree = min1tree(graph_modifie,racine)


    end
    println("Maximum obtenu pour w :"*string(W))
    tour = tree_to_tour(matrice_adjacence, min1_tree,array_edge_tree(min1_tree))

    lis_edges_reel = Edge{T}[]
    for edge in edges(tour)
        push!(lis_edges_reel, matrice_adjacence[parse(Int,edge.sommet1.name),parse(Int,edge.sommet2.name)])
    end

    tour_reel = Graph(tour.name,nodes(tour),lis_edges_reel)
    tour_reel,poids_total(tour_reel)
end

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
        println(node.name* " : "*string(poids_arbre))
    end

    graph_min, poids_min, node_min
end
