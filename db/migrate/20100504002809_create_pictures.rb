class CreatePictures < ActiveRecord::Migration
  def self.up
    create_table :pictures do |t|
      t.references :owner, :polymorphic => true, :null => false
      t.string :file_file_name
      t.string :file_content_type
      t.integer :file_file_size
      t.datetime :file_updated_at
      t.timestamps
    end
    add_index :pictures, [:owner_id, :owner_type]
  end

  def self.down
    drop_table :pictures
  end
end  
