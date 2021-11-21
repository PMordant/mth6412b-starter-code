include("node.jl")
include("edge.jl")
include("graph.jl")
include("connexe.jl")
include("read_stsp.jl")

""" Prend en argument un dictionnaire associant à chaque noeud un rang, un dictionnaire associant à chaque noeud son parent
dans l'arbre de recherche, et 2 composantes connexes à fusionner. Renvoie une composante connexe contenant les 2 CC passées en argument
fusionnées avec la méthode de l'union via le rang. Modifie en place les dictionnaires de rang et de parent.
"""
function heuristique1!(dico_rang::Dict{String,Any}, dico_parents::Dict{String,Any},  connex1::Connex, connex2::Connex)
    max_rang1= 0
    sommet_max1 = nodes(connex1)[1]
    max_rang2 = 0
    sommet_max2 = nodes(connex2)[1]

    for sommet in nodes(connex1)
        if dico_rang[name(sommet)]> max_rang1
            max_rang1 = dico_rang[name(sommet)]
            sommet_max1 = sommet
        end
    end

    for sommet in nodes(connex2)
        if dico_rang[name(sommet)]> max_rang2
            max_rang2 = dico_rang[name(sommet)]
            sommet_max2 = sommet
        end
    end
    
    if max_rang1 > max_rang2
        dico_parents[name(sommet_max2)] = name(sommet_max1)
    else 
        if max_rang2 > max_rang1
            dico_parents[name(sommet_max1)] = name(sommet_max2)
        else
            dico_parents[name(sommet_max2)] = name(sommet_max1)
            dico_rang[name(sommet_max1)] += 1
        end
    end
   
    merge!(connex1,connex2)
end


""" Prend en argument un noeud dont on cherche l'ancêtre, le dictionnaire des parents des noeuds et des rangs des noeuds.
Renvoie l'ancêtre de ce noeud en mettant à jour les dictionnaires des parents et des rangs selon la méthode de compression des chemins
"""
function heuristique2!(noeud::Node,dico_parents::Dict)
    lis_parents = []
    parent =  name(noeud)

    while dico_parents[parent] != nothing
        push!(lis_parents, parent)
        parent = dico_parents[parent]
    end
    #parent correspond maintenant au nom de la racine de l'arbre de recherche 

    for sommet in lis_parents
        dico_parents[sommet] = parent
        #lis_parents s'arrête au fils de parent, on ne modifie donc pas dico_parents[parent]
    end

    parent
end

