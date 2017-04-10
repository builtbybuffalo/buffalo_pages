class AddAcceptsPostRequestsToPageBlueprints < ActiveRecord::Migration
  def change
    add_column :page_blueprints, :accepts_post, :boolean, default: false
    add_column :page_blueprints, :post_action, :string
  end
end
