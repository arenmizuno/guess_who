class GamesController < ApplicationController
  before_action :authenticate_user!

  # Step 1: Show the game setup page (for Player 2 to log in)
  def new
    @characters = Character.all
    @player1 = current_user
    render({ template: "game_templates/new" })
  end

  # Step 2: Create the game after Player 2 logs in
  def create
    @player2 = User.find(params[:player2_id])

    # Ensure Player 2 is not the same as Player 1
    if @player2 == current_user
      render({ template: "game_templates/new", alert: "You cannot select yourself as Player 2." })
      return
    end

    # Ensure exactly 15 characters are selected
    selected_character_ids = params[:selected_characters]
    if selected_character_ids.nil? || selected_character_ids.length != 15
      render({ template: "game_templates/new", alert: "You must select exactly 15 characters." })
      return
    end

    # Create the game with Player 1 and Player 2
    @game = Game.new(player1: current_user, player2: @player2, status: "pending")

    if @game.save
      # Create the GameCharacterSelection records for each selected character
      selected_character_ids.each do |character_id|
        GameCharacterSelection.create!(game_id: @game.id, character_id: character_id)
      end
      render({ template: "/games/select_champion" })
    
    else
      render({ template: "game_templates/new" })
    end
  end

  # Step 3: Show the Select Champion page for both players
  def select_champion
    @game = Game.find(params[:id])

    # Ensure only the players of this game can select their champions
    if current_user != @game.player1 && current_user != @game.player2
      render({ template: "game_templates/new", alert: "You are not part of this game."})
      return
    end

    # Get the game characters that were selected for this game
    @characters = @game.game_character_selections.includes(:character).map(&:character)

    # Render the page where the player can choose their champion
    render({ template: "game_templates/select_champion" })
  end

  def chose_champion
    @game = Game.find(params[:id])

    # Ensure only the players of this game can select their champions
    if current_user == @game.player1
      # Find the selected character for Player 1
      selected_character_id = params[:player1_champion]
      # Set elected_1 to true for the selected character
      game_character_selection = GameCharacterSelection.find_by(game_id: @game.id, character_id: selected_character_id)
      game_character_selection.update(elected_1: true)

    elsif current_user == @game.player2
      # Find the selected character for Player 2
      selected_character_id = params[:player2_champion]
      # Set elected_2 to true for the selected character
      game_character_selection = GameCharacterSelection.find_by(game_id: @game.id, character_id: selected_character_id)
      game_character_selection.update(elected_2: true)

    else
      render({ template: "game_templates/select_champion", alert: "You are not authorized to select a champion for this game." })
      return
    end

    # After storing the champion, render the game details page or next step
    render({ template: "game_templates/sn_champion" })  # Can be changed to another template based on your needs
  end
end
