class Carrier < ActiveRecord::Base
  attr_accessible :name
  
  validates_length_of :name, :minimum => 2
  
  has_many :shipments
end
