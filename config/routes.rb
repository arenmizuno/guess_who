Rails.application.routes.draw do
  devise_for :users
  root to: "pages#home"

  get("/characters", { controller: "characters", action: "index" })
  get("/characters/:path_id", { controller: "characters", action: "show" })
  post("/insert_character_record", { controller: "characters", action: "create" })
  get("/delete_character/:the_id", { controller: "characters", action: "destroy" })
  post("/modify_character_record/:the_id", { controller: "characters", action: "update" }) 

  # Mount rails_db only in development
  #if Rails.env.development?
   # mount RailsDb::Engine, at: "/rails_db", as: 'rails_db'
 # end
end
