class CreateSiteCountries < ActiveRecord::Migration
  def change
    create_table :site_countries do |t|
      t.integer :site_id, index: true
      t.string :code
    end
  end
end
