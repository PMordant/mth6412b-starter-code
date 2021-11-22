### A Pluto.jl notebook ###
# v0.17.1

using Markdown
using InteractiveUtils

# ╔═╡ 3c04ef1e-26cf-11ec-269d-714e657e0a90
begin
using PlutoUI
using Plots
using Markdown
using InteractiveUtils
end

# ╔═╡ 52c6ffc6-3ced-4465-95c8-c3ff979a5ff3
begin
	path_fonc = joinpath("phase4", "heldkarp.jl")
	include(path_fonc)
end

# ╔═╡ edb29e94-a3b5-42cf-bb38-a4bbe9753dd1


# ╔═╡ ac10181c-501b-44b0-a0f9-5257d37329aa


# ╔═╡ 02181ed8-1f58-4bde-ba30-0d33f6cce8d7
path_instances = joinpath("instances", "stsp")

# ╔═╡ bd96c780-678d-459b-aa23-a166751da087
md"# Ecole polytechnique de Montréal"

# ╔═╡ 0c186ad3-5494-4fa5-9791-5c6a1fbc4fab
md"### MTH6412B		Session Automne  2021 "

# ╔═╡ abc12fa3-0cdd-4c3f-8dc6-6fe41cde8ec9
md"## Rapport de projet"

# ╔═╡ ad90a1be-e044-4d63-920f-5b6c9068b519
md" ### Pierre Mordant & Mahamadou Sarité"

# ╔═╡ 8914a271-58db-45d0-a227-804ac9cdac5b
md"### Phase 4"

# ╔═╡ 4c380476-c375-4da3-a58e-acdb303d3a76
md"Notre code ainsi que ce carnet Pluto sont disponibles sur [ce lien](https://github.com/PMordant/mth6412b-starter-code/tree/Phase-4)"

# ╔═╡ f345a0a0-2342-4488-ac0a-7b3c4f5fe381
begin
md" Dans cette troisième phase du projet sur le problème du voyageur de commerce symétrique, nous avons implémenté les algorithmes de RSL et de HK pour déterminer une tournée dont le coût approche le coût minimal d'une tournée.
  1. Nous avons d'abord effectué quelques modifications/corrections des phases précédentes.
  2. Nous avons implémenté les deux algorithmes.
  3. Nous avons effectué des tests de nos implémentation sur les instances de tsp données."
  
end

# ╔═╡ b64118ca-0d04-4c8c-b375-e267e162c7f6
md" Tout d'abord, nous avons effectué quelques modifications et corrections de notre phase 3. Nous avons ainsi enlevé les dernières balises @test présentes dans le corps des fonctions, et nous avons enlevé les références aux *graph.nodes* pour utiliser les fonctions *nodes(graph)* et les équivalents sur les attributs des types **Node**, **Edge**, **Graph** et **Connex**"
	

# ╔═╡ ee2fe83f-3e55-4bf8-b2a5-706c53c9b5c5
md"Question sur le rang maximal dans un arbre avec l'heuristique 1 : tous les rangs sont initialisés à 0. Quand on appellera l'algorithme de Prim, on aura exactement n-1 itérations avec n le nombre de sommets de l'arbre, donc n-1 appels à la fonction *heuristique1!*. Or, à chaque appel de *heuristique1!*, le rang d'un noeud augmente au plus de 1. Le rang d'un noeud est donc d'au plus n-1."

# ╔═╡ 69d54b10-0cc5-48b8-b3b3-6c53945c2e65
md"De plus, on commence avec $n$ composantes connexes avec chacune 1 sommet. Or, le rang d'un sommet n'augmente que quand on fusionne deux composantes connexes dont les racines ont le même rang. On peut montrer par récurrence, que la racine d'une composante connexe est de rang $k$ si le nombre de sommets de la composante connexe est supérieur ou égal à $2^k$ . L'initialisation est bien vérifiée, et une composante connexe a sa racine de rang $k+1$ si et seulement si elle a été créée par la fusion de 2 composantes connexes de rang $k$, comprenant donc au moins $2^k$ sommets par hypothèse de récurrence. Elle contient donc au moins $2^{k+1}$ sommets ce qui prouve l'hérédité. En reformulant, le rang d'un noeud dans un arbre de taille n est borné par $\lfloor log_{2}(n) \rfloor$" 

# ╔═╡ 085fe42d-c57f-4bc6-8a63-72f48fc88e2a
md"Enfin, sur l'utilité de la fonction heuristique1! placée à la fin de l'algorithme de Prim, elle permet de construire l'arbre de recherche de façon efficace pour avoir un arbre de recherche le moins profond possible. Ainsi la composante connexe *connex\_deja\_traitee* est construite de manière optimale."

# ╔═╡ a9b98776-5e37-4925-8bd4-c667bd20d8a7


# ╔═╡ 068be080-b311-4a5d-af1d-e9cec2a2eda6


# ╔═╡ 37195aed-5d39-44f7-a75f-92122ab7c7d3
md"Nous avons ensuite travaillé pour implémenter l'algorithme de RSL pour calculer une tournée à partir d'un arbre de recouvrement minimal d'un graphe. Nous avons ainsi implémenté une fonction *preordre* parcourant un arbre dont la racine est donnée en argument et indiquant la liste des noeuds visités dans l'ordre : on rajoute la racine à la liste, puis on parcourt les arêtes reliées à cette racine et pour chacune on fait un appel à *preordre* sur le sous-graphe auquel on a enlevé cette arête et dont la racine était l'autre extrêmité de l'arête. On fera ainsi un parcours en préordre de cette composante connexe, avant de revenir aux autres fils de la racine. "

# ╔═╡ 6a46e8ce-5e73-4ab2-b47c-3003ee93da84
md" Nous avons ensuite implémenté la fonction rsl : on construit un arbre de recouvrement minimal avec un algorithme au choix entre Prim et Kruskal (noeud de départ passé en argument pour Prim) puis on parcourt l'arbre avec la fonction *preordre* pour récupérer une liste de noeuds visités dans l'ordre. On rajoute finalement les arêtes correspondantes avant de renvoyer la tournée obtenue. On présente une tournée obtenue de cette manière ci-dessous à partir du graphe bayg29. "

# ╔═╡ 2fb5056b-4ea9-4aeb-b122-08dc7ea695ce
bayg29 = create_graph(joinpath(path_instances,"bayg29.tsp"))

# ╔═╡ 5fd34b54-e8f8-4939-bcd6-e7368a7af5a3
tour_bayg29 = rsl(bayg29, nodes(bayg29)[1], "prim" )

# ╔═╡ 473d557d-3e50-451a-9eab-7ab44240dfb8
plot_graph(nodes(tour_bayg29),edges(tour_bayg29))

# ╔═╡ aa812e7a-15e4-492b-912d-b6139a1de7e4
md" Pour que cet algorithme fonctionne, il est nécessaire que le graphe passé en argument soit complet, ce qui est le cas de tous les graphes disponibles (sauf brg180 sur lequel nous avons un problème de construction et que nous ignorerons dans la suite). On ne vérifie donc pas cette condition. On vérifie cependant que l'inégalité triangulaire est vérifiée pour les graphes considérés avec la fonction *test_conditions* qui renvoie (true,0,0,0) si l'inégalité triangulaire est vérifiée pour tous les sommets, et false avec un exemple de triplets d'indices pour lesquels elle n'est pas vérifiée sinon."

# ╔═╡ ec50db94-f394-4c10-927b-1e1fa34ad728
bays29 = create_graph(joinpath(path_instances,"bays29.tsp"))

# ╔═╡ ba9461a0-31ff-4974-82e6-ca02807c9c5d
test_conditions(bayg29)

# ╔═╡ 6ff5dddf-9d43-485d-9fb0-c7d9183747d8
test_conditions(bays29)

