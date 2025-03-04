class CreateQuestions < ActiveRecord::Migration[7.1]
  def change
    create_table :questions do |t|
      t.integer :game_id
      t.string :asked_by  # "player1" or "player2" to track who asked
      t.string :response  # Yes / No / Maybe
      t.string :question_text  # The actual question asked

      t.timestamps
    end
  end
end
