class AddContentRepeatersTable < ActiveRecord::Migration
  def change
    create_table :repeater_groups do |t|
      t.belongs_to :repeater, index: true
      t.string :group
      t.integer :position
    end
  end
end
