class RemoveCountriesFromSites < ActiveRecord::Migration
  def change
    remove_column :sites, :countries
  end
end
