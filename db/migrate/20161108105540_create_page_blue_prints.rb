class CreatePageBluePrints < ActiveRecord::Migration
  def change
    create_table :page_blueprints do |t|
      t.string :name
      t.timestamps
    end
  end
end