# ╔═╡ a8e36544-c43f-469b-80b6-e4a8fe801ff8
md" Cette condition d'inégalité triangulaire n'est pas nécessaire pour garantir que l'algorithme de RSL tourne : elle est juste nécessaire pour garantir que la tournée obtenue est bien de poids au plus 2 fois supérieur à celui de la tournée optimale. On n'inclut donc pas ce test d'inégalité triangulaire dans la fonction *rsl*. On l'inclut cependant dans la fonction *min_rsl* : cette fonction prend en argument un graphe, et calcule toutes les tournées qu'on peut obtenir en prenant tous les noeuds comme noeud de départ et en utilisant Prim et Kruskal, et renvoie la tournée minimale obtenue, ainsi que son poids et le noeud de départ. Au début de cette fonction, on rajoute un test de l'inégalité triangulaire, pour afficher un avertissement si celle-ci n'est pas vérifiée. On montre un exemple d'une tournée ainsi obtenue ci-dessous." 

# ╔═╡ a520301b-2bc3-452f-aef9-1be9e10046f7
tour_min_bayg29, poids_min_bayg29, noeud_depart_bayg29 = min_rsl(bayg29)

# ╔═╡ e3bf6e4a-4da9-4897-9c86-3863a1373031
plot_graph(nodes(tour_min_bayg29),edges(tour_min_bayg29))

# ╔═╡ 018f5c9d-7d88-4081-9721-87944c5e90d0
md"On a cependant constaté que les tournées trouvées avec *min_rsl* sont toutes moins de 2 fois supérieures au poids de la tournée optimale. On présente tous les résultats obtenus à la fin de ce rapport."

# ╔═╡ 7c089bc5-9252-469a-80cd-c669285b3c31


# ╔═╡ 8943125d-233d-439f-8641-5028ce556fb1


# ╔═╡ 60534fee-514d-4fcc-8555-2bd82dc1d130
 md"Nous avons ensuite travaillé sur l'implémentation de l'algorithme de Held et Karp. On a une fonction w qui calcule le poids d'un 1-tree avec des pénalités sur les sommets dont les degrés sont différents de 2. On sait que cette fonction est toujours inférieure au poids de la tournée optimale et que si elle atteint ce poids, cela signifie que l'on a trouvé la tournée optimale. Pour cela, nous avons commencé par construire une fonction *min1tree* qui prend en argument un graphe et une racine. Elle calcule un arbre de recouvrement minimal (avec l'algorithme de Prim et de noeud de départ par défaut) sur le sous-graphe auquel on a enlevé la racine, puis rajoute les 2 arêtes de coûts minimaux reliées à cette racine pour former un 1-tree.   

On construit ensuite la fonction *heldkarp* : cette fonction va calculer un 1-tree minimal avec la fonction *min1tree* à chaque itération. Tant que ce 1-tree n'est pas une tournée, on va modifier les arêtes pour pénaliser les noeuds de degrés différents de 2. Le vecteur Pi dans le code garde en mémoire les pénalités appliquées à chaque noeud. On va ainsi augmenter la valeur de W, qui est la meilleure évaluation du poids d'un 1-tree ainsi obtenu, auquel on enlève les pénalités appliquées. Une fois qu'on a obtenu une tournée, ou au bout d'un nombre d'itérations maximal, on renvoie le dernier 1-tree obtenu. On a ainsi aucune garantie que ce 1-tree soit une tournée, on va donc utiliser la fonction *tree\_to\_tour* qui transforme un 1_tree ressemblant beaucoup en tournée de manière intuitive. On obtient ainsi une tournée de poids proche du poids optimal.  

On avait construit la fonction *tree\_to\_tour*  de la manière suivante : on parcourt tous les noeuds de degré 1 (normalement peu nombreux après les itérations de *heldkarp*), et on remonte le 1-tree jusqu'à trouver un noeud de degré supérieur ou égal à 3 ; on va alors supprimer une arête reliée à ce noeud, et en rajouter une entre le sommet de degré 1 et l'autre extrêmité de l'arête supprimée. Le choix de cette arête est fait de manière à minimiser le poids total du graphe, et cela ne peut pas être l'arête d'où l'on vient (on détruirait alors la connexité du graphe). 

On présente une tournée ainsi obtenue sur bayg29 ci-dessous." 

# ╔═╡ c2a867c4-0d89-4117-a976-d32beac11e5a
tour_hk_bayg29, poids_hk_bayg29 = heldkarp(bayg29, 16,0.01,10000, false)

# ╔═╡ 26168326-e262-4d78-8db5-11da9f57c576
plot_graph(nodes(tour_hk_bayg29), edges(tour_hk_bayg29))

# ╔═╡ a83a9354-ef22-43bf-b741-99026fdff382
md"La fonction heldkarp dépend ainsi de 3 paramètres : le choix du noeud de départ, le choix du taux d'apprentissage step\_size et le nombre d'itérations maximal. Le nombre d'itérations maximal donne un temps maximal d'éxécution à l'algorithme : il peut ainsi être augmenté sur des plus petits graphes. 

Le taux d'apprentissage indique la vitesse de convergence vers la meilleure valeur de w : plus elle est petite, plus la convergence va être lente. Cependant, plus elle est petite, plus on pourra avoir une bonne approximation de la valeur optimale de w si on se donne un nombre d'itérations élevé. Ici, nous avons fait le choix de garder un taux d'apprentissage constant pendant toutes les itérations. Nous avions aussi essayé de modifier ce taux d'apprentissage pour qu'il soit plus élevé pendant les 10% premières itérations, et plus faible pendant les 50% dernières, pour avoir une vitesse de convergence plus rapide au début et un résultat plus précis finalement mais nous avons remarqué une erreur faussant nos résultats, et nous n'avons pas le temps de recalculer les hyperparamètres optimaux pour obtenir d'autres résultats. 

Finalement le choix de la racine est un paramètre important puisque l'algorithme de Held et Karp risque de construire des 1-tree très différents pour des noeuds de départ différents, même si ils seront de poids similaires. La différence entre ces arbres joue une part importante dans la différence d'efficacité de la fonction *tree\_to\_tour*, puisque les tournée finalement construites pourraient être très différentes. C'est pour cela que nous avons implémenté une fonction *test\_hk* calculant toutes les tournées obtenues avec HK pour tous les noeuds de départ possibles pour des valeurs de step\_size et du nombre d'itérations maximal fixées. Cette fonction a été particulièrement utile pour identifier les tournées de poids les plus faibles possibles (comme le choix de la racine 16 dans le graphe ci-dessus)."

# ╔═╡ 8ecc5eb1-b4ab-4e46-8d8c-07ad03dc916b


# ╔═╡ 23557883-0c02-455d-aa38-a30619644f87
md"Nous avons ainsi obtenu, avec les algorithmes de RSL et de HK les résultats présentés dans le tableau ci-dessous."

# ╔═╡ 8f95be08-938d-48d3-a9ee-4ed3806ff8bc
md"$\begin{aligned}
&\begin{array}{cccccc}
\hline \hline \text { Fichier } & \text { RSL } & \text { HK } & \text { Optimal } & \text{Erreur relative RSL (en \%)} & \text{ Erreur relative HK  }\\
\hline \text{ bayg29 } & 2014 & 1620 & 1610 & 25.1 & 0.6\\
\text{ bays29 } & 2313 & 2039 & 2020 & 14.5 & 0.9\\
\text{ brazil58 }& 28380 & 25475 & 25395 & 11.8 & 0.3 \\
\text{ dantzig42 }& 872 & 719 & 699 & 24.7 & 2.9\\
\text{ fri26 }& 1102 & 937 & 937 & 17.6 & 0\\
\text{ gr120 }& 8859 & 7363 & 6942 & 27.6 & 6.1\\
\text{ gr17 }& 2210 & 2085 & 2085 & 6.0 & 0 \\
\text{ gr21 }& 2998 & 2707 & 2707 & 10.7 & 0 \\
\text{ gr24 }& 1571 & 1272 & 1272 & 23.5 & 0 \\
\text{ gr48 }& 6450 & 5226 & 5046 & 27.8 & 3.5\\
\text{ hk48 }& 13939 & 11525  & 11461 & 21.6 & 0.6\\
\text{ pa561 } & 3875 & 3215 & 2763 & 40.2 & 16.4\\
\text{ swiss42 } & 1591 & 1273 & 1273 & 25.0 & 0\\
\hline
\end{array}
\end{aligned}$"

