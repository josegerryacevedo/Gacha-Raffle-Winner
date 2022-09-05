class CreateOrders < ActiveRecord::Migration[6.1]
  def change
    create_table :orders do |t|
      t.belongs_to :user
      t.belongs_to :offer
      t.string :serial_number
      t.string :state
      t.integer :coin
      t.decimal :amount
      t.string :remarks
      t.integer :genre
      t.timestamps
    end
  end
end
