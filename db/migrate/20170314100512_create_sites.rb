class CreateSites < ActiveRecord::Migration
  def change
    create_table :sites do |t|
      t.string :name
      t.boolean :default
      t.string :default_currency
      t.text :countries, array: true

      t.string :meta_title
      t.text :meta_description
      t.text :meta_keywords

      t.timestamps null: false
    end
  end
end
