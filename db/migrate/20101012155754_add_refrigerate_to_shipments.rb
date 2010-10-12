class AddRefrigerateToShipments < ActiveRecord::Migration
  def self.up
    add_column :shipments, :refrigerate, :boolean, :default => false
  end

  def self.down
    remove_column :shipments, :refrigerate
  end
end
