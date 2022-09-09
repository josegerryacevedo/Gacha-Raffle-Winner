class AdjustColumnToUsers < ActiveRecord::Migration[6.1]
  def change
    change_column :users, :coins, :integer, default: 0
  end
end
