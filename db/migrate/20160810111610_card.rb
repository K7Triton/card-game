class Card < ActiveRecord::Migration[5.0]
  def change
    create_table :cards do |t|
      t.integer :value
      t.string :card_type
      t.string :image
    end
  end
end
