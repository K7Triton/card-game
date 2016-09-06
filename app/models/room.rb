class Room < ApplicationRecord
  serialize :player_1_cards, Array
  serialize :player_2_cards, Array
  serialize :player_3_cards, Array
  serialize :player_4_cards, Array
  serialize :bank, Array
  serialize :otboi, Array


  belongs_to :user

  belongs_to :player_1, class_name: "User",
                foreign_key: "player_1_id",  optional: true
  belongs_to :player_2, class_name: "User",
                foreign_key: "player_2_id",  optional: true
  belongs_to :player_3, class_name: "User",
                foreign_key: "player_3_id",  optional: true
  belongs_to :player_4, class_name: "User",
                foreign_key: "player_4_id",  optional: true


  has_many :cards
  has_many :room_messages, dependent: :destroy
  has_many :room_users, dependent: :destroy

end
