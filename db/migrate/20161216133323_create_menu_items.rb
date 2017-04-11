class CreateMenuItems < ActiveRecord::Migration
  def change
    create_table :menu_items do |t|
      t.string :title
      t.string :url
      t.integer :position
      t.belongs_to :menu
      t.belongs_to :menu_item
      t.timestamps null: false
    end
  end
end
