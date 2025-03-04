# == Schema Information
#
# Table name: game_character_selections
#
#  id           :bigint           not null, primary key
#  excluded_1   :boolean          default(FALSE)
#  excluded_2   :boolean          default(FALSE)
#  guessed_1    :boolean          default(FALSE)
#  guessed_2    :boolean          default(FALSE)
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  character_id :integer
#  game_id      :integer
#
class GameCharacterSelection < ApplicationRecord
  belongs_to :character, required: true, class_name: "Character", foreign_key: "character_id"
  belongs_to :game, required: true, class_name: "Game", foreign_key: "game_id"
end
