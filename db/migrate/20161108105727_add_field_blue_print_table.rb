class AddFieldBluePrintTable < ActiveRecord::Migration
  def change
    create_table :field_blueprints do |t|
      t.string :name
      t.string :field_type
      t.text :config
      t.belongs_to :page_blueprint
      t.timestamps
    end
  end
end
