class CreateOrderItems < ActiveRecord::Migration[5.1]
  def change
    create_table :order_items do |t|
      t.string  :name,     null: false
      t.integer :price,    null: false
      t.integer :qty,      null: false, default: 1
      t.string  :note
      t.integer :order_id

      t.timestamps
    end
  end
end
