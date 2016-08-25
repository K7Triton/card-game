class Room < ApplicationRecord

  belongs_to :user
  #has_many :cards
  has_many   :cards
  has_many   :room_messages
  has_many   :users
end
