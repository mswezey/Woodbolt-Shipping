class CreateListItems < ActiveRecord::Migration
  def self.up
    create_table :list_items do |t|
      t.integer :item_id
      t.integer :packing_slip_id
      t.string :qty
      t.string :lot_number
      t.text :comments
      t.timestamps
    end
  end
  
  def self.down
    drop_table :list_items
  end
end
