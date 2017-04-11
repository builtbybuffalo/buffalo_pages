class AddRepeatableToFeilds < ActiveRecord::Migration
  def change
    change_table :fields do |t|
      t.belongs_to :repeatable, polymorphic: true
    end
  end
end
