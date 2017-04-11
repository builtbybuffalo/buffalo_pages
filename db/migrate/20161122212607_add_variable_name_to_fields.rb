class AddVariableNameToFields < ActiveRecord::Migration
  def change
    add_column :fields, :variable_name, :string
  end
end
