class CreateGameCharacterSelections < ActiveRecord::Migration[7.1]
  def change
    create_table :game_character_selections do |t|
      t.integer :character_id
      t.integer :game_id
      t.boolean :guessed_1, default: false  # Whether Player 1 guessed this character
      t.boolean :guessed_2, default: false  # Whether Player 2 guessed this character
      t.boolean :excluded_1, default: false  # Whether Player 1 ruled out this character
      t.boolean :excluded_2, default: false

      t.timestamps
    end
  end
end
