class CharactersController < ApplicationController
  def index
    matching_characters = Character.all
    @list_of_characters = matching_characters.order({ :name => :desc })

    render({ :template => "character_templates/index" })
  end

  def show
    the_id = params.fetch("path_id")

    matching_characters = Character.where({ :id => the_id })
    @the_character = matching_characters.at(0)

    render({ :template => "character_templates/show" })
  end

  def create
    c = Character.new
    c.name= params.fetch("name")
    c.image = params.fetch("image")
    c.save
    redirect_to("/characters")
  end

  def destroy
    the_id = params.fetch("an_id")
    matching_record = Character.where({ :id => the_id})
    the_character = matching_record.at(0)
    the_character.destroy
    redirect_to("/characters")
  end

  def update
    c_id = params.fetch("the_id")
    matching_record = Character.where({ :id => d_id})
    the_character = matching_record.at(0)

    the_character.name = params.fetch("name")
    the_character.image = params.fetch("image")
    the_character.save
    redirect_to("/characters/#{the_character.id}")
  end
end