# ╔═╡ 68108499-4e9d-4f3a-b1e8-854cb6f58807
md"On peut réobtenir ces résultats avec le script *main4.jl*. Les meilleurs paramètres trouvés pour l'algorithme HK sont donnés dans le dictionnaire *dict_args_hk*, tandis qu'on réexécute la fonction *min_rsl* pour chaque instance (temps de calculs assez faible comparé aux temps de calculs de HK). Attention, il ne prend que 2 minutes à exécuter sans le fichier pa561, mais prend 40 minutes avec (on a un nombre d'itérations maximal dans l'algorithme HK assez élevé pour la taille du graphe). On a ainsi ajouté une variable booléenne calcul\_pa561 qu'on peut fixer à false si on veut obtenir tous les autres résultats rapidement."

# ╔═╡ d868dfe4-d90d-4108-b359-d6f5a7b1bffb
md"On obtient des bons résultats sur la plupart des graphes. Sur les plus petits, on obtient des tournées très proches de la tournée optimale voire optimale dans quelques cas. On remarque néanmoins que sur les plus gros graphes comme pa561 et gr120, on obtient des résultats plus éloignés de la valeur optimale. Cela est en partie dû aux temps de calcul de nos algorithmes qui nous ont empêché d'utiliser la fonction *test_hk* sur tous les noeuds ou avec des taux d'apprentissage faibles ou des nombres d'itérations élevés "

# ╔═╡ c4d066fc-efc9-484b-bcfb-bd229df4baec


# ╔═╡ 28b49375-14cd-4db7-bc8b-7e28cd1d66f7
md"On représente ci-dessous les meilleures tournées obtenues sur les graphes sur lesquels cela est possible"

# ╔═╡ fa8ff99f-75db-4f22-9499-04e5621533ac
begin
	#bayg29 = create_graph(joinpath(path_instances, "bayg29.tsp"))
	tour_opti_bayg29, poids_bayg29 = heldkarp(bayg29, 16, 0.01, 10000, false)
	tour_opti_bayg29_rsl,_,_ = min_rsl(bayg29)
	plot_graph(nodes(tour_opti_bayg29), edges(tour_opti_bayg29))
end

# ╔═╡ 007dc7f5-ca8f-46a6-99f9-7c1c51131cd0
plot_graph(nodes(tour_opti_bayg29_rsl), edges(tour_opti_bayg29_rsl))


# ╔═╡ b81cf618-021e-459a-9ffe-6d88bf29fd36
begin
	#bays29 = create_graph(joinpath(path_instances, "bayg29.tsp"))
	tour_opti_bays29, poids_bays29 = heldkarp(bays29, 13, 0.01, 10000, false)
	tour_opti_bays29_rsl,_,_ = min_rsl(bays29)

	plot_graph(nodes(tour_opti_bayg29), edges(tour_opti_bayg29))
end

# ╔═╡ f1e6608f-17ee-44c4-b8fa-bebe469e11ad
plot_graph(nodes(tour_opti_bays29_rsl), edges(tour_opti_bays29_rsl))


# ╔═╡ 49e89ce2-42fe-4a60-b9b5-091bcd952611
begin
	dantzig42 = create_graph(joinpath(path_instances, "dantzig42.tsp"))
	tour_opti_dantzig42, poids_dantzig42 = heldkarp(dantzig42, 35, 0.1, 1000, false)
	tour_opti_dantzig42_rsl,_,_ = min_rsl(dantzig42)
	plot_graph(nodes(tour_opti_dantzig42), edges(tour_opti_dantzig42))
end

# ╔═╡ fe09ea71-1ec2-42b1-9b7c-1a93d8bf68de
plot_graph(nodes(tour_opti_dantzig42_rsl), edges(tour_opti_dantzig42_rsl))


# ╔═╡ 13a80dc6-9701-4e5f-95b7-ebf1fe53144d
begin
	gr120 = create_graph(joinpath(path_instances, "gr120.tsp"))
	tour_opti_gr120, poids_gr120 = heldkarp(gr120, 61, 1., 1000, false)
	tour_opti_gr120_rsl,_,_ = min_rsl(gr120)

	plot_graph(nodes(tour_opti_gr120), edges(tour_opti_gr120))
end

# ╔═╡ 3bfb840b-1671-4c43-b074-276964589c31
plot_graph(nodes(tour_opti_gr120_rsl), edges(tour_opti_gr120_rsl))


# ╔═╡ 00000000-0000-0000-0000-000000000001
PLUTO_PROJECT_TOML_CONTENTS = """
[deps]
InteractiveUtils = "b77e0a4c-d291-57a0-90e8-8db25a27a240"
Markdown = "d6f4376e-aef5-505a-96c1-9c027394607a"
Plots = "91a5bcdd-55d7-5caf-9e0b-520d859cae80"
PlutoUI = "7f904dfe-b85e-4ff6-b463-dae2292396a8"

[compat]
Plots = "~1.22.4"
PlutoUI = "~0.7.14"
"""

