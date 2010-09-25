class CreateContacts < ActiveRecord::Migration
  def self.up
    create_table :contacts do |t|
      t.integer :contact_type_id
      t.string :first_name
      t.string :last_name
      t.string :email
      t.string :street_1
      t.string :street_2
      t.string :city
      t.string :state
      t.string :zip
      t.string :phone
      t.string :fax
      t.timestamps
    end
  end
  
  def self.down
    drop_table :contacts
  end
end
