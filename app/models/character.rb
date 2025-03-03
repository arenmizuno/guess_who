class Character < ApplicationRecord
  belongs_to :user, required: true, class_name: "User", foreign_key: "created_by"
  has_many  :selections, class_name: "GameCharacterSelection", foreign_key: "character_id", dependent: :destroy
end
