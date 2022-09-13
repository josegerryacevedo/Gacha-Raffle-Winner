class CreateNewsTickers < ActiveRecord::Migration[6.1]
  def change
    create_table :news_tickers do |t|
      t.belongs_to :admin
      t.string :content
      t.integer :status
      t.timestamps
    end
  end
end