class CreateMenus < ActiveRecord::Migration
  def change
    create_table :menus do |t|
      t.string :title
      t.string :slug
      t.integer :position
      t.timestamps null: false
    end
  end
end
