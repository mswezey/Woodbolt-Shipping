class ChangePickedUpAtToString < ActiveRecord::Migration
  def self.up
    change_column :shipments, :picked_up_at, :string
    change_column :shipments, :invoiced_by_id, :string
    rename_column :shipments, :invoiced_by_id, :invoiced_by
  end

  def self.down
    rename_column :shipments, :invoiced_by, :invoiced_by_id
    change_column :shipments, :invoiced_by_id, :integer
    change_column :shipments, :picked_up_at, :datetime
  end
end
