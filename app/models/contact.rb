class Contact < ActiveRecord::Base
  attr_accessible :contact_type_id, :company_name, :contact_name, :email, :street_1, :street_2, :city, :state, :zip, :phone, :fax

  validates_presence_of :contact_type_id
  validates_length_of :company_name, :minimum => 2
  validates_length_of :contact_name, :minimum => 2
  
  default_scope :order => 'company_name'
  
  named_scope :shippers, :conditions => ["contact_type_id = 1"]
  named_scope :consignees, :conditions => ["contact_type_id = 2"]
  
  CONTACT_TYPE_ID = {
    "shipper" => 1,
    "consignee" => 2,
    "third_party" => 3
  }
  CONTACT_TYPE_NAME = CONTACT_TYPE_ID.invert
  
  def contact_type
    CONTACT_TYPE_NAME[contact_type_id]
  end
  
  def contact_type_name
    contact_type.humanize
  end
  
  def name
    "#{self.first_name} #{self.last_name}"
  end
end
