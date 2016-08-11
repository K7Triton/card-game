class AddColumnsToRooms < ActiveRecord::Migration[5.0]
  def change
    add_column :rooms, :player_1_id,    :integer
    add_column :rooms, :player_2_id,    :integer
    add_column :rooms, :player_3_id,    :integer
    add_column :rooms, :player_4_id,    :integer
    add_column :rooms, :player_1_cards, :integer
    add_column :rooms, :player_2_cards, :integer
    add_column :rooms, :player_3_cards, :integer
    add_column :rooms, :player_4_cards, :integer
    add_column :rooms, :bank,           :integer
    add_column :rooms, :otboi,          :integer
  end
end
