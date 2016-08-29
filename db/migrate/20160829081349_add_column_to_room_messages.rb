class AddColumnToRoomMessages < ActiveRecord::Migration[5.0]
  def change
    add_column :room_messages, :room_id, :integer
  end
end
