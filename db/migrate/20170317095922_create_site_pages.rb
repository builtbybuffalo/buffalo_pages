class CreateSitePages < ActiveRecord::Migration
  def change
    create_table :site_pages do |t|
      t.belongs_to :site
      t.belongs_to :page
      t.timestamps null: false
    end
  end
end
