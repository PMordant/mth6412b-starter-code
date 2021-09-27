### A Pluto.jl notebook ###
# v0.15.1

using Markdown
using InteractiveUtils

# ╔═╡ 5a00dbe0-3dd4-4f24-aebe-174de68724ce
begin
    import Pkg
	Pkg.add("Plots")
	
end

# ╔═╡ 5e196205-7c7b-4abb-9294-8d1cde587df9
begin
using Markdown
using InteractiveUtils
end

# ╔═╡ a40d8394-4283-49c4-8dae-a220e0612ee3
md"# Ecole polytechnique de Montréal"

# ╔═╡ 325540e9-bdd8-498b-a003-05de98f8b4de
		md"### MTH6412B		Session Automne  2021 "

# ╔═╡ fc911268-1ca1-11ec-3cea-316e634ec1f1
md"## Rapport de projet"

# ╔═╡ aae45e52-3b2c-4dbf-b800-5ad74e32e107
md" ### Pierre Mordant & Mahamadou Sarité"

# ╔═╡ f111cda5-de3d-4616-9a8a-cb4e4169ae89
md"### Phase 1"

# ╔═╡ 92c9398d-4310-4aa6-8236-adb8e005b3da
begin
md" Dans cette première phse du projet sur le problème du voyageur de commerce symétrique, nous définissons des structures de données de base adéquates.
Nous procédons à des modifications des codes de démarrages et à proposer:
  1. Un type Edge pour présenter les arêtes d'un graphe.
  2. Etendre le type Graph afin qu'un graphe contienne ses arêtes.
  3. Etendre la méthode d'affichage show d'un objet de type Graphe afin que les arêtes du graphe soient également affichées
  4. Etendre la fonction read _ edges() de read _ stsp.jl afin de lire les poids des arêtes.
  5. Fournir un programme principal main() qui lit une instance de TSP symétrique dont les poids sont donnés au format EXPLICIT et construit un objet de type Graph correspondant."
end

# ╔═╡ 42cce623-9fe6-4988-b92a-0f7c993eb2b0
begin 
md" Le type Edge est défini avec 3 attributs comme suit: les deux sommets (string, string) reliés par l'arête et le poids de cette arête (Int).
	
Le type graph a été modifié pour permettre l'inclusion des arêtes."
end
"""Ajout des figures de plot("graph::string") """
# ╔═╡ f412df0e-910c-43af-8ee3-37b4c124b1db


# ╔═╡ Cell order:
# ╟─5a00dbe0-3dd4-4f24-aebe-174de68724ce
# ╟─5e196205-7c7b-4abb-9294-8d1cde587df9
# ╟─a40d8394-4283-49c4-8dae-a220e0612ee3
# ╟─325540e9-bdd8-498b-a003-05de98f8b4de
# ╟─fc911268-1ca1-11ec-3cea-316e634ec1f1
# ╟─aae45e52-3b2c-4dbf-b800-5ad74e32e107
# ╟─f111cda5-de3d-4616-9a8a-cb4e4169ae89
# ╟─92c9398d-4310-4aa6-8236-adb8e005b3da
# ╠═42cce623-9fe6-4988-b92a-0f7c993eb2b0
# ╠═f412df0e-910c-43af-8ee3-37b4c124b1db
