import Base.length, Base.push!, Base.popfirst!
import Base.show
using Test
include("create_graph.jl")





""" Prend une composante connexe et un noeud et vérifie si le noeud est dans cette composante"""
function isinConnex(connex:: Connex, node_to_find:: Node)
    for node in nodes(connex)
        if node.name == node_to_find.name
            return true
        
        end
    end
    return false
end

"""Prend une liste de composantes connexes et un noeud et renvoie la composante connexe à laquelle appartient le noeud, en 
la supprimant de la liste"""
function find_connex!(lis_connex, node_to_find)
    n = length(lis_connex)
    for i = 1 :  n
        if isinConnex(lis_connex[i], node_to_find)
            connex = lis_connex[i]
            deleteat!(lis_connex, i)

            @test length(lis_connex) == n-1 #test qu'on a bien enlevé la composante connexe de la liste 
            

            return connex
        end
    end
    
end





"""Applique l'algorithme de Kruskal sur un graphe dont le nom est donné en argument."""
function kruskal(filename::String)
    graphe = create_graph(filename)

    lis_nodes = nodes(graphe)
    @test length(lis_nodes) > 0

    lis_edges = edges(graphe) #déjà trié par poids croissant
    lis_connex= []
    #On initialise la liste des composantes connexes à une liste de n singletons
    for node in lis_nodes 
        push!(lis_connex, Connex([node]))
    end
    @test length(lis_connex) == length(lis_nodes)

    lis_aretes = Edge[] #liste des aretes gardées dans l'arbre minimal

    while length(lis_connex) >= 2 #tant qu'on a plus d'une composante connexe on continue de chercher d'autres arêtes
        arete = popfirst!(lis_edges)
        @test poids(arete) <= poids(lis_edges[1]) #On vérifie que le poids de l'arête est bien inférieur à celui de la suivante.

        connex1 = find_connex!(lis_connex, Node(arete.sommet1, []))
        if isinConnex(connex1, Node(arete.sommet2, []))
            push!(lis_connex, connex1) #On remet la composante connexe enlevée dans la liste.
        else
            #On cherche la composante connexe du 2ème sommet, on rajoute l'arête à la liste des arêtes pertinentes 
            #et on fusionne les 2 composantes connexes.
            connex2 = find_connex!(lis_connex, Node(arete.sommet2, []))
            push!(lis_aretes, arete)
            connex_fusionne = merge!(connex1, connex2)
            push!(lis_connex,connex_fusionne)
            
        end

        #test qu'on a le bon nombre de noeuds dans toutes les composantes connexes
        somme_noeuds = 0
        for i=1 : length(lis_connex)
            somme_noeuds += nb_nodes(lis_connex[i])
        end
        @test somme_noeuds == length(lis_nodes)
    end

    @test length(lis_connex) == 1 #On vérifie qu'on a qu'une seule composante connexe
    @test length(lis_aretes) == length(lis_nodes)-1 #Si la propriété est vérifiée, on a un arbre de recouvrement.

    #Avec ces 2 tests on est sûr d'avoir un arbre de recouvrement ; la minimalité est garantie par le fait que les arêtes sont triées 
    #par ordre de poids croissant, testé à la fin de create_graph et testé "localement" à chaque itération.
    
    Graph("Arbre recouvrement minimal",lis_nodes,lis_aretes)
    
end