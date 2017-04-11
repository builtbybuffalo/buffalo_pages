class RenameFieldNameToVariableName < ActiveRecord::Migration
  def change
    rename_column :field_blueprints, :name, :variable_name
  end
end
