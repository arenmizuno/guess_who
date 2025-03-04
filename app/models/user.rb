# == Schema Information
#
# Table name: users
#
#  id                     :bigint           not null, primary key
#  email                  :string           default(""), not null
#  encrypted_password     :string           default(""), not null
#  remember_created_at    :datetime
#  reset_password_sent_at :datetime
#  reset_password_token   :string
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#
# Indexes
#
#  index_users_on_email                 (email) UNIQUE
#  index_users_on_reset_password_token  (reset_password_token) UNIQUE
#
class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many  :characters, class_name: "Character", foreign_key: "created_by", dependent: :destroy
  has_many  :games_as_player1, class_name: "Game", foreign_key: "player1", dependent: :destroy
  has_many  :games_as_player2, class_name: "Game", foreign_key: "player2", dependent: :destroy
  has_many  :questions, class_name: "Question", foreign_key: "asked_by_id", dependent: :destroy
  has_many  :games_won, class_name: "Game", foreign_key: "winner", dependent: :destroy
end
