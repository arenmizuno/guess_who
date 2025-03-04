class CreateGames < ActiveRecord::Migration[7.1]
  def change
    create_table :games do |t|
      t.integer :player1
      t.integer :player2
      t.bigint  :winner
      t.string  :status

      t.timestamps
    end
  end
end
