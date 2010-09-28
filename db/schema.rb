# This file is auto-generated from the current state of the database. Instead of editing this file, 
# please use the migrations feature of Active Record to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20100928013119) do

  create_table "carriers", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "contacts", :force => true do |t|
    t.integer  "contact_type_id"
    t.string   "first_name"
    t.string   "last_name"
    t.string   "email"
    t.string   "street_1"
    t.string   "street_2"
    t.string   "city"
    t.string   "state"
    t.string   "zip"
    t.string   "phone"
    t.string   "fax"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "pictures", :force => true do |t|
    t.integer  "owner_id",          :null => false
    t.string   "owner_type",        :null => false
    t.string   "file_file_name"
    t.string   "file_content_type"
    t.integer  "file_file_size"
    t.datetime "file_updated_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "pictures", ["owner_id", "owner_type"], :name => "index_pictures_on_owner_id_and_owner_type"

  create_table "shipments", :force => true do |t|
    t.integer  "submitter_id"
    t.integer  "assigned_to_id"
    t.integer  "bill_to_id"
    t.string   "reference_number"
    t.integer  "classification_id"
    t.string   "bol_pro_number"
    t.integer  "carrier_id"
    t.string   "carrier_invoice_number"
    t.float    "cost"
    t.date     "ship_date"
    t.datetime "picked_up_at"
    t.string   "stock_transfer_wo_number"
    t.string   "debit_memo_number"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "comments"
    t.integer  "invoiced_by_id"
    t.integer  "scheduled_by_id"
    t.date     "scheduled_pickup"
    t.integer  "pallet_qty"
    t.string   "pallet_dimentions"
    t.string   "weight"
    t.date     "bol_date"
    t.integer  "shipper_id"
    t.integer  "consignee_id"
    t.string   "state"
    t.string   "bol_file_name"
    t.string   "bol_content_type"
    t.integer  "bol_file_size"
    t.datetime "bol_updated_at"
    t.string   "packing_list_file_name"
    t.string   "packing_list_content_type"
    t.integer  "packing_list_file_size"
    t.datetime "packing_list_updated_at"
  end

  create_table "users", :force => true do |t|
    t.string   "email"
    t.string   "first_name"
    t.string   "last_name"
    t.string   "gender"
    t.string   "crypted_password"
    t.string   "password_salt"
    t.string   "persistence_token"
    t.string   "single_access_token"
    t.string   "perishable_token"
    t.integer  "login_count"
    t.integer  "failed_login_count"
    t.datetime "last_request_at"
    t.datetime "current_login_at"
    t.datetime "last_login_at"
    t.string   "current_login_ip"
    t.string   "last_login_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "picture_file_name"
    t.string   "picture_content_type"
    t.integer  "picture_file_size"
    t.datetime "picture_updated_at"
  end

end
