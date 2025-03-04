# == Schema Information
#
# Table name: questions
#
#  id            :bigint           not null, primary key
#  asked_by      :string
#  question_text :string
#  response      :string
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  game_id       :integer
#
class Question < ApplicationRecord
  belongs_to :game, required: true, class_name: "Game", foreign_key: "game_id"
end
