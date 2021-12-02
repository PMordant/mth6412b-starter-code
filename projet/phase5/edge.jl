import Base.show

"""Type abstrait dont d'autres types de noeuds dériveront."""
abstract type AbstractEdge{T} end

"""Type représentant les arêtes d'un graphe.

Exemple:

        arete = ("1", "2", 3) correspond à l'arete reliant le sommet nommé "1" et le sommet nommé "2", et de poids 3

"""
mutable struct Edge{T} <: AbstractEdge{T}
  sommet1::Node{T}
  sommet2::Node{T}
  poids::Float64
end



"""Renvoie les sommets de l'arête."""
sommets(edge::AbstractEdge) = (edge.sommet1, edge.sommet2)

"""Renvoie le poids de l'arête."""
poids(edge::AbstractEdge) = edge.poids

"""Affiche une arête."""
function show(edge::AbstractEdge)

  println("Edge ", sommets(edge), ", poids: ", poids(edge))


end
