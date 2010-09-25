class Shipment < ActiveRecord::Base
  attr_accessible :submitter_id, :assigned_to_id, :bill_to_id, :reference_number, :classification_id, :bol_pro_number, :carrier_id, :carrier_invoice_number, :cost, :ship_date, :picked_up_at, :stock_transfer_wo_number, :debit_memo_number, :comments, :invoiced_by_id, :scheduled_by_id, :scheduled_pickup, :pallet_qty, :pallet_dimentions, :weight, :bol_date, :consignee_id, :invoiced_by, :shipper_id, :state, :bol, :packing_list
  belongs_to :submitter, :class_name => "User"
  belongs_to :scheduled_by, :class_name => "User"
  belongs_to :bill_to, :class_name => "Contact"
  belongs_to :invoiced_by, :class_name => "User"
  belongs_to :assigned_to, :class_name => "User"
  belongs_to :shipper, :class_name => "Contact"
  belongs_to :consignee, :class_name => "Contact"
  belongs_to :carrier, :class_name => "Contact"
  
  has_attached_file :bol,
                    :storage => :s3,
                    :s3_credentials => "#{RAILS_ROOT}/config/s3.yml",
                    :url => "/shipments/:id/bol/:style.:extension",
                    :path => "/shipments/:id/bol/:style.:extension"

  has_attached_file :packing_list,
                    :storage => :s3,
                    :s3_credentials => "#{RAILS_ROOT}/config/s3.yml",
                    :url => "/shipments/:id/packing_list/:style.:extension",
                    :path => "/shipments/:id/packing_list/:style.:extension"
  
  after_create :notify_assignee

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
  
  state_machine :state, :initial => :pending do

    event :deliver do
      transition :pending => :delivered, :if => :ready_for_deliver?
    end

    state :pending, :delivered, :invoiced do
    end

  end
  
  def notify_assignee

  end
  
  def ready_for_deliver?
    true
  end
  
end