class ChangePackingSlipPalletsTypeToInteger < ActiveRecord::Migration
  def self.up
    change_column :packing_slips, :pallets, :integer
  end

  def self.down
    change_column :packing_slips, :pallets, :string
  end
end