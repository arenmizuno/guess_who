Rails.application.routes.draw do

  devise_for :users
  root to: "boards#index"
  get("/", { :controller => "boards", :action => "index" })

  # This is a blank app! Pick your first screen, build out the RCAV, and go from there. E.g.:

  # get "/your_first_screen" => "pages#first"
  
end
