class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many  :characters, class_name: "Character", foreign_key: "created_by", dependent: :destroy
  has_many  :games_as_player1, class_name: "Game", foreign_key: "player1_id", dependent: :destroy
  has_many  :games_as_player2, class_name: "Game", foreign_key: "player2_id", dependent: :destroy
  has_many  :questions, class_name: "Question", foreign_key: "asked_by_id", dependent: :destroy
  has_many  :games_won, class_name: "Game", foreign_key: "winner", dependent: :destroy
end
