class AddThingableToFields < ActiveRecord::Migration
  def change
    change_table :fields do |t|
      t.references :thingable, polymorphic: true, index: true
    end
  end
end
