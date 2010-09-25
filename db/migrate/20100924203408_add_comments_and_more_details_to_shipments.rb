class AddCommentsAndMoreDetailsToShipments < ActiveRecord::Migration
  def self.up
    add_column :shipments, :comments, :text
    add_column :shipments, :invoiced_by_id, :integer
    add_column :shipments, :scheduled_by_id, :integer
    add_column :shipments, :scheduled_pickup, :date
    add_column :shipments, :pallet_qty, :integer
    add_column :shipments, :pallet_dimentions, :string
    add_column :shipments, :weight, :string
    add_column :shipments, :bol_date, :date
    add_column :shipments, :shipper_id, :integer
    add_column :shipments, :consignee_id, :integer
  end

  def self.down
    remove_column :shipments, :consignee_id
    remove_column :shipments, :shipper_id
    remove_column :shipments, :bol_date
    remove_column :shipments, :weight
    remove_column :shipments, :pallet_dimentions
    remove_column :shipments, :pallet_qty
    remove_column :shipments, :scheduled_pickup
    remove_column :shipments, :scheduled_by_id
    remove_column :shipments, :invoiced_by_id
    remove_column :shipments, :comments
  end
end
