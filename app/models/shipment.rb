class Shipment < ActiveRecord::Base
  attr_accessible :packing_slip_attributes, :refrigerate, :submitter_id, :assigned_to_id, :bill_to_id, :reference_number, :classification_id, :bol_pro_number, :carrier_id, :carrier_invoice_number, :cost, :deliver_by_date, :picked_up_at, :stock_transfer_wo_number, :debit_memo_number, :comments, :invoiced_by, :scheduled_by_id, :scheduled_pickup, :pallet_qty, :pallet_dimentions, :weight, :bol_date, :consignee_id, :invoiced_by, :shipper_id, :state, :bol, :packing_list, :has_credit, :credit_amount, :credit_memo_number, :credit_memo, :credits_applied, :user_ids, :shipper_name_cache
  attr_accessor :delivered_check, :invoiced_check
  validates_presence_of :classification_id, :packing_slip, :bill_to, :invoiced_by
  # validates_uniqueness_of :reference_number


  validates_attachment_presence :bol, :if => lambda { |o| o.state == "delivered" }
  validates_presence_of :picked_up_at, :if => lambda { |o| o.state == "delivered" }
  validates_presence_of :stock_transfer_wo_number, :if => lambda { |o| o.state == "delivered" }

  validates_presence_of :carrier_invoice_number, :cost, :if => lambda { |o| o.state == "invoiced" }

  belongs_to :submitter, :class_name => "User"
  belongs_to :scheduled_by, :class_name => "User"
  belongs_to :bill_to, :class_name => "Contact"
  belongs_to :assigned_to, :class_name => "User"
  has_one :shipper, :through => :packing_slip
  has_one :consignee, :through => :packing_slip
  belongs_to :carrier
  has_one :packing_slip
  has_many :notes
  has_and_belongs_to_many :users # for notifications
  
  after_validation :update_name_caches
  
  accepts_nested_attributes_for :packing_slip
  
  has_attached_file :bol,
                    :storage => :s3,
                    :s3_credentials => "#{RAILS_ROOT}/config/s3.yml",
                    :url => "/shipments/:id/bol/:id-:style.:extension",
                    :path => "/shipments/:id/bol/:id-:style.:extension"

  CLASSIFICATION_TYPE_ID = {
    "FI" => 1,
    "FO" => 2,
    "PL" => 3,
    "MISC" => 4
  }
  CLASSIFICATION_TYPE_NAME = CLASSIFICATION_TYPE_ID.invert
  
  def update_name_caches
    update_attribute(:shipper_name_cache, shipper_name)
    update_attribute(:consignee_name_cache, consignee_name)
    update_attribute(:carrier_name_cache, carrier_name)
  end
  
  def classification_type
    CLASSIFICATION_TYPE_NAME[classification_id]
  end
  
  #for js datagrid
  def packing_slip_info
    "<center><a href='/packing_slips/#{packing_slip.id}'>View</a> <a href='/packing_slips/#{packing_slip.id}/edit'>Edit</a></center>"
  end
  
  def bol_file
    bol.exists? ? "<center><a target='_blank' href='#{bol.url}'>Download</a> <a href='#' onclick='$(this).parent().trigger(\"click\")'>Edit</a></center>" : "<center>Click to upload</center>"
  end
  
  def credits_applied_check
    has_credit ? (credits_applied ? "<input type='checkbox' name='credits_applied' checked='checked' disabled='disabled' />" : "<input type='checkbox' name='credits_applied' />") : nil
  end
  
  # def self.fi_count
  #   Shipment.all(:conditions => {:classification_id => 1}).size
  # end
  # 
  # def self.fo_count
  #   Shipment.all(:conditions => {:classification_id => 2}).size
  # end
  # 
  # def self.pl_count
  #   Shipment.all(:conditions => {:classification_id => 3}).size
  # end
  # 
  # def self.misc_count
  #   Shipment.all(:conditions => {:classification_id => 4}).size
  # end
  # 
  # def generate_ref_num
  #   ref_num = case classification_id
  #     when 1 then  "FI-#{Shipment.fi_count}"
  #     when 2 then  "FO-#{Shipment.fo_count}"
  #     when 3 then  "PL-#{Shipment.pl_count}"
  #     when 4 then  "MISC-#{Shipment.misc_count}"
  #   end
  #   self.update_attribute(:reference_number, ref_num)
  # end
  
  def generate_ref_num
    self.update_attribute(:reference_number, "#{classification_type}-#{id}")
  end
  
  def reference_number
    "<a href='/shipments/#{id}'>#{classification_type}-#{id}</a>"
  end
  
  def deliver_link
    "<a href='#' class='deliver'>Deliver</a>"
  end
  
  def invoice_link
    "<a href='#' class='invoice'>Invoice</a>"
  end
  
  def shipper_name
    shipper.try(:company_name)
  end
  
  def consignee_name
    consignee.try(:company_name)
  end
  
  def carrier_name
    carrier.try(:name)
  end
  
  state_machine :state, :initial => :created do
    after_transition :on => :set_to_pending, :do => :notify_assignee
    
    event :set_to_pending do
      transition :created => :pending
    end
    
    event :deliver do
      transition :pending => :delivered
    end
    
    event :invoice do
      transition :delivered => :invoiced
    end

    state :created, :pending, :delivered, :invoiced do
    end

  end
  
  def notify_assignee
    Notifier.deliver_shipment_assigned(self)
  end
  
end