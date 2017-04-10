class AddFieldsTable < ActiveRecord::Migration
  def change
    create_table :fields do |t|
      t.string :type
      t.text :config
      t.text :value
      t.belongs_to :page
      t.belongs_to :field_blueprint
      t.timestamps
    end
  end
end
