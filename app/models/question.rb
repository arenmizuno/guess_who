class Question < ApplicationRecord
  belongs_to :user, required: true, class_name: "User", foreign_key: "asked_by"
  belongs_to :game, required: true, class_name: "Game", foreign_key: "game_id"
end
