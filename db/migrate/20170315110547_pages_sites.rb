class PagesSites < ActiveRecord::Migration
  def change
    create_table :pages_sites, id: false do |t|
      t.integer :page_id, index: true
      t.integer :site_id, index: true
    end
  end
end
