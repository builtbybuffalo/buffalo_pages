class AddMetaToMenuItems < ActiveRecord::Migration[5.0]
  def change
    change_table :menu_items do |t|
      t.text :meta
    end
  end
end