# ╔═╡ 00000000-0000-0000-0000-000000000002
PLUTO_MANIFEST_TOML_CONTENTS = """
# This file is machine-generated - editing it directly is not advised

[[Adapt]]
deps = ["LinearAlgebra"]
git-tree-sha1 = "84918055d15b3114ede17ac6a7182f68870c16f7"
uuid = "79e6a3ab-5dfb-504d-930d-738a2a938a0e"
version = "3.3.1"

[[ArgTools]]
uuid = "0dad84c5-d112-42e6-8d28-ef12dabb789f"

[[Artifacts]]
uuid = "56f22d72-fd6d-98f1-02f0-08ddc0907c33"

[[Base64]]
uuid = "2a0f44e3-6c83-55bd-87e4-b1978d98bd5f"

[[Bzip2_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "19a35467a82e236ff51bc17a3a44b69ef35185a2"
uuid = "6e34b625-4abd-537c-b88f-471c36dfa7a0"
version = "1.0.8+0"

[[Cairo_jll]]
deps = ["Artifacts", "Bzip2_jll", "Fontconfig_jll", "FreeType2_jll", "Glib_jll", "JLLWrappers", "LZO_jll", "Libdl", "Pixman_jll", "Pkg", "Xorg_libXext_jll", "Xorg_libXrender_jll", "Zlib_jll", "libpng_jll"]
git-tree-sha1 = "f2202b55d816427cd385a9a4f3ffb226bee80f99"
uuid = "83423d85-b0ee-5818-9007-b63ccbeb887a"
version = "1.16.1+0"

[[ColorSchemes]]
deps = ["ColorTypes", "Colors", "FixedPointNumbers", "Random"]
git-tree-sha1 = "a851fec56cb73cfdf43762999ec72eff5b86882a"
uuid = "35d6a980-a343-548e-a6ea-1d62b119f2f4"
version = "3.15.0"

[[ColorTypes]]
deps = ["FixedPointNumbers", "Random"]
git-tree-sha1 = "024fe24d83e4a5bf5fc80501a314ce0d1aa35597"
uuid = "3da002f7-5984-5a60-b8a6-cbb66c0b333f"
version = "0.11.0"

[[Colors]]
deps = ["ColorTypes", "FixedPointNumbers", "Reexport"]
git-tree-sha1 = "417b0ed7b8b838aa6ca0a87aadf1bb9eb111ce40"
uuid = "5ae59095-9a9b-59fe-a467-6f913c188581"
version = "0.12.8"

[[Compat]]
deps = ["Base64", "Dates", "DelimitedFiles", "Distributed", "InteractiveUtils", "LibGit2", "Libdl", "LinearAlgebra", "Markdown", "Mmap", "Pkg", "Printf", "REPL", "Random", "SHA", "Serialization", "SharedArrays", "Sockets", "SparseArrays", "Statistics", "Test", "UUIDs", "Unicode"]
git-tree-sha1 = "31d0151f5716b655421d9d75b7fa74cc4e744df2"
uuid = "34da2185-b29b-5c13-b0c7-acf172513d20"
version = "3.39.0"

[[CompilerSupportLibraries_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "e66e0078-7015-5450-92f7-15fbd957f2ae"

[[Contour]]
deps = ["StaticArrays"]
git-tree-sha1 = "9f02045d934dc030edad45944ea80dbd1f0ebea7"
uuid = "d38c429a-6771-53c6-b99e-75d170b6e991"
version = "0.5.7"

[[DataAPI]]
git-tree-sha1 = "cc70b17275652eb47bc9e5f81635981f13cea5c8"
uuid = "9a962f9c-6df0-11e9-0e5d-c546b8b5ee8a"
version = "1.9.0"

[[DataStructures]]
deps = ["Compat", "InteractiveUtils", "OrderedCollections"]
git-tree-sha1 = "7d9d316f04214f7efdbb6398d545446e246eff02"
uuid = "864edb3b-99cc-5e75-8d2d-829cb0a9cfe8"
version = "0.18.10"

[[DataValueInterfaces]]
git-tree-sha1 = "bfc1187b79289637fa0ef6d4436ebdfe6905cbd6"
uuid = "e2d170a0-9d28-54be-80f0-106bbe20a464"
version = "1.0.0"

[[Dates]]
deps = ["Printf"]
uuid = "ade2ca70-3891-5945-98fb-dc099432e06a"

[[DelimitedFiles]]
deps = ["Mmap"]
uuid = "8bb1440f-4735-579b-a4ab-409b98df4dab"

[[Distributed]]
deps = ["Random", "Serialization", "Sockets"]
uuid = "8ba89e20-285c-5b6f-9357-94700520ee1b"

[[Downloads]]
deps = ["ArgTools", "LibCURL", "NetworkOptions"]
uuid = "f43a241f-c20a-4ad4-852c-f6b1247861c6"

[[EarCut_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "3f3a2501fa7236e9b911e0f7a588c657e822bb6d"
uuid = "5ae413db-bbd1-5e63-b57d-d24a61df00f5"
version = "2.2.3+0"

[[Expat_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "b3bfd02e98aedfa5cf885665493c5598c350cd2f"
uuid = "2e619515-83b5-522b-bb60-26c02a35a201"
version = "2.2.10+0"

[[FFMPEG]]
deps = ["FFMPEG_jll"]
git-tree-sha1 = "b57e3acbe22f8484b4b5ff66a7499717fe1a9cc8"
uuid = "c87230d0-a227-11e9-1b43-d7ebe4e7570a"
version = "0.4.1"

[[FFMPEG_jll]]
deps = ["Artifacts", "Bzip2_jll", "FreeType2_jll", "FriBidi_jll", "JLLWrappers", "LAME_jll", "Libdl", "Ogg_jll", "OpenSSL_jll", "Opus_jll", "Pkg", "Zlib_jll", "libass_jll", "libfdk_aac_jll", "libvorbis_jll", "x264_jll", "x265_jll"]
git-tree-sha1 = "d8a578692e3077ac998b50c0217dfd67f21d1e5f"
uuid = "b22a6f82-2f65-5046-a5b2-351ab43fb4e5"
version = "4.4.0+0"

[[FixedPointNumbers]]
deps = ["Statistics"]
git-tree-sha1 = "335bfdceacc84c5cdf16aadc768aa5ddfc5383cc"
uuid = "53c48c17-4a7d-5ca2-90c5-79b7896eea93"
version = "0.8.4"

[[Fontconfig_jll]]
deps = ["Artifacts", "Bzip2_jll", "Expat_jll", "FreeType2_jll", "JLLWrappers", "Libdl", "Libuuid_jll", "Pkg", "Zlib_jll"]
git-tree-sha1 = "21efd19106a55620a188615da6d3d06cd7f6ee03"
uuid = "a3f928ae-7b40-5064-980b-68af3947d34b"
version = "2.13.93+0"

[[Formatting]]
deps = ["Printf"]
git-tree-sha1 = "8339d61043228fdd3eb658d86c926cb282ae72a8"
uuid = "59287772-0a20-5a39-b81b-1366585eb4c0"
version = "0.4.2"

[[FreeType2_jll]]
deps = ["Artifacts", "Bzip2_jll", "JLLWrappers", "Libdl", "Pkg", "Zlib_jll"]
git-tree-sha1 = "87eb71354d8ec1a96d4a7636bd57a7347dde3ef9"
uuid = "d7e528f0-a631-5988-bf34-fe36492bcfd7"
version = "2.10.4+0"

[[FriBidi_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "aa31987c2ba8704e23c6c8ba8a4f769d5d7e4f91"
uuid = "559328eb-81f9-559d-9380-de523a88c83c"
version = "1.0.10+0"

[[GLFW_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Libglvnd_jll", "Pkg", "Xorg_libXcursor_jll", "Xorg_libXi_jll", "Xorg_libXinerama_jll", "Xorg_libXrandr_jll"]
git-tree-sha1 = "0c603255764a1fa0b61752d2bec14cfbd18f7fe8"
uuid = "0656b61e-2033-5cc2-a64a-77c0f6c09b89"
version = "3.3.5+1"

[[GR]]
deps = ["Base64", "DelimitedFiles", "GR_jll", "HTTP", "JSON", "Libdl", "LinearAlgebra", "Pkg", "Printf", "Random", "Serialization", "Sockets", "Test", "UUIDs"]
git-tree-sha1 = "c2178cfbc0a5a552e16d097fae508f2024de61a3"
uuid = "28b8d3ca-fb5f-59d9-8090-bfdbd6d07a71"
version = "0.59.0"

[[GR_jll]]
deps = ["Artifacts", "Bzip2_jll", "Cairo_jll", "FFMPEG_jll", "Fontconfig_jll", "GLFW_jll", "JLLWrappers", "JpegTurbo_jll", "Libdl", "Libtiff_jll", "Pixman_jll", "Pkg", "Qt5Base_jll", "Zlib_jll", "libpng_jll"]
git-tree-sha1 = "4c8c0719591e108a83fb933ac39e32731c7850ff"
uuid = "d2c73de3-f751-5644-a686-071e5b155ba9"
version = "0.60.0+0"

[[GeometryBasics]]
deps = ["EarCut_jll", "IterTools", "LinearAlgebra", "StaticArrays", "StructArrays", "Tables"]
git-tree-sha1 = "58bcdf5ebc057b085e58d95c138725628dd7453c"
uuid = "5c1252a2-5f33-56bf-86c9-59e7332b4326"
version = "0.4.1"

[[Gettext_jll]]
deps = ["Artifacts", "CompilerSupportLibraries_jll", "JLLWrappers", "Libdl", "Libiconv_jll", "Pkg", "XML2_jll"]
git-tree-sha1 = "9b02998aba7bf074d14de89f9d37ca24a1a0b046"
uuid = "78b55507-aeef-58d4-861c-77aaff3498b1"
version = "0.21.0+0"

[[Glib_jll]]
deps = ["Artifacts", "Gettext_jll", "JLLWrappers", "Libdl", "Libffi_jll", "Libiconv_jll", "Libmount_jll", "PCRE_jll", "Pkg", "Zlib_jll"]
git-tree-sha1 = "7bf67e9a481712b3dbe9cb3dac852dc4b1162e02"
uuid = "7746bdde-850d-59dc-9ae8-88ece973131d"
version = "2.68.3+0"

[[Graphite2_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "344bf40dcab1073aca04aa0df4fb092f920e4011"
uuid = "3b182d85-2403-5c21-9c21-1e1f0cc25472"
version = "1.3.14+0"

[[Grisu]]
git-tree-sha1 = "53bb909d1151e57e2484c3d1b53e19552b887fb2"
uuid = "42e2da0e-8278-4e71-bc24-59509adca0fe"
version = "1.0.2"

[[HTTP]]
deps = ["Base64", "Dates", "IniFile", "Logging", "MbedTLS", "NetworkOptions", "Sockets", "URIs"]
git-tree-sha1 = "14eece7a3308b4d8be910e265c724a6ba51a9798"
uuid = "cd3eb016-35fb-5094-929b-558a96fad6f3"
version = "0.9.16"

[[HarfBuzz_jll]]
deps = ["Artifacts", "Cairo_jll", "Fontconfig_jll", "FreeType2_jll", "Glib_jll", "Graphite2_jll", "JLLWrappers", "Libdl", "Libffi_jll", "Pkg"]
git-tree-sha1 = "8a954fed8ac097d5be04921d595f741115c1b2ad"
uuid = "2e76f6c2-a576-52d4-95c1-20adfe4de566"
version = "2.8.1+0"

[[HypertextLiteral]]
git-tree-sha1 = "f6532909bf3d40b308a0f360b6a0e626c0e263a8"
uuid = "ac1192a8-f4b3-4bfe-ba22-af5b92cd3ab2"
version = "0.9.1"

[[IOCapture]]
deps = ["Logging", "Random"]
git-tree-sha1 = "f7be53659ab06ddc986428d3a9dcc95f6fa6705a"
uuid = "b5f81e59-6552-4d32-b1f0-c071b021bf89"
version = "0.2.2"

[[IniFile]]
deps = ["Test"]
git-tree-sha1 = "098e4d2c533924c921f9f9847274f2ad89e018b8"
uuid = "83e8ac13-25f8-5344-8a64-a9f2b223428f"
version = "0.5.0"

[[InteractiveUtils]]
deps = ["Markdown"]
uuid = "b77e0a4c-d291-57a0-90e8-8db25a27a240"

[[IterTools]]
git-tree-sha1 = "05110a2ab1fc5f932622ffea2a003221f4782c18"
uuid = "c8e1da08-722c-5040-9ed9-7db0dc04731e"
version = "1.3.0"

[[IteratorInterfaceExtensions]]
git-tree-sha1 = "a3f24677c21f5bbe9d2a714f95dcd58337fb2856"
uuid = "82899510-4779-5014-852e-03e436cf321d"
version = "1.0.0"

[[JLLWrappers]]
deps = ["Preferences"]
git-tree-sha1 = "642a199af8b68253517b80bd3bfd17eb4e84df6e"
uuid = "692b3bcd-3c85-4b1f-b108-f13ce0eb3210"
version = "1.3.0"

[[JSON]]
deps = ["Dates", "Mmap", "Parsers", "Unicode"]
git-tree-sha1 = "8076680b162ada2a031f707ac7b4953e30667a37"
uuid = "682c06a0-de6a-54ab-a142-c8b1cf79cde6"
version = "0.21.2"

[[JpegTurbo_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "d735490ac75c5cb9f1b00d8b5509c11984dc6943"
uuid = "aacddb02-875f-59d6-b918-886e6ef4fbf8"
version = "2.1.0+0"

[[LAME_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "f6250b16881adf048549549fba48b1161acdac8c"
uuid = "c1c5ebd0-6772-5130-a774-d5fcae4a789d"
version = "3.100.1+0"

[[LZO_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "e5b909bcf985c5e2605737d2ce278ed791b89be6"
uuid = "dd4b983a-f0e5-5f8d-a1b7-129d4a5fb1ac"
version = "2.10.1+0"

[[LaTeXStrings]]
git-tree-sha1 = "c7f1c695e06c01b95a67f0cd1d34994f3e7db104"
uuid = "b964fa9f-0449-5b57-a5c2-d3ea65f4040f"
version = "1.2.1"

[[Latexify]]
deps = ["Formatting", "InteractiveUtils", "LaTeXStrings", "MacroTools", "Markdown", "Printf", "Requires"]
git-tree-sha1 = "a4b12a1bd2ebade87891ab7e36fdbce582301a92"
uuid = "23fbe1c1-3f47-55db-b15f-69d7ec21a316"
version = "0.15.6"

[[LibCURL]]
deps = ["LibCURL_jll", "MozillaCACerts_jll"]
uuid = "b27032c2-a3e7-50c8-80cd-2d36dbcbfd21"

[[LibCURL_jll]]
deps = ["Artifacts", "LibSSH2_jll", "Libdl", "MbedTLS_jll", "Zlib_jll", "nghttp2_jll"]
uuid = "deac9b47-8bc7-5906-a0fe-35ac56dc84c0"

[[LibGit2]]
deps = ["Base64", "NetworkOptions", "Printf", "SHA"]
uuid = "76f85450-5226-5b5a-8eaa-529ad045b433"

[[LibSSH2_jll]]
deps = ["Artifacts", "Libdl", "MbedTLS_jll"]
uuid = "29816b5a-b9ab-546f-933c-edad1886dfa8"

[[Libdl]]
uuid = "8f399da3-3557-5675-b5ff-fb832c97cbdb"

[[Libffi_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "0b4a5d71f3e5200a7dff793393e09dfc2d874290"
uuid = "e9f186c6-92d2-5b65-8a66-fee21dc1b490"
version = "3.2.2+1"

[[Libgcrypt_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Libgpg_error_jll", "Pkg"]
git-tree-sha1 = "64613c82a59c120435c067c2b809fc61cf5166ae"
uuid = "d4300ac3-e22c-5743-9152-c294e39db1e4"
version = "1.8.7+0"

[[Libglvnd_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libX11_jll", "Xorg_libXext_jll"]
git-tree-sha1 = "7739f837d6447403596a75d19ed01fd08d6f56bf"
uuid = "7e76a0d4-f3c7-5321-8279-8d96eeed0f29"
version = "1.3.0+3"

[[Libgpg_error_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "c333716e46366857753e273ce6a69ee0945a6db9"
uuid = "7add5ba3-2f88-524e-9cd5-f83b8a55f7b8"
version = "1.42.0+0"

[[Libiconv_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "42b62845d70a619f063a7da093d995ec8e15e778"
uuid = "94ce4f54-9a6c-5748-9c1c-f9c7231a4531"
version = "1.16.1+1"

[[Libmount_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "9c30530bf0effd46e15e0fdcf2b8636e78cbbd73"
uuid = "4b2f31a3-9ecc-558c-b454-b3730dcb73e9"
version = "2.35.0+0"

[[Libtiff_jll]]
deps = ["Artifacts", "JLLWrappers", "JpegTurbo_jll", "Libdl", "Pkg", "Zlib_jll", "Zstd_jll"]
git-tree-sha1 = "340e257aada13f95f98ee352d316c3bed37c8ab9"
uuid = "89763e89-9b03-5906-acba-b20f662cd828"
version = "4.3.0+0"

[[Libuuid_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "7f3efec06033682db852f8b3bc3c1d2b0a0ab066"
uuid = "38a345b3-de98-5d2b-a5d3-14cd9215e700"
version = "2.36.0+0"

[[LinearAlgebra]]
deps = ["Libdl"]
uuid = "37e2e46d-f89d-539d-b4ee-838fcccc9c8e"

[[Logging]]
uuid = "56ddb016-857b-54e1-b83d-db4d58db5568"

[[MacroTools]]
deps = ["Markdown", "Random"]
git-tree-sha1 = "5a5bc6bf062f0f95e62d0fe0a2d99699fed82dd9"
uuid = "1914dd2f-81c6-5fcd-8719-6d5c9610ff09"
version = "0.5.8"

[[Markdown]]
deps = ["Base64"]
uuid = "d6f4376e-aef5-505a-96c1-9c027394607a"

[[MbedTLS]]
deps = ["Dates", "MbedTLS_jll", "Random", "Sockets"]
git-tree-sha1 = "1c38e51c3d08ef2278062ebceade0e46cefc96fe"
uuid = "739be429-bea8-5141-9913-cc70e7f3736d"
version = "1.0.3"

[[MbedTLS_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "c8ffd9c3-330d-5841-b78e-0817d7145fa1"

[[Measures]]
git-tree-sha1 = "e498ddeee6f9fdb4551ce855a46f54dbd900245f"
uuid = "442fdcdd-2543-5da2-b0f3-8c86c306513e"
version = "0.3.1"

[[Missings]]
deps = ["DataAPI"]
git-tree-sha1 = "bf210ce90b6c9eed32d25dbcae1ebc565df2687f"
uuid = "e1d29d7a-bbdc-5cf2-9ac0-f12de2c33e28"
version = "1.0.2"

[[Mmap]]
uuid = "a63ad114-7e13-5084-954f-fe012c677804"

[[MozillaCACerts_jll]]
uuid = "14a3606d-f60d-562e-9121-12d972cd8159"

[[NaNMath]]
git-tree-sha1 = "bfe47e760d60b82b66b61d2d44128b62e3a369fb"
uuid = "77ba4419-2d1f-58cd-9bb1-8ffee604a2e3"
version = "0.3.5"

[[NetworkOptions]]
uuid = "ca575930-c2e3-43a9-ace4-1e988b2c1908"

[[Ogg_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "7937eda4681660b4d6aeeecc2f7e1c81c8ee4e2f"
uuid = "e7412a2a-1a6e-54c0-be00-318e2571c051"
version = "1.3.5+0"

[[OpenSSL_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "15003dcb7d8db3c6c857fda14891a539a8f2705a"
uuid = "458c3c95-2e84-50aa-8efc-19380b2a3a95"
version = "1.1.10+0"

[[Opus_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "51a08fb14ec28da2ec7a927c4337e4332c2a4720"
uuid = "91d4177d-7536-5919-b921-800302f37372"
version = "1.3.2+0"

[[OrderedCollections]]
git-tree-sha1 = "85f8e6578bf1f9ee0d11e7bb1b1456435479d47c"
uuid = "bac558e1-5e72-5ebc-8fee-abe8a469f55d"
version = "1.4.1"

[[PCRE_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "b2a7af664e098055a7529ad1a900ded962bca488"
uuid = "2f80f16e-611a-54ab-bc61-aa92de5b98fc"
version = "8.44.0+0"

[[Parsers]]
deps = ["Dates"]
git-tree-sha1 = "a8709b968a1ea6abc2dc1967cb1db6ac9a00dfb6"
uuid = "69de0a69-1ddd-5017-9359-2bf0b02dc9f0"
version = "2.0.5"

[[Pixman_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "b4f5d02549a10e20780a24fce72bea96b6329e29"
uuid = "30392449-352a-5448-841d-b1acce4e97dc"
version = "0.40.1+0"

[[Pkg]]
deps = ["Artifacts", "Dates", "Downloads", "LibGit2", "Libdl", "Logging", "Markdown", "Printf", "REPL", "Random", "SHA", "Serialization", "TOML", "Tar", "UUIDs", "p7zip_jll"]
uuid = "44cfe95a-1eb2-52ea-b672-e2afdf69b78f"

[[PlotThemes]]
deps = ["PlotUtils", "Requires", "Statistics"]
git-tree-sha1 = "a3a964ce9dc7898193536002a6dd892b1b5a6f1d"
uuid = "ccf2f8ad-2431-5c83-bf29-c5338b663b6a"
version = "2.0.1"

[[PlotUtils]]
deps = ["ColorSchemes", "Colors", "Dates", "Printf", "Random", "Reexport", "Statistics"]
git-tree-sha1 = "b084324b4af5a438cd63619fd006614b3b20b87b"
uuid = "995b91a9-d308-5afd-9ec6-746e21dbc043"
version = "1.0.15"

[[Plots]]
deps = ["Base64", "Contour", "Dates", "Downloads", "FFMPEG", "FixedPointNumbers", "GR", "GeometryBasics", "JSON", "Latexify", "LinearAlgebra", "Measures", "NaNMath", "PlotThemes", "PlotUtils", "Printf", "REPL", "Random", "RecipesBase", "RecipesPipeline", "Reexport", "Requires", "Scratch", "Showoff", "SparseArrays", "Statistics", "StatsBase", "UUIDs"]
git-tree-sha1 = "6841db754bd01a91d281370d9a0f8787e220ae08"
uuid = "91a5bcdd-55d7-5caf-9e0b-520d859cae80"
version = "1.22.4"

[[PlutoUI]]
deps = ["Base64", "Dates", "HypertextLiteral", "IOCapture", "InteractiveUtils", "JSON", "Logging", "Markdown", "Random", "Reexport", "UUIDs"]
git-tree-sha1 = "d1fb76655a95bf6ea4348d7197b22e889a4375f4"
uuid = "7f904dfe-b85e-4ff6-b463-dae2292396a8"
version = "0.7.14"

[[Preferences]]
deps = ["TOML"]
git-tree-sha1 = "00cfd92944ca9c760982747e9a1d0d5d86ab1e5a"
uuid = "21216c6a-2e73-6563-6e65-726566657250"
version = "1.2.2"

[[Printf]]
deps = ["Unicode"]
uuid = "de0858da-6303-5e67-8744-51eddeeeb8d7"

[[Qt5Base_jll]]
deps = ["Artifacts", "CompilerSupportLibraries_jll", "Fontconfig_jll", "Glib_jll", "JLLWrappers", "Libdl", "Libglvnd_jll", "OpenSSL_jll", "Pkg", "Xorg_libXext_jll", "Xorg_libxcb_jll", "Xorg_xcb_util_image_jll", "Xorg_xcb_util_keysyms_jll", "Xorg_xcb_util_renderutil_jll", "Xorg_xcb_util_wm_jll", "Zlib_jll", "xkbcommon_jll"]
git-tree-sha1 = "ad368663a5e20dbb8d6dc2fddeefe4dae0781ae8"
uuid = "ea2cea3b-5b76-57ae-a6ef-0a8af62496e1"
version = "5.15.3+0"

[[REPL]]
deps = ["InteractiveUtils", "Markdown", "Sockets", "Unicode"]
uuid = "3fa0cd96-eef1-5676-8a61-b3b8758bbffb"

[[Random]]
deps = ["Serialization"]
uuid = "9a3f8284-a2c9-5f02-9a11-845980a1fd5c"

[[RecipesBase]]
git-tree-sha1 = "44a75aa7a527910ee3d1751d1f0e4148698add9e"
uuid = "3cdcf5f2-1ef4-517c-9805-6587b60abb01"
version = "1.1.2"

[[RecipesPipeline]]
deps = ["Dates", "NaNMath", "PlotUtils", "RecipesBase"]
git-tree-sha1 = "7ad0dfa8d03b7bcf8c597f59f5292801730c55b8"
uuid = "01d81517-befc-4cb6-b9ec-a95719d0359c"
version = "0.4.1"

[[Reexport]]
git-tree-sha1 = "45e428421666073eab6f2da5c9d310d99bb12f9b"
uuid = "189a3867-3050-52da-a836-e630ba90ab69"
version = "1.2.2"

[[Requires]]
deps = ["UUIDs"]
git-tree-sha1 = "4036a3bd08ac7e968e27c203d45f5fff15020621"
uuid = "ae029012-a4dd-5104-9daa-d747884805df"
version = "1.1.3"

[[SHA]]
uuid = "ea8e919c-243c-51af-8825-aaa63cd721ce"

[[Scratch]]
deps = ["Dates"]
git-tree-sha1 = "0b4b7f1393cff97c33891da2a0bf69c6ed241fda"
uuid = "6c6a2e73-6563-6170-7368-637461726353"
version = "1.1.0"

[[Serialization]]
uuid = "9e88b42a-f829-5b0c-bbe9-9e923198166b"

[[SharedArrays]]
deps = ["Distributed", "Mmap", "Random", "Serialization"]
uuid = "1a1011a3-84de-559e-8e89-a11a2f7dc383"

[[Showoff]]
deps = ["Dates", "Grisu"]
git-tree-sha1 = "91eddf657aca81df9ae6ceb20b959ae5653ad1de"
uuid = "992d4aef-0814-514b-bc4d-f2e9a6c4116f"
version = "1.0.3"

[[Sockets]]
uuid = "6462fe0b-24de-5631-8697-dd941f90decc"

[[SortingAlgorithms]]
deps = ["DataStructures"]
git-tree-sha1 = "b3363d7460f7d098ca0912c69b082f75625d7508"
uuid = "a2af1166-a08f-5f64-846c-94a0d3cef48c"
version = "1.0.1"

[[SparseArrays]]
deps = ["LinearAlgebra", "Random"]
uuid = "2f01184e-e22b-5df5-ae63-d93ebab69eaf"

[[StaticArrays]]
deps = ["LinearAlgebra", "Random", "Statistics"]
git-tree-sha1 = "3c76dde64d03699e074ac02eb2e8ba8254d428da"
uuid = "90137ffa-7385-5640-81b9-e52037218182"
version = "1.2.13"

[[Statistics]]
deps = ["LinearAlgebra", "SparseArrays"]
uuid = "10745b16-79ce-11e8-11f9-7d13ad32a3b2"

[[StatsAPI]]
git-tree-sha1 = "1958272568dc176a1d881acb797beb909c785510"
uuid = "82ae8749-77ed-4fe6-ae5f-f523153014b0"
version = "1.0.0"

[[StatsBase]]
deps = ["DataAPI", "DataStructures", "LinearAlgebra", "Missings", "Printf", "Random", "SortingAlgorithms", "SparseArrays", "Statistics", "StatsAPI"]
git-tree-sha1 = "8cbbc098554648c84f79a463c9ff0fd277144b6c"
uuid = "2913bbd2-ae8a-5f71-8c99-4fb6c76f3a91"
version = "0.33.10"

[[StructArrays]]
deps = ["Adapt", "DataAPI", "StaticArrays", "Tables"]
git-tree-sha1 = "2ce41e0d042c60ecd131e9fb7154a3bfadbf50d3"
uuid = "09ab397b-f2b6-538f-b94a-2f83cf4a842a"
version = "0.6.3"

[[TOML]]
deps = ["Dates"]
uuid = "fa267f1f-6049-4f14-aa54-33bafae1ed76"

[[TableTraits]]
deps = ["IteratorInterfaceExtensions"]
git-tree-sha1 = "c06b2f539df1c6efa794486abfb6ed2022561a39"
uuid = "3783bdb8-4a98-5b6b-af9a-565f29a5fe9c"
version = "1.0.1"

[[Tables]]
deps = ["DataAPI", "DataValueInterfaces", "IteratorInterfaceExtensions", "LinearAlgebra", "TableTraits", "Test"]
git-tree-sha1 = "fed34d0e71b91734bf0a7e10eb1bb05296ddbcd0"
uuid = "bd369af6-aec1-5ad0-b16a-f7cc5008161c"
version = "1.6.0"

[[Tar]]
deps = ["ArgTools", "SHA"]
uuid = "a4e569a6-e804-4fa4-b0f3-eef7a1d5b13e"

[[Test]]
deps = ["InteractiveUtils", "Logging", "Random", "Serialization"]
uuid = "8dfed614-e22c-5e08-85e1-65c5234f0b40"

[[URIs]]
git-tree-sha1 = "97bbe755a53fe859669cd907f2d96aee8d2c1355"
uuid = "5c2747f8-b7ea-4ff2-ba2e-563bfd36b1d4"
version = "1.3.0"

[[UUIDs]]
deps = ["Random", "SHA"]
uuid = "cf7118a7-6976-5b1a-9a39-7adc72f591a4"

[[Unicode]]
uuid = "4ec0a83e-493e-50e2-b9ac-8f72acf5a8f5"

[[Wayland_jll]]
deps = ["Artifacts", "Expat_jll", "JLLWrappers", "Libdl", "Libffi_jll", "Pkg", "XML2_jll"]
git-tree-sha1 = "3e61f0b86f90dacb0bc0e73a0c5a83f6a8636e23"
uuid = "a2964d1f-97da-50d4-b82a-358c7fce9d89"
version = "1.19.0+0"

[[Wayland_protocols_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Wayland_jll"]
git-tree-sha1 = "2839f1c1296940218e35df0bbb220f2a79686670"
uuid = "2381bf8a-dfd0-557d-9999-79630e7b1b91"
version = "1.18.0+4"

[[XML2_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Libiconv_jll", "Pkg", "Zlib_jll"]
git-tree-sha1 = "1acf5bdf07aa0907e0a37d3718bb88d4b687b74a"
uuid = "02c8fc9c-b97f-50b9-bbe4-9be30ff0a78a"
version = "2.9.12+0"

[[XSLT_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Libgcrypt_jll", "Libgpg_error_jll", "Libiconv_jll", "Pkg", "XML2_jll", "Zlib_jll"]
git-tree-sha1 = "91844873c4085240b95e795f692c4cec4d805f8a"
uuid = "aed1982a-8fda-507f-9586-7b0439959a61"
version = "1.1.34+0"

[[Xorg_libX11_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libxcb_jll", "Xorg_xtrans_jll"]
git-tree-sha1 = "5be649d550f3f4b95308bf0183b82e2582876527"
uuid = "4f6342f7-b3d2-589e-9d20-edeb45f2b2bc"
version = "1.6.9+4"

[[Xorg_libXau_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "4e490d5c960c314f33885790ed410ff3a94ce67e"
uuid = "0c0b7dd1-d40b-584c-a123-a41640f87eec"
version = "1.0.9+4"

[[Xorg_libXcursor_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libXfixes_jll", "Xorg_libXrender_jll"]
git-tree-sha1 = "12e0eb3bc634fa2080c1c37fccf56f7c22989afd"
uuid = "935fb764-8cf2-53bf-bb30-45bb1f8bf724"
version = "1.2.0+4"

[[Xorg_libXdmcp_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "4fe47bd2247248125c428978740e18a681372dd4"
uuid = "a3789734-cfe1-5b06-b2d0-1dd0d9d62d05"
version = "1.1.3+4"

[[Xorg_libXext_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libX11_jll"]
git-tree-sha1 = "b7c0aa8c376b31e4852b360222848637f481f8c3"
uuid = "1082639a-0dae-5f34-9b06-72781eeb8cb3"
version = "1.3.4+4"

[[Xorg_libXfixes_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libX11_jll"]
git-tree-sha1 = "0e0dc7431e7a0587559f9294aeec269471c991a4"
uuid = "d091e8ba-531a-589c-9de9-94069b037ed8"
version = "5.0.3+4"

[[Xorg_libXi_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libXext_jll", "Xorg_libXfixes_jll"]
git-tree-sha1 = "89b52bc2160aadc84d707093930ef0bffa641246"
uuid = "a51aa0fd-4e3c-5386-b890-e753decda492"
version = "1.7.10+4"

[[Xorg_libXinerama_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libXext_jll"]
git-tree-sha1 = "26be8b1c342929259317d8b9f7b53bf2bb73b123"
uuid = "d1454406-59df-5ea1-beac-c340f2130bc3"
version = "1.1.4+4"

[[Xorg_libXrandr_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libXext_jll", "Xorg_libXrender_jll"]
git-tree-sha1 = "34cea83cb726fb58f325887bf0612c6b3fb17631"
uuid = "ec84b674-ba8e-5d96-8ba1-2a689ba10484"
version = "1.5.2+4"

[[Xorg_libXrender_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libX11_jll"]
git-tree-sha1 = "19560f30fd49f4d4efbe7002a1037f8c43d43b96"
uuid = "ea2f1a96-1ddc-540d-b46f-429655e07cfa"
version = "0.9.10+4"

[[Xorg_libpthread_stubs_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "6783737e45d3c59a4a4c4091f5f88cdcf0908cbb"
uuid = "14d82f49-176c-5ed1-bb49-ad3f5cbd8c74"
version = "0.1.0+3"

[[Xorg_libxcb_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "XSLT_jll", "Xorg_libXau_jll", "Xorg_libXdmcp_jll", "Xorg_libpthread_stubs_jll"]
git-tree-sha1 = "daf17f441228e7a3833846cd048892861cff16d6"
uuid = "c7cfdc94-dc32-55de-ac96-5a1b8d977c5b"
version = "1.13.0+3"

[[Xorg_libxkbfile_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libX11_jll"]
git-tree-sha1 = "926af861744212db0eb001d9e40b5d16292080b2"
uuid = "cc61e674-0454-545c-8b26-ed2c68acab7a"
version = "1.1.0+4"

[[Xorg_xcb_util_image_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_xcb_util_jll"]
git-tree-sha1 = "0fab0a40349ba1cba2c1da699243396ff8e94b97"
uuid = "12413925-8142-5f55-bb0e-6d7ca50bb09b"
version = "0.4.0+1"

[[Xorg_xcb_util_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libxcb_jll"]
git-tree-sha1 = "e7fd7b2881fa2eaa72717420894d3938177862d1"
uuid = "2def613f-5ad1-5310-b15b-b15d46f528f5"
version = "0.4.0+1"

[[Xorg_xcb_util_keysyms_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_xcb_util_jll"]
git-tree-sha1 = "d1151e2c45a544f32441a567d1690e701ec89b00"
uuid = "975044d2-76e6-5fbe-bf08-97ce7c6574c7"
version = "0.4.0+1"

[[Xorg_xcb_util_renderutil_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_xcb_util_jll"]
git-tree-sha1 = "dfd7a8f38d4613b6a575253b3174dd991ca6183e"
uuid = "0d47668e-0667-5a69-a72c-f761630bfb7e"
version = "0.3.9+1"

[[Xorg_xcb_util_wm_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_xcb_util_jll"]
git-tree-sha1 = "e78d10aab01a4a154142c5006ed44fd9e8e31b67"
uuid = "c22f9ab0-d5fe-5066-847c-f4bb1cd4e361"
version = "0.4.1+1"

[[Xorg_xkbcomp_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libxkbfile_jll"]
git-tree-sha1 = "4bcbf660f6c2e714f87e960a171b119d06ee163b"
uuid = "35661453-b289-5fab-8a00-3d9160c6a3a4"
version = "1.4.2+4"

[[Xorg_xkeyboard_config_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_xkbcomp_jll"]
git-tree-sha1 = "5c8424f8a67c3f2209646d4425f3d415fee5931d"
uuid = "33bec58e-1273-512f-9401-5d533626f822"
version = "2.27.0+4"

[[Xorg_xtrans_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "79c31e7844f6ecf779705fbc12146eb190b7d845"
uuid = "c5fb5394-a638-5e4d-96e5-b29de1b5cf10"
version = "1.4.0+3"

[[Zlib_jll]]
deps = ["Libdl"]
uuid = "83775a58-1f1d-513f-b197-d71354ab007a"

[[Zstd_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "cc4bf3fdde8b7e3e9fa0351bdeedba1cf3b7f6e6"
uuid = "3161d3a3-bdf6-5164-811a-617609db77b4"
version = "1.5.0+0"

[[libass_jll]]
deps = ["Artifacts", "Bzip2_jll", "FreeType2_jll", "FriBidi_jll", "HarfBuzz_jll", "JLLWrappers", "Libdl", "Pkg", "Zlib_jll"]
git-tree-sha1 = "5982a94fcba20f02f42ace44b9894ee2b140fe47"
uuid = "0ac62f75-1d6f-5e53-bd7c-93b484bb37c0"
version = "0.15.1+0"

[[libfdk_aac_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "daacc84a041563f965be61859a36e17c4e4fcd55"
uuid = "f638f0a6-7fb0-5443-88ba-1cc74229b280"
version = "2.0.2+0"

[[libpng_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Zlib_jll"]
git-tree-sha1 = "94d180a6d2b5e55e447e2d27a29ed04fe79eb30c"
uuid = "b53b4c65-9356-5827-b1ea-8c7a1a84506f"
version = "1.6.38+0"

[[libvorbis_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Ogg_jll", "Pkg"]
git-tree-sha1 = "c45f4e40e7aafe9d086379e5578947ec8b95a8fb"
uuid = "f27f6e37-5d2b-51aa-960f-b287f2bc3b7a"
version = "1.3.7+0"

[[nghttp2_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "8e850ede-7688-5339-a07c-302acd2aaf8d"

[[p7zip_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "3f19e933-33d8-53b3-aaab-bd5110c3b7a0"

[[x264_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "4fea590b89e6ec504593146bf8b988b2c00922b2"
uuid = "1270edf5-f2f9-52d2-97e9-ab00b5d0237a"
version = "2021.5.5+0"

[[x265_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "ee567a171cce03570d77ad3a43e90218e38937a9"
uuid = "dfaa095f-4041-5dcd-9319-2fabd8486b76"
version = "3.5.0+0"

[[xkbcommon_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Wayland_jll", "Wayland_protocols_jll", "Xorg_libxcb_jll", "Xorg_xkeyboard_config_jll"]
git-tree-sha1 = "ece2350174195bb31de1a63bea3a41ae1aa593b6"
uuid = "d8fb68d0-12a3-5cfd-a85a-d49703b185fd"
version = "0.9.1+5"
"""

