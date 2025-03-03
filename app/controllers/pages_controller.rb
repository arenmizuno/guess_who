class PagesController < ApplicationController
  def home
    render({ :template => "pages/index" })
  end
end
