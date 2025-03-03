class CreateGameCharacterSelections < ActiveRecord::Migration[7.1]
  def change
    create_table :game_character_selections do |t|
      t.integer :character_id
      t.integer :game_id
      t.boolean :guessed_1
      t.boolean :guessed_2
      t.boolean :elected_1
      t.boolean :elected_2
      t.boolean :excluded_1
      t.boolean :excluded_2

      t.timestamps
    end
  end
end
