class AddTemplateNameToPageBlueprints < ActiveRecord::Migration
  def change
    add_column :page_blueprints, :template, :string
  end
end
