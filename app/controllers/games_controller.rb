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
      redirect_to new_game_path, alert: "You cannot select yourself as Player 2."
      return
    end

    # Ensure exactly 15 characters are selected
    selected_character_ids = params[:selected_characters]
    if selected_character_ids.nil? || selected_character_ids.length != 15
      redirect_to new_game_path, alert: "You must select exactly 15 characters."
      return
    end

    # Create the game with Player 1 and Player 2
    @game = Game.new(player1: current_user, player2: @player2, status: "pending")

    if @game.save
      # Create the GameCharacterSelection records for each selected character
      selected_character_ids.each do |character_id|
        GameCharacterSelection.create!(game_id: @game.id, character_id: character_id)
      end
      redirect_to select_champion_game_path(@game)
    else
      render({ template: "game_templates/new" })
    end
  end

  # Step 3: Show the Select Champion page for both players
  def select_champion
    @game = Game.find(params[:id])

    # Check if the current user is player1 or player2
    if current_user == @game.player1
      @characters = @game.game_character_selections.where(character: { user_id: @game.player1.id })
    elsif current_user == @game.player2
      @characters = @game.game_character_selections.where(character: { user_id: @game.player2.id })
    else
      redirect_to game_path(@game), alert: "You are not part of this game."
    end
  end
end
