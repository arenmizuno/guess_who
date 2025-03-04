# == Schema Information
#
# Table name: games
#
#  id           :bigint           not null, primary key
#  current_turn :string           default("player1")
#  elected_1    :integer
#  elected_2    :integer
#  status       :string           default("pending")
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  player_id    :integer
#
class Game < ApplicationRecord
  belongs_to :player, required: true, class_name: "User", foreign_key: "player_id"
  has_many  :game_character_selections, class_name: "GameCharacterSelection", foreign_key: "game_id", dependent: :destroy
  has_many  :questions, class_name: "Question", foreign_key: "game_id", dependent: :destroy
end
