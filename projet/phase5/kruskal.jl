import Base.length, Base.push!, Base.popfirst!
import Base.show
include("create_graph.jl")





""" Prend une composante connexe et un noeud et vérifie si le noeud est dans cette composante"""
function isinConnex(connex:: Connex, node_to_find:: Node)
    for node in nodes(connex)
        if name(node) == name(node_to_find)
            return true
        
        end
    end
    return false
end

"""Prend une liste de composantes connexes et un noeud et renvoie la composante connexe à laquelle appartient le noeud, en 
la supprimant de la liste"""
function find_connex!(lis_connex, node_to_find)
    n = length(lis_connex)
    i = 1
    while i <= n && (isinConnex(lis_connex[i], node_to_find) == false)
        i = i + 1
    end
    connex = lis_connex[i]
    deleteat!(lis_connex, i)
    return connex

end





"""Applique l'algorithme de Kruskal sur un graphe dont le nom est donné en argument."""
function kruskal(filename::String)
    graphe = create_graph(filename)
    kruskal(graphe)
end

"""Applique l'algorithme de Kruskal sur un graphe"""
function kruskal(graphe)
    lis_nodes = nodes(graphe)

    lis_edges = edges(graphe) #déjà trié par poids croissant
    sort(lis_edges, by = x -> poids(x))

    lis_connex= []
    #On initialise la liste des composantes connexes à une liste de n singletons
    for node in lis_nodes 
        push!(lis_connex, Connex([node]))
    end

    T = typeof(data(lis_nodes[1]))
    lis_aretes = Edge{T}[] #liste des aretes gardées dans l'arbre minimal

    while length(lis_connex) >= 2 #tant qu'on a plus d'une composante connexe on continue de chercher d'autres arêtes
        arete = popfirst!(lis_edges)

        connex1 = find_connex!(lis_connex, Node(name(sommets(arete)[1]), []))
        if isinConnex(connex1, Node(name(sommets(arete)[2]), []))
            push!(lis_connex, connex1) #On remet la composante connexe enlevée dans la liste.
        else
            #On cherche la composante connexe du 2ème sommet, on rajoute l'arête à la liste des arêtes pertinentes 
            #et on fusionne les 2 composantes connexes.
            connex2 = find_connex!(lis_connex, Node(name(sommets(arete)[2]), []))
            push!(lis_aretes, arete)
            connex_fusionne = merge!(connex1, connex2)
            push!(lis_connex,connex_fusionne)
            
        end

        #test qu'on a le bon nombre de noeuds dans toutes les composantes connexes
        somme_noeuds = 0
        for i=1 : length(lis_connex)
            somme_noeuds += nb_nodes(lis_connex[i])
        end
    end

    #Avec ces 2 tests on est sûr d'avoir un arbre de recouvrement ; la minimalité est garantie par le fait que les arêtes sont triées 
    #par ordre de poids croissant, testé à la fin de create_graph et testé "localement" à chaque itération.
    
    Graph("Arbre recouvrement minimal",lis_nodes,lis_aretes)
    
end