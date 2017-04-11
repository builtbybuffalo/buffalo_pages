class AddPositionToFields < ActiveRecord::Migration
  def change
    add_column :field_blueprints, :position, :integer, default: 0
    add_column :fields, :position, :integer, default: 0
  end
end
