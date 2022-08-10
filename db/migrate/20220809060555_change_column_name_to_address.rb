class ChangeColumnNameToAddress < ActiveRecord::Migration[6.1]
  def change
    rename_column :addresses, :enum, :genre
  end
end
