# == Schema Information
#
# Table name: game_character_selections
#
#  id           :bigint           not null, primary key
#  elected_1    :boolean
#  elected_2    :boolean
#  excluded_1   :boolean
#  excluded_2   :boolean
#  guessed_1    :boolean
#  guessed_2    :boolean
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  character_id :integer
#  game_id      :integer
#
class GameCharacterSelection < ApplicationRecord
  belongs_to :character, required: true, class_name: "Character", foreign_key: "character_id"
  belongs_to :game, required: true, class_name: "Game", foreign_key: "game_id"
end
