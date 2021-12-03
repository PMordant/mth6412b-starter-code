include("tour_to_images.jl")
using Test


dict_args_hk = Dict("abstract-light-painting" => Any[1,0.1,10],
                    "alaska-railroad" => Any[1,100.,20],
                    "blue-hour-paris" => Any[1,100.,20],
                    "lower-kananaskis-lake" => Any[1,1.,100],
                    "marlet2-radio-board" => Any[1,100.,20],
                    "nikos-cat" => Any[1,1.,10],
                    "pizza-food-wallpaper" => Any[1,1.,10],
                    "the-enchanted-garden" => Any[1,1.,10],
                    "tokyo-skytree-aerial" => Any[1,1.,10]
)


path_tsp = joinpath("shredder-julia", "tsp", "instances")
path_image = joinpath("shredder-julia", "images", "original")
path_reconstruit = joinpath("shredder-julia", "images", "reconstructed")


for file in readdir(path_tsp)
    if file != ".gitignore"
        graph = @time(create_graph(joinpath(path_tsp,file)))
        filename = String(split(file, ".")[1])
        tour = @time(heldkarp(graph, dict_args_hk[filename]...))
        save_tour(tour[1], filename)


        println(filename * " :")
        
        println("Le poids de la tournée minimale est de "*string(tour[2]))
        println("Le score de l'image reconstruite est de "*string(score_picture(joinpath(path_reconstruit, filename)*".png")))
        println("Le score de l'image originale est de "*string(score_picture(joinpath(path_image, filename)*".png")))

        println("")
        println("")

    end
end
