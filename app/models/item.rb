class Item < ActiveRecord::Base
  attr_accessible :name, :uom
  
  has_many :list_items
  
  default_scope :order => 'name'
  
end
