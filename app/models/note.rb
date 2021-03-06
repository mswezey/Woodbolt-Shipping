class Note < ActiveRecord::Base
  attr_accessible :shipment_id, :user_id, :content
  
  belongs_to :user
  belongs_to :shipment
  
  validates_presence_of :user, :content
  
  default_scope :order => 'created_at DESC'
  
  after_create :email_users
  
  def email_users
    Notifier.deliver_new_note(self) if shipment && shipment.users.size > 0
  end
  
end
