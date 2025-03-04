class RemovePhotoFromCharacters < ActiveRecord::Migration[7.1]
  def change
    remove_column :characters, :photo, :string
  end
end
