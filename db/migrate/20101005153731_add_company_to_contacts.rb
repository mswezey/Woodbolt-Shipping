class AddCompanyToContacts < ActiveRecord::Migration
  def self.up
    rename_column :contacts, :first_name, :company_name
    rename_column :contacts, :last_name, :contact_name    
  end

  def self.down
    rename_column :contacts, :company_name, :first_name
    rename_column :contacts, :contact_name, :last_name
  end
end
