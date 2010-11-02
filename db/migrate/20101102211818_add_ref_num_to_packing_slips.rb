class AddRefNumToPackingSlips < ActiveRecord::Migration
  def self.up
    add_column :packing_slips, :reference_number, :string
  end

  def self.down
    remove_column :packing_slips, :reference_number
  end
end
