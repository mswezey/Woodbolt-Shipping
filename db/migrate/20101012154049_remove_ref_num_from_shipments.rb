class RemoveRefNumFromShipments < ActiveRecord::Migration
  def self.up
    remove_column :packing_slips, :reference_number
    remove_column :shipments, :reference_number
  end

  def self.down
    add_column :shipments, :reference_number, :string
    add_column :packing_slips, :reference_number, :string
  end
end
