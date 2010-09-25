class CreateShipments < ActiveRecord::Migration
  def self.up
    create_table :shipments do |t|
      t.integer :submitter_id
      t.integer :assigned_to_id
      t.integer :bill_to_id
      t.string :reference_number
      t.integer :classification_id
      t.string :bol_pro_number
      t.integer :carrier_id
      t.string :carrier_invoice_number
      t.float :cost, :precision => 8, :scale => 2
      t.date :ship_date
      t.datetime :picked_up_at
      t.string :stock_transfer_wo_number
      t.string :debit_memo_number
      t.timestamps
    end
  end
  
  def self.down
    drop_table :shipments
  end
end
