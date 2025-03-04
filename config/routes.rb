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
  # Step 1: Start a New Game
  get("/start_game", { controller: "games", action: "new", as: :start_game })   
  post("/create_game", { controller: "games", action: "create", as: :create_game }) 

  # Step 2: Select Champions
  get("/games/:game_id/select_champion", { controller: "games", action: "select_champion", as: :select_champion })
  post("/games/:game_id/chose_champion", { controller: "games", action: "chose_champion", as: :chose_champion })

  # Step 3: Play the Game
  get("/games/:game_id/play", { controller: "games", action: "play", as: :play_game }) # Main Game Page
  get("/games/:id", { controller: "games", action: "show", as: :game }) # Redirects to play

  # Step 4: In-Game Actions
  post("/games/:game_id/ask_question", { controller: "games", action: "ask_question", as: :ask_question })
  post("/games/:game_id/answer_question", { controller: "games", action: "answer_question", as: :answer_question })
  post("/games/:game_id/eliminate_character", { controller: "games", action: "eliminate_character", as: :eliminate_character })
  post("/games/:game_id/guess_answer", { controller: "games", action: "guess_answer", as: :guess_answer })
  post("/games/:game_id/switch_turn", { controller: "games", action: "switch_turn", as: :switch_turn })



  
  

  # Mount rails_db only in development
  #if Rails.env.development?
   # mount RailsDb::Engine, at: "/rails_db", as: 'rails_db'
  #end
end
