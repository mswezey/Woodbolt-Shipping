class CreateShipmentUsersJoinTable < ActiveRecord::Migration
  def self.up
    create_table :shipments_users, :id => false do |t|
      t.integer :shipment_id
      t.integer :user_id
    end
  end

  def self.down
    drop_table :shipments_users
  end
end