# ╔═╡ Cell order:
# ╟─3c04ef1e-26cf-11ec-269d-714e657e0a90
# ╟─edb29e94-a3b5-42cf-bb38-a4bbe9753dd1
# ╟─52c6ffc6-3ced-4465-95c8-c3ff979a5ff3
# ╟─ac10181c-501b-44b0-a0f9-5257d37329aa
# ╟─02181ed8-1f58-4bde-ba30-0d33f6cce8d7
# ╟─bd96c780-678d-459b-aa23-a166751da087
# ╟─0c186ad3-5494-4fa5-9791-5c6a1fbc4fab
# ╟─abc12fa3-0cdd-4c3f-8dc6-6fe41cde8ec9
# ╟─ad90a1be-e044-4d63-920f-5b6c9068b519
# ╟─8914a271-58db-45d0-a227-804ac9cdac5b
# ╟─4c380476-c375-4da3-a58e-acdb303d3a76
# ╟─f345a0a0-2342-4488-ac0a-7b3c4f5fe381
# ╟─b64118ca-0d04-4c8c-b375-e267e162c7f6
# ╟─ee2fe83f-3e55-4bf8-b2a5-706c53c9b5c5
# ╟─69d54b10-0cc5-48b8-b3b3-6c53945c2e65
# ╟─085fe42d-c57f-4bc6-8a63-72f48fc88e2a
# ╟─a9b98776-5e37-4925-8bd4-c667bd20d8a7
# ╟─068be080-b311-4a5d-af1d-e9cec2a2eda6
# ╟─37195aed-5d39-44f7-a75f-92122ab7c7d3
# ╟─6a46e8ce-5e73-4ab2-b47c-3003ee93da84
# ╟─2fb5056b-4ea9-4aeb-b122-08dc7ea695ce
# ╟─5fd34b54-e8f8-4939-bcd6-e7368a7af5a3
# ╠═473d557d-3e50-451a-9eab-7ab44240dfb8
# ╟─aa812e7a-15e4-492b-912d-b6139a1de7e4
# ╟─ec50db94-f394-4c10-927b-1e1fa34ad728
# ╠═ba9461a0-31ff-4974-82e6-ca02807c9c5d
# ╠═6ff5dddf-9d43-485d-9fb0-c7d9183747d8
# ╟─a8e36544-c43f-469b-80b6-e4a8fe801ff8
# ╠═a520301b-2bc3-452f-aef9-1be9e10046f7
# ╠═e3bf6e4a-4da9-4897-9c86-3863a1373031
# ╟─018f5c9d-7d88-4081-9721-87944c5e90d0
# ╟─7c089bc5-9252-469a-80cd-c669285b3c31
# ╟─8943125d-233d-439f-8641-5028ce556fb1
# ╟─60534fee-514d-4fcc-8555-2bd82dc1d130
# ╠═c2a867c4-0d89-4117-a976-d32beac11e5a
# ╠═26168326-e262-4d78-8db5-11da9f57c576
# ╟─a83a9354-ef22-43bf-b741-99026fdff382
# ╟─8ecc5eb1-b4ab-4e46-8d8c-07ad03dc916b
# ╟─23557883-0c02-455d-aa38-a30619644f87
# ╟─8f95be08-938d-48d3-a9ee-4ed3806ff8bc
# ╟─68108499-4e9d-4f3a-b1e8-854cb6f58807
# ╟─d868dfe4-d90d-4108-b359-d6f5a7b1bffb
# ╟─c4d066fc-efc9-484b-bcfb-bd229df4baec
# ╟─28b49375-14cd-4db7-bc8b-7e28cd1d66f7
# ╠═fa8ff99f-75db-4f22-9499-04e5621533ac
# ╠═007dc7f5-ca8f-46a6-99f9-7c1c51131cd0
# ╠═b81cf618-021e-459a-9ffe-6d88bf29fd36
# ╠═f1e6608f-17ee-44c4-b8fa-bebe469e11ad
# ╠═49e89ce2-42fe-4a60-b9b5-091bcd952611
# ╠═fe09ea71-1ec2-42b1-9b7c-1a93d8bf68de
# ╠═13a80dc6-9701-4e5f-95b7-ebf1fe53144d
# ╠═3bfb840b-1671-4c43-b074-276964589c31
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
