class CreatePages < ActiveRecord::Migration
  def change
    create_table :pages do |t|
      t.string :name
      t.string :slug
      t.belongs_to :page_blueprint
      t.timestamps
    end
  end
end
