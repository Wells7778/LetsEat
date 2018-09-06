class CreatePayments < ActiveRecord::Migration[5.1]
  def change
    create_table :payments do |t|
      t.integer :price
      t.integer :diff
      t.integer :order_id
      t.integer :user_id

      t.timestamps
    end
  end
end
