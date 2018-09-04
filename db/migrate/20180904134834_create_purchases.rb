class CreatePurchases < ActiveRecord::Migration[5.1]
  def change
    create_table :purchases do |t|
      t.date     :open_date
      t.string   :name
      t.datetime :deadline
      t.boolean  :is_enable, defaule: true
      t.integer  :total_price
      t.integer  :menu_id
      t.integer  :user_id

      t.timestamps
    end
  end
end
