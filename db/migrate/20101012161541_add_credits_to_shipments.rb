class AddCreditsToShipments < ActiveRecord::Migration
  def self.up
    add_column :shipments, :has_credit, :boolean, :default => false
    add_column :shipments, :credit_amount, :float, :precision => 8, :scale => 2
    add_column :shipments, :credit_memo_number, :string
    add_column :shipments, :credit_memo, :text
  end

  def self.down
    remove_column :shipments, :credit_memo
    remove_column :shipments, :credit_memo_number
    remove_column :shipments, :credit_amount
    remove_column :shipments, :has_credit
  end
end
