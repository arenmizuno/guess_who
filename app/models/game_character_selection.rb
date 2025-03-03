class GameCharacterSelection < ApplicationRecord
  belongs_to :game, required: true, class_name: "Character", foreign_key: "character_id"
  belongs_to :game, required: true, class_name: "Game", foreign_key: "game_id"
end
