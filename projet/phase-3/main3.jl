include("prim.jl")
using Test
"""Test de l'algorithme kruskal sur toutes les instances stsp. kruskal faisant appel à create_graph, nous pouvons également vérifier
que les tests unitaires associés à create_graph sont toujours validés.
"""
path = joinpath("projet", "instances", "stsp")
for file in readdir(path)
    println(file*":")
    println(" ")
    graph_file = @time kruskal(joinpath(path,file))
    graph_file2 = @time prim(joinpath(path,file))

    #Test que le graphe retourné par kruskal est bien un arbre de recouvrement
    for noeud in graph_file.nodes
        @test length(find_edges(noeud.name, graph_file)) >= 1 #Absence de sommets isolés
    end
    @test nb_edges(graph_file) == nb_nodes(graph_file)-1 #un graphe connexe à n-1 arêtes est un arbre de recouvrement


    for noeud in graph_file2.nodes
        @test length(find_edges(noeud.name, graph_file2)) >= 1
    end

    @test nb_edges(graph_file2) == nb_nodes(graph_file2)-1


    @test poids_total(graph_file)==poids_total(graph_file2) 

    #On teste que les deux algorithmes renvoient le même poids qui est très probablement le poids minimal

    println("Tests passés")
    println("Poids minimal : "*string(poids_total(graph_file)))
    println(" ")
    println(" ")
end