class Contact < ActiveRecord::Base
  attr_accessible :contact_type_id, :first_name, :last_name, :email, :street_1, :street_2, :city, :state, :zip, :phone, :fax
  
  validates_length_of :first_name, :minimum => 2
  validates_length_of :last_name, :minimum => 2
  
  named_scope :shippers, :conditions => ["contact_type_id = 1"]
  named_scope :consignees, :conditions => ["contact_type_id = 2"]
  
  CONTACT_TYPE_ID = {
    "Shipper" => 1,
    "Consignee" => 2
  }
  CONTACT_TYPE_NAME = CONTACT_TYPE_ID.invert
  
  def contact_type
    CONTACT_TYPE_NAME[contact_type_id]
  end
  
  def name
    "#{self.first_name} #{self.last_name}"
  end
end
