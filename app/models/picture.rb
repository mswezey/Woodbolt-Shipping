class Picture < ActiveRecord::Base
  belongs_to :owner, :polymorphic => true
  # Don't forget to add your S3 credentials!
  has_attached_file :file,
                    :styles => { :thumb => '45x45#', :small => '100x75#', :medium => '315x230#', :large => '600x450#', :original => '800x800>' },
                    :storage => :s3,
                    :s3_credentials => "#{RAILS_ROOT}/config/s3.yml",
                    :url => "/assets/pictures/:id/:style.:extension",
                    :path => "/assets/pictures/:id/:style.:extension"
  
  validates_attachment_size :file, :less_then => 2.megabytes, :message => "The photo must be no more than #{2.megabytes}"
  validates_attachment_content_type :file, :content_type => ['image/jpeg', 'image/png'], :message => "Only JPEG and PNG files are allowed."
  
end
