class RemoveFieldsFromMenus < ActiveRecord::Migration
  def change
    remove_column :menus, :slug
    remove_column :menus, :position
  end
end
