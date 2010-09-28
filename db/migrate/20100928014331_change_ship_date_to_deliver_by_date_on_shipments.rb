class ChangeShipDateToDeliverByDateOnShipments < ActiveRecord::Migration
  def self.up
    rename_column :shipments, :ship_date, :deliver_by_date
  end

  def self.down
    rename_column :shipments, :deliver_by_date, :ship_date
  end
end
