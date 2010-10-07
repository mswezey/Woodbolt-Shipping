class AddBolAndPackingListToShipments < ActiveRecord::Migration
  def self.up
    add_column :shipments, :bol_file_name, :string
    add_column :shipments, :bol_content_type, :string
    add_column :shipments, :bol_file_size, :integer
    add_column :shipments, :bol_updated_at, :datetime
  end

  def self.down
    remove_column :shipments, :bol_updated_at
    remove_column :shipments, :bol_file_size
    remove_column :shipments, :bol_content_type
    remove_column :shipments, :bol_file_name
  end
end
