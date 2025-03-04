class CharactersController < ApplicationController
  def index
    matching_characters = Character.all
    @list_of_characters = Character.order(name: :desc)
    render({ template: "character_templates/index" })
  end

  def show
    the_id = params.fetch("path_id")

    matching_characters = Character.where({ :id => the_id })
    @the_character = matching_characters.at(0)

    render({ :template => "character_templates/show" })
  end

  def create
    c = Character.new
    c.name = params.fetch("name")
    c.user = current_user
    if params[:photo].present?
      c.photo.attach(params[:photo])
    else
      puts "No photo found"
    end
  
    if c.save
      puts "Character saved successfully."
      redirect_to("/characters")
    else
      puts "Error saving character: #{c.errors.full_messages}"
      render({ template: "character_templates/index" })
    end
  end

  def destroy
    the_id = params.fetch("the_id")
    matching_record = Character.where({ :id => the_id})
    the_character = matching_record.at(0)
    if the_character.user == current_user
      the_character.destroy
      redirect_to("/characters")
    else
      redirect_to("/characters", alert: "You can only delete characters you created.")
    end
  end

  def update
    the_id = params.fetch("the_id")
    the_character = Character.find_by(id: the_id)
  
    if the_character.user == current_user
      # Update the name
      the_character.update(name: params.fetch("name"))
  
      # Check if a new photo is uploaded
      if params[:photo].present?
        # Purge the old photo if it's being replaced
        the_character.photo.purge # Removes the existing photo from storage
        the_character.photo.attach(params[:photo]) 
      end
  
      # Save the character with the new photo if provided
      if the_character.save
        redirect_to("/characters/#{the_character.id}")
      else
        render({ template: "character_templates/edit" })
      end
    else
      redirect_to("/characters", alert: "You can only edit characters you created.")
    end
  end
end
