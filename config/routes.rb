Rails.application.routes.draw do

  devise_for :users
  root to: "pages#home" 

  get("/characters", { :controller => "characters", :action => "index" })
  get("/characters/:path_id", { :controller => "characters", :action => "show" })
  post("/insert_character_record", { :controller => "characters", :action => "create" })
  get("/delete_characters/:an_id", { :controller => "characters", :action => "destroy" })
  post("/modify_character_record:the_id", { :controller => "characters", :action => "update" })

  
end
