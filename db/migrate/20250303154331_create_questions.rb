class CreateQuestions < ActiveRecord::Migration[7.1]
  def change
    create_table :questions do |t|
      t.integer :game_id
      t.integer :asked_by
      t.string :response
      t.string :question_text

      t.timestamps
    end
  end
end
