# == Schema Information
#
# Table name: games
#
#  id         :bigint           not null, primary key
#  player1    :integer
#  player2    :integer
#  status     :string
#  winner     :bigint
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class Game < ApplicationRecord
  belongs_to :player1, required: true, class_name: "User", foreign_key: "player1"
  belongs_to :player2, required: true, class_name: "User", foreign_key: "player2"
  belongs_to :winner, optional: true, class_name: "User", foreign_key: "winner"
  has_many  :game_character_selections, class_name: "GameCharacterSelection", foreign_key: "game_id", dependent: :destroy
  has_many  :questions, class_name: "Question", foreign_key: "game_id", dependent: :destroy
end
