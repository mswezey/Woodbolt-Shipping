class User < ActiveRecord::Base
  acts_as_authentic
  has_attached_file :picture,
                      :styles => { :thumb => '45x45#', :small => '100x100#', :medium => '315x230#', :large => '500x500>', :original => '800x800>' },
                      :storage => :s3,
                      :s3_credentials => "#{RAILS_ROOT}/config/s3.yml",
                      :url => "/users/pictures/:id/:style.:extension",
                      :path => "/users/pictures/:id/:style.:extension"
    
  # validates_attachment_size :picture, :less_then => 2.megabytes, :message => "The photo must be no more than #{2.megabytes}"
  # validates_attachment_content_type :picture, :content_type => ['image/jpeg', 'image/jpg', 'image/png'], :message => "Only JPEG and PNG files are allowed."
  
  has_many :pictures, :as => :owner, :dependent => :destroy
  accepts_nested_attributes_for :pictures, :reject_if => lambda { |a| a[:file].blank? }, :allow_destroy => true
  
  has_many :assigned_shipments, :class_name => 'Shipment', :foreign_key => 'assigned_to_id'
  has_many :notes
  has_and_belongs_to_many :shipments # for notifications
  
  # MS: this is for admins of the application
  ROLES = %w[admin] # MS: This is for the bitmask.. ONLY ADD NEW ROLES TO THE END OF THIS ARRAY
  
  def roles=(roles)
    self.roles_mask = (roles & ROLES).map { |r| 2**ROLES.index(r) }.sum
  end
  
  def roles
    ROLES.reject { |r| ((roles_mask || 0) & 2**ROLES.index(r)).zero? }
  end
  
  def role?(role)
    roles.map(&:to_sym).include?(role)
  end
  
  def admin?
    roles.include?("admin")
  end
  
  def name
    "#{self.first_name} #{self.last_name}"
  end
  
  def deliver_password_reset_instructions!  
    reset_perishable_token!  
    Notifier.deliver_password_reset_instructions(self)  
  end
end
