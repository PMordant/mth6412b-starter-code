include("kruskal.jl")
"""Test de l'algorithme kruskal sur toutes les instances stsp. kruskal faisant appel à create_graph, nous pouvons également vérifier
que les tests unitaires associés à create_graph sont toujours validés.
"""
path = "projet\\instances\\stsp\\"
for file in readdir(path)
    kruskal(path*file)
    println("Test passé :"*file)
end
