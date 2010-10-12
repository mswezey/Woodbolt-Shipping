class AddCreditsAppliedToShipments < ActiveRecord::Migration
  def self.up
    add_column :shipments, :credits_applied, :boolean
  end

  def self.down
    remove_column :shipments, :credits_applied
  end
end
