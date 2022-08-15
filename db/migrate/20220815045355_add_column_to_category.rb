class AddColumnToCategory < ActiveRecord::Migration[6.1]
  def change
    add_column :categories, :deleted_at, :datetime
  end
end