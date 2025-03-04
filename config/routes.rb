Rails.application.routes.draw do
  devise_for :users
  root to: "pages#home"

  # Character Routes
  get("/characters", { controller: "characters", action: "index" })
  get("/characters/:path_id", { controller: "characters", action: "show" })
  post("/insert_character_record", { controller: "characters", action: "create" })
  get("/delete_character/:the_id", { controller: "characters", action: "destroy" })
  post("/modify_character_record/:the_id", { controller: "characters", action: "update" }) 

  # Game Routes
  get("/start_game", { controller: "games", action: "new" })   
  post("/create_game", { controller: "games", action: "create" }) 
  get("/games/:game_id/select_champion", { controller: "games", action: "select_champion", as: :select_champion })
  post("/games/:game_id/chose_champion", { controller: "games", action: "chose_champion", as: :chose_champion })
  get("/games/:id", { controller: "games", action: "show", as: :game })

  
  

  # Mount rails_db only in development
  #if Rails.env.development?
    #mount RailsDb::Engine, at: "/rails_db", as: 'rails_db'
  #end
end
