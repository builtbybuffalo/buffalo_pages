class AddAssetTable < ActiveRecord::Migration
  def change
    create_table :assets do |t|
      t.string :name
      t.string :caption, null: true
      t.integer :position, default: 0
      t.references :attachable, polymorphic: true, index: true
      t.attachment :asset

      t.timestamps
    end
  end
end
