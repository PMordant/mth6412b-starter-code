include("graph.jl")
include("connexe.jl")
include("read_stsp.jl")


"""Prend en argument un nom de fichier tsp et renvoie un graphe composé de ses noeuds et de ses arêtes, triées par ordre de poids 
croissant
"""
function create_graph(filename::String) 
    graph_nodes,graph_edges = read_stsp(filename)
    if length(graph_nodes) == 0
        T = Vector{Any}
    else
        T = Vector{Float64}
    end
    n = length(graph_edges)

    lis_nodes = Vector{Node{T}}(undef,n)


    if length(graph_nodes) == 0
        for k =1 : n
            lis_nodes[k] = Node{T}(string(k), [])
        end
    else
        for k =1 : n
            lis_nodes[k] = Node{T}(string(k) , graph_nodes[k])
        end
    end
    
    triplets_edges = [] #On stocke d'abord les arêtes sous forme de triplets pour pouvoir les trier plus simplement après
    for k =1 : length(graph_edges)
        for l = 1 : length(graph_edges[k]) 
            if k < graph_edges[k][l][1] && graph_edges[k][l][2] != 0     # Pas de répétitions d'arêtes et pas d'arêtes de poids nul

                sommet1 = Node("0",[])
                sommet2 = Node("0",[])
                for noeud in lis_nodes
                    
                    if noeud.name == string(k)
                        sommet1 = noeud
                    end
                    if noeud.name == string(graph_edges[k][l][1])
                        sommet2 = noeud
                    end
                end
                push!(triplets_edges, (sommet1, sommet2 , graph_edges[k][l][2] ))  
            end 
        end
    end
    if length(triplets_edges) == 0 #situation où les arêtes sont données dans un sens inverse (dans gr17.stsp par exemple)
        for k =1 : length(graph_edges)
            for l = 1 : length(graph_edges[k]) 
                if k > graph_edges[k][l][1] && graph_edges[k][l][2] != 0     # Pas de répétitions d'arêtes et pas d'arêtes de poids nul

                    sommet1 = Node("0",[])
                    sommet2 = Node("0",[])
                    for noeud in lis_nodes
                        
                        if noeud.name == string(k)
                            sommet1 = noeud
                        end
                        if noeud.name == string(graph_edges[k][l][1])
                            sommet2 = noeud
                        end
                    end
                    push!(triplets_edges, (sommet1, sommet2 , graph_edges[k][l][2] ))  
                end 
            end
        end
    end 



    sort!(triplets_edges, by = x -> x[3])                 # On trie les arêtes par ordre croissant de poids.


    lis_edges = Edge{T}[]

    for triplet in triplets_edges
        push!(lis_edges, Edge(triplet[1], triplet[2], Float64(triplet[3])))
    end

    Graph(filename,lis_nodes, lis_edges)
    

end

"""Fonction prenant en argument un vecteur de noeuds avec en données des couples de flottants et un vecteur d'arêtes et trace le graphe 
correspondant.
"""
function plot_graph(noeuds::Vector{Node{Vector{Float64}}}, edges::Vector{Edge{Vector{Float64}}})
    fig = plot(legend=false)
    # edge positions
    for k = 1 : length(edges)
      noeud1 = edges[k].sommet1
      noeud2 = edges[k].sommet2
        plot!([noeud1.data[1], noeud2.data[1]], [noeud1.data[2],noeud2.data[2]],
            linewidth=1.5, alpha=0.75, color=:lightgray)
    end

  
    # node positions
    x = []
    y = []
    for k =1 : length(noeuds)
        push!(x,noeuds[k].data[1])
        push!(y,noeuds[k].data[2]) 
    end
    scatter!(x, y)
  
    fig
  end
  
  
  
  """Fonction de commodité qui lit un fichier stsp et trace le graphe."""
  function plot_graph(filename::String)
    graph = create_graph(filename)
    plot_graph(graph.nodes, graph.edges)
  end
  

