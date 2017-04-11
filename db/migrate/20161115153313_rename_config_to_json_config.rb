class RenameConfigToJsonConfig < ActiveRecord::Migration
  def change
    rename_column :field_blueprints, :config, :json_config
    rename_column :fields, :config, :json_config
  end
end
