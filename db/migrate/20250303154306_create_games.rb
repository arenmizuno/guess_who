class CreateGames < ActiveRecord::Migration[7.1]
  def change
    create_table :games do |t|
      t.integer :player_id  # Single player controlling both roles
      t.string  :status, default: "pending"  # Status of the game (pending, in progress, finished)
      t.string  :current_turn, default: "player1"  # Track whose turn it is ("player1" or "player2")
      t.integer :elected_1  # Character ID chosen by Player 1
      t.integer :elected_2  # Character ID chosen by Player 2

      t.timestamps
    end
  end
end
