class GamesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_game, only: [:select_champion, :chose_champion, :ask_question, :guess_answer]

  # Step 1: Show the game setup page
  def new
    @characters = Character.all
    render template: "game_templates/new"
  end

  # Step 2: Create the game
  def create
    selected_character_ids = params[:selected_characters] || []
    if selected_character_ids.length != 15
      flash[:alert] = "You must select exactly 15 characters."
      redirect_to start_game_path and return
    end

    @game = Game.new(player_id: current_user.id, status: "pending", current_turn: "player1")

    if @game.save
      selected_character_ids.each do |character_id|
        GameCharacterSelection.create!(game_id: @game.id, character_id: character_id)
      end
      redirect_to("/games/select_champion/#{@game.id}")
    else
      flash[:alert] = "There was an error creating the game."
      render template: "game_templates/new"
    end
  end

  def select_champion
    @characters = Character.where(id: @game.game_character_selections.pluck(:character_id))
  
    if @game.elected_1.nil?
      @player_turn = "Player 1"
    elsif @game.elected_2.nil?
      @player_turn = "Player 2"
    else
      flash[:notice] = "Both champions selected! The game begins."
      redirect_to game_path(@game) and return
    end
  
    render template: "game_templates/select_champion"
  end

  def chose_champion
    selected_character_id = params[:champion_id].to_i
  
    # Ensure the selected character is part of the game
    game_character_selection = @game.game_character_selections.find_by(character_id: selected_character_id)
  
    unless game_character_selection
      flash[:alert] = "Invalid character selection."
      redirect_to select_champion_path(game_id: @game.id) and return
    end
  
    if @game.elected_1.nil?
      # First selection is for Player 1
      @game.update!(elected_1: selected_character_id)
      flash[:notice] = "Player 1's champion selected. Now it's Player 2's turn."
      redirect_to select_champion_path(game_id: @game.id)
  
    elsif @game.elected_2.nil?
      # Player 2 can pick any champion, even if it's the same as Player 1's
      @game.update!(elected_2: selected_character_id)
      flash[:notice] = "Both champions selected! The game begins."
      redirect_to game_path(@game)
  
    else
      flash[:alert] = "Champions have already been selected."
      redirect_to game_path(@game)
    end
  end
  
  
end
