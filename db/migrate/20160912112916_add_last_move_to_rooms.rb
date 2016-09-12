class AddLastMoveToRooms < ActiveRecord::Migration[5.0]
  def change
    add_column :rooms, :last_move, :integer
  end
end
