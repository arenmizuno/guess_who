class GamesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_game, only: [:play, :select_champion, :chose_champion, :ask_question, :answer_question, :eliminate_character, :guess_answer]

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
      redirect_to select_champion_path(game_id: @game.id)
    else
      flash[:alert] = "There was an error creating the game."
      render template: "game_templates/new"
    end
  end

  # Step 3: Select champions for both players
  def select_champion
    @characters = Character.where(id: @game.game_character_selections.pluck(:character_id))

    if @game.elected_1.nil?
      @player_turn = "Player 1"
    elsif @game.elected_2.nil?
      @player_turn = "Player 2"
    else
      flash[:notice] = "Both champions selected! The game begins."
      redirect_to play_game_path(@game) and return
    end

    render template: "game_templates/select_champion"
  end

  def chose_champion
    selected_character_id = params[:champion_id].to_i
    game_character_selection = @game.game_character_selections.find_by(character_id: selected_character_id)

    unless game_character_selection
      flash[:alert] = "Invalid character selection."
      redirect_to select_champion_path(game_id: @game.id) and return
    end

    if @game.elected_1.nil?
      @game.update!(elected_1: selected_character_id)
      flash[:notice] = "Player 1's champion selected. Now it's Player 2's turn."
      redirect_to select_champion_path(game_id: @game.id)

    elsif @game.elected_2.nil?
      @game.update!(elected_2: selected_character_id)
      flash[:notice] = "Both champions selected! The game begins."
      redirect_to play_game_path(@game)
    else
      flash[:alert] = "Champions have already been selected."
      redirect_to play_game_path(@game)
    end
  end

  # Step 4: Play Game (Main Screen)
  def play
    @characters = Character.where(id: @game.game_character_selections.pluck(:character_id))
    @questions = @game.questions.order(created_at: :asc)
  
    # Initialize turn phase when game starts
    session[:turn_phase] ||= "ask"
  
    render template: "game_templates/play"
  end
  

  # Step 5: Ask a Question (Stores without a response)
  def ask_question
    if session[:turn_phase] != "ask"
      flash[:alert] = "You cannot ask a question right now."
      redirect_to play_game_path(@game) and return
    end
  
    question_text = params[:question]
  
    if question_text.blank?
      flash[:alert] = "You must enter a question."
      redirect_to play_game_path(@game) and return
    end
  
    Question.create!(
      game_id: @game.id,
      question_text: question_text,
      response: nil,
      asked_by: @game.current_turn
    )
  
    # Switch turn for the opponent to answer
    session[:turn_phase] = "answer"
    @game.update!(current_turn: @game.current_turn == "player1" ? "player2" : "player1")
  
    flash[:notice] = "Question asked! The opponent must answer."
    redirect_to play_game_path(@game)
  end
  
  # Step 6: Answer a Question
  def answer_question
    if session[:turn_phase] != "answer"
      flash[:alert] = "You cannot answer a question right now."
      redirect_to play_game_path(@game) and return
    end
  
    question = Question.find(params[:question_id])
  
    if question.response.present?
      flash[:alert] = "This question has already been answered."
      redirect_to play_game_path(@game) and return
    end
  
    question.update!(response: params[:response])
  
    # Enable elimination phase and ensure the original player can eliminate characters
    session[:turn_phase] = "eliminate"
    session[:elimination_phase] = true
    session[:asking_player] = question.asked_by
    @game.update!(current_turn: question.asked_by)
  
    flash[:notice] = "Response recorded! Now the original player can eliminate characters."
    redirect_to play_game_path(@game)
  end
  
  

  # Step 7: Eliminate a Character
  def eliminate_character
    if session[:turn_phase] != "eliminate"
      flash[:alert] = "You cannot eliminate characters right now."
      redirect_to play_game_path(@game) and return
    end
  
    character_id = params[:character_id].to_i
    game_character_selection = @game.game_character_selections.find_by(character_id: character_id)
  
    unless game_character_selection
      flash[:alert] = "Invalid character selection."
      redirect_to play_game_path(@game) and return
    end
  
    if session[:asking_player] == "player1"
      game_character_selection.update!(excluded_1: true)
    else
      game_character_selection.update!(excluded_2: true)
    end
  
    # Make sure switch turn button appears
    session[:elimination_phase] = true
  
    flash[:notice] = "Character eliminated! When you're done, switch turns."
    redirect_to play_game_path(@game)
  end
  
  def switch_turn
    @game = Game.find_by(id: params[:game_id])

    if session[:turn_phase] != "eliminate"
      flash[:alert] = "You can only switch turns after eliminating characters."
      redirect_to play_game_path(@game) and return
    end
  
    # Reset session and switch turn to next player's question phase
    session.delete(:elimination_phase)
    session.delete(:asking_player)
    session[:turn_phase] = "ask"
  
    @game.update!(current_turn: @game.current_turn == "player1" ? "player2" : "player1")
  
    flash[:notice] = "Turn switched! Now it's the other player's turn to ask a question."
    redirect_to play_game_path(@game)
  end
  
  # Step 8: Guess the Opponent’s Champion
  def guess_answer
    guessed_character_id = params[:guessed_character_id].to_i

    if guessed_character_id == @game.elected_1 || guessed_character_id == @game.elected_2
      flash[:notice] = "Correct! Game over."
      @game.update!(status: "finished", winner: guessed_character_id)
    else
      flash[:alert] = "Wrong guess! Keep playing."
    end

    redirect_to play_game_path(@game)
  end

  private

  private

  def set_game
    @game = Game.find_by(id: params[:game_id])
  
    unless @game
      flash[:alert] = "Game not found."
      redirect_to start_game_path and return
    end
  end
end
