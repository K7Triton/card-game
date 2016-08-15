class CreateRoomMessages < ActiveRecord::Migration[5.0]
  def change
    create_table :room_messages do |t|
      t.string  :content
      t.integer :user_id
      t.timestamps
    end
  end
end
