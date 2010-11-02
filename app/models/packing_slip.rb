class PackingSlip < ActiveRecord::Base
  attr_accessible :shipment_id, :shipper_id, :consignee_id, :pallets, :total_weight, :list_items_attributes, :reference_number
  
  has_many :list_items, :dependent => :destroy
  belongs_to :shipment
  belongs_to :shipper, :class_name => "Contact"
  belongs_to :consignee, :class_name => "Contact"
  
  accepts_nested_attributes_for :list_items, :reject_if => lambda { |a| a[:item_id].blank? }, :allow_destroy => true
  
  validates_presence_of :shipper, :consignee, :pallets, :total_weight


  def total_qty
    list_items.map(&:qty).sum
  end
  
  def shipper_name
    shipper.try(:company_name)
  end
  
  def consignee_name
    consignee.try(:company_name)
  end
  
  def jqgrid_action_links
     "<center><a href='/packing_slips/#{id}'>View</a> <a href='/packing_slips/#{id}/edit'>Edit</a> | <a href='/shipments/create_from_packing_slip/#{id}'>Create Shipment</a></center>"
  end
end
