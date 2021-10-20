import Base.show


"""Type abstrait dont d'autres types d'arbres connexes dériveront."""
abstract type AbstractConnex{T} end

"""Type représentant un arbre connexe avec des éléments de type T."""
mutable struct Connex{T} <: AbstractConnex{T}
    nodes::Vector{Node{T}}
end


"""Ajoute un noeud au sous-graphe."""
function add_node!(connex::Connex{T}, node::Node{T}) where T
  push!(connex.nodes, node)
  connex
end



"""Renvoie la liste des noeuds du sous-graphe."""
function nodes(connex::AbstractConnex)
    connex.nodes
end

"""Renvoie le nombre de noeuds du sous-graphe."""
nb_nodes(connex::AbstractConnex) = length(connex.nodes)
  

"""Affiche un graphe"""
function show(connex::Connex)
    println("Connex component ", name(connex), " has ", nb_nodes(connex), " nodes.")
    for node in nodes(connex)
      show(node)
    end
end

function merge!(connex1:: Connex, connex2:: Connex)
  n = nb_nodes(connex1)
  append!(connex1.nodes,connex2.nodes)

  @test nb_nodes(connex1) == n+nb_nodes(connex2)

  connex1
end