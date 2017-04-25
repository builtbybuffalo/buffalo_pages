class AddHomepageToPages < ActiveRecord::Migration[5.0]
  def change
    change_table :pages do |t|
      t.boolean :homepage, default: false
    end
  end
end
