class AddAttachableScopeToAssets < ActiveRecord::Migration
  def change
    add_column :assets, :attachable_scope, :string
  end
end
