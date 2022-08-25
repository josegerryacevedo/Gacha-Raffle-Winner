class CreateBets < ActiveRecord::Migration[6.1]
  def change
    create_table :bets do |t|
      t.belongs_to :item
      t.belongs_to :user
      t.string :serial_number
      t.integer :coins
      t.string :state
      t.integer :batch_count
      t.timestamps
    end
  end
end
