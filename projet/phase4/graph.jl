include("node.jl")
include("edge.jl")
import Base.show
using Test
"""Type abstrait dont d'autres types de graphes dériveront."""
abstract type AbstractGraph{T} end

"""Type representant un graphe comme un ensemble de noeuds.

Exemple :

    node1 = Node("Joe", 3.14)
    node2 = Node("Steve", exp(1))
    node3 = Node("Jill", 4.12)
    G = Graph("Ick", [node1, node2, node3])

Attention, tous les noeuds doivent avoir des données de même type.
"""
mutable struct Graph{T} <: AbstractGraph{T}
  name::String
  nodes::Vector{Node{T}}
  edges::Vector{Edge{T}}
end



" Prend en argument un vecteur de noeuds et une arête et renvoie le couple des 2 noeuds dont les noms sont donnés dans l'arête
function find_nodes(nodes::Vector{Node{T}},edge ::Edge) where T
  sommet1, sommet2 = sommets(edge)
  lis_noeuds = Node{T}[]
  for node in nodes
    if node.name == sommet1 || node.name == sommet2
      push!(lis_noeuds, node)
    end
  end
  if lis_noeuds[1].name == sommet2
    return [lis_noeuds[2], lis_noeuds[1]]
  else
    return lis_noeuds
  end

end"



"""Renvoie le nom du graphe."""
name(graph::AbstractGraph) = graph.name

"""Renvoie la liste des noeuds du graphe."""
nodes(graph::AbstractGraph) = graph.nodes

""" Renvoie la liste des aretes du graphe. """
edges(graph::AbstractGraph) = graph.edges

"""Renvoie le nombre de noeuds du graphe."""
nb_nodes(graph::AbstractGraph) = length(nodes(graph))

""" Renvoie le nombre d'arêtes du graphe. """
nb_edges(graph::AbstractGraph) = length(edges(graph))

"""Ajoute un noeud au graphe."""
function add_node!(graph::Graph{T}, node::Node{T}) where T
  push!(nodes(graph), node)
  graph
end

"""Ajoute une arete au graphe. """
function add_edge!(graph::Graph{T}, edge:: Edge{T}) where T
  if poids(edge) != 0
    push!(edges(graph), edge)
  end
  graph
end

""" Trouve les arêtes reliées à un noeud dont le nom est passé en argument"""
function find_edges(node_name::String, graph::Graph{T}) where T
  lis_aretes = Edge{T}[]
  for edge in edges(graph)
    if name(sommets(edge)[1]) == node_name || name(sommets(edge)[2]) == node_name
      push!(lis_aretes, edge)
    end
  end
  lis_aretes
end


"""Affiche un graphe"""
function show(graph::Graph)
  println("Graph ", name(graph), " has ", nb_nodes(graph), " nodes.")
  for node in nodes(graph)
    show(node)
  end


  println("Graph ", name(graph), " has ", nb_edges(graph), " edges.")
  for edge in edges(graph)
    show(edge)
  end
end

""" Calcule le poids total d'un graphe"""
function poids_total(graph::Graph)
  sum_weights = 0
  for edge in edges(graph)
    sum_weights += poids(edge)
  end
  sum_weights
end

""" Calcule la matrice d'adjacence d'un graphe """
function mat_adjacence(graphe::Graph)
  lis_edges = edges(graphe)
  n = length(nodes(graphe))
  mat_edges = Array{Any}(undef, n, n)
  for edge in lis_edges
    ind1 = parse(Int, name(sommets(edge)[1]))
    ind2 = parse(Int, name(sommets(edge)[2]))
    mat_edges[ind1,ind2] = edge
    mat_edges[ind2,ind1] = edge
  end
  mat_edges

end