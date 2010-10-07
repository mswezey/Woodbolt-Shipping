class CreatePackingSlips < ActiveRecord::Migration
  def self.up
    create_table :packing_slips do |t|
      t.integer :shipment_id
      t.integer :shipper_id
      t.integer :consignee_id
      t.string :pallets
      t.string :total_weight
      t.string :reference_number
      t.timestamps
    end
  end
  
  def self.down
    drop_table :packing_slips
  end
end
