class CreateMenus < ActiveRecord::Migration[5.1]
  def change
    create_table :menus do |t|
      t.string  :name, null: false
      t.string  :file_location, default: ""
      t.string  :description
      t.string  :phonenumber, null: false
      t.integer :category_id, null: false

      t.timestamps
    end
  end
end
