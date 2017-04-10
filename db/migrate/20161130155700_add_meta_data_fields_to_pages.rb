class AddMetaDataFieldsToPages < ActiveRecord::Migration
  def change
    add_column :pages, :meta_keywords, :text
    add_column :pages, :meta_title, :string
    add_column :pages, :meta_description, :text
  end
end
