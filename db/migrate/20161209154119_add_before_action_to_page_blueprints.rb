class AddBeforeActionToPageBlueprints < ActiveRecord::Migration
  def change
    add_column :page_blueprints, :before_action, :string
  end
end
