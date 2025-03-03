class CreateCharacters < ActiveRecord::Migration[7.1]
  def change
    create_table :characters do |t|
      t.integer :created_by
      t.string :photo
      t.string :name

      t.timestamps
    end
  end
end
