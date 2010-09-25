class User < ActiveRecord::Base
  acts_as_authentic
  # has_attached_file :picture,
  #                   :styles => { :thumb => '45x45#', :small => '100x100#', :medium => '315x230#', :large => '500x500>', :original => '800x800>' },
  #                   :storage => :s3,
  #                   :s3_credentials => "#{RAILS_ROOT}/config/s3.yml",
  #                   :url => "/assets/pictures/:id/:style.:extension",
  #                   :path => "/assets/pictures/:id/:style.:extension"
  # 
  # validates_attachment_size :picture, :less_then => 2.megabytes, :message => "The photo must be no more than #{2.megabytes}"
  # validates_attachment_content_type :picture, :content_type => ['image/jpeg', 'image/jpg', 'image/png'], :message => "Only JPEG and PNG files are allowed."
  has_many :pictures, :as => :owner, :dependent => :destroy
  accepts_nested_attributes_for :pictures, :reject_if => lambda { |a| a[:file].blank? }, :allow_destroy => true
  
  def name
    "#{self.first_name} #{self.last_name}"
  end
  
  def deliver_password_reset_instructions!  
    reset_perishable_token!  
    Notifier.deliver_password_reset_instructions(self)  
  end
end
