class ListItem < ActiveRecord::Base
  attr_accessible :item_id, :packing_slip_id, :qty, :lot_number, :comments
  
  belongs_to :item
  belongs_to :packing_slip
  has_one :shipment, :through => :packing_slip
  
  validates_presence_of :qty
  
  def item_name
    "#{item.try(:name)} (#{item.try(:uom)})"
  end
end
