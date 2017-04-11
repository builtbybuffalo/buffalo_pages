class AddMenusToSites < ActiveRecord::Migration
  def change
    add_column :sites, :main_menu_id, :integer
    add_column :sites, :footer_menu_id, :integer
    add_column :sites, :legal_menu_id, :integer
  end
end
