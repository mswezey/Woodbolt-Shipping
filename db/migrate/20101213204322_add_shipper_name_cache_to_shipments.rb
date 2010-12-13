class AddShipperNameCacheToShipments < ActiveRecord::Migration
  def self.up
    add_column :shipments, :shipper_name_cache, :string
    add_column :shipments, :consignee_name_cache, :string
    add_column :shipments, :carrier_name_cache, :string
  end

  def self.down
    remove_column :shipments, :carrier_name_cache
    remove_column :shipments, :shipper_name_cache
    remove_column :shipments, :consignee_name_cache
  end
end