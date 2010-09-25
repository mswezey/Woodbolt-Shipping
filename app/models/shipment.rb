class Shipment < ActiveRecord::Base
  attr_accessible :submitter_id, :assigned_to_id, :bill_to_id, :reference_number, :classification_id, :bol_pro_number, :carrier_id, :carrier_invoice_number, :cost, :ship_date, :picked_up_at, :stock_transfer_wo_number, :debit_memo_number, :comments, :invoiced_by_id, :scheduled_by_id, :scheduled_pickup, :pallet_qty, :pallet_dimentions, :weight, :bol_date
  has_one :submitter, :class_name => "User"
  has_one :scheduled_by, :class_name => "User"
  has_one :invoiced_by, :class_name => "User"
  has_one :assigned_to, :class_name => "User"
  has_one :shipper, :class_name => "User"
  has_one :cosignee, :class_name => "User"
  has_one :carrier, :class_name => "Contact"

  CLASSIFICATION_TYPE_ID = {
    "FI" => 1,
    "FO" => 2,
    "PL" => 2,
    "MISC" => 2
  }
  CLASSIFICATION_TYPE_NAME = CLASSIFICATION_TYPE_ID.invert
  
  def classification_type
    CLASSIFICATION_TYPE_NAME[classification_id]
  end
  
end