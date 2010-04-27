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

ActiveRecord::Schema.define(:version => 20100425194405) do

  create_table "customers", :force => true do |t|
    t.string   "first_name",  :limit => 100, :default => ""
    t.string   "last_name",   :limit => 100, :default => ""
    t.integer  "program_id"
    t.date     "admitted_on"
    t.date     "released_on"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "customers_sirs", :id => false, :force => true do |t|
    t.integer "sir_id"
    t.integer "customer_id"
  end

  create_table "customers_teammates", :id => false, :force => true do |t|
    t.integer "customer_id"
    t.integer "teammate_id"
  end

  create_table "feedbacks", :force => true do |t|
    t.text     "comment"
    t.integer  "user_id"
    t.integer  "status"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "incidenttypes", :force => true do |t|
    t.string "name"
  end

  create_table "incidenttypes_sirs", :id => false, :force => true do |t|
    t.integer "sir_id"
    t.integer "incidenttype_id"
  end

  create_table "interventions", :force => true do |t|
    t.string "name"
  end

  create_table "interventions_sirs", :id => false, :force => true do |t|
    t.integer "sir_id"
    t.integer "intervention_id"
  end

  create_table "locations", :force => true do |t|
    t.string "name"
  end

  create_table "messages", :force => true do |t|
    t.text     "description"
    t.datetime "expiration"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "notifications", :id => false, :force => true do |t|
    t.integer  "sir_id"
    t.datetime "notification_datetime"
    t.integer  "teammate_id"
    t.integer  "user_id"
    t.integer  "notified_by"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "programs", :force => true do |t|
    t.string "name"
  end

  create_table "roles", :force => true do |t|
    t.string "name"
    t.string "display"
  end

  create_table "roles_users", :id => false, :force => true do |t|
    t.integer "role_id"
    t.integer "user_id"
  end

  create_table "signatures", :force => true do |t|
    t.integer  "sir_id"
    t.integer  "user_id"
    t.string   "username"
    t.integer  "role_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "sirs", :force => true do |t|
    t.integer  "program_id"
    t.integer  "location_id"
    t.datetime "incident_datetime"
    t.text     "antecedent"
    t.text     "description"
    t.text     "unsafe_behavior"
    t.text     "lsi_resolution"
    t.datetime "der_time_in"
    t.datetime "der_time_door"
    t.datetime "der_time_out"
    t.boolean  "observation_report_completed"
    t.text     "injury_description"
    t.text     "injury_firstaid"
    t.text     "injury_followup"
    t.text     "medication_description"
    t.text     "medication_list"
    t.text     "medication_results"
    t.text     "medication_prevention"
    t.string   "police_report_number"
    t.string   "police_dispatcher_name"
    t.string   "police_officer_name"
    t.text     "police_description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "sirs_users", :id => false, :force => true do |t|
    t.integer "sir_id"
    t.integer "user_id"
  end

  create_table "teammates", :force => true do |t|
    t.string   "first_name", :limit => 100, :default => ""
    t.string   "last_name",  :limit => 100, :default => ""
    t.string   "job_title",  :limit => 100, :default => ""
    t.string   "email",      :limit => 100, :default => ""
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "teammates", ["email"], :name => "index_teammates_on_email", :unique => true

  create_table "users", :force => true do |t|
    t.string   "email",                     :limit => 100,                 :null => false
    t.string   "first_name",                :limit => 100, :default => ""
    t.string   "last_name",                 :limit => 100, :default => ""
    t.string   "job_title",                 :limit => 100, :default => ""
    t.integer  "status",                    :limit => 100, :default => 0
    t.string   "emergency_contact_name",    :limit => 100, :default => ""
    t.string   "emergency_contact_phone",   :limit => 100, :default => ""
    t.integer  "dashboard",                                :default => 0
    t.integer  "program_id"
    t.string   "crypted_password",          :limit => 40
    t.string   "salt",                      :limit => 40
    t.string   "remember_token",            :limit => 40
    t.datetime "remember_token_expires_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true

  create_table "workorders", :force => true do |t|
    t.integer  "sir_id"
    t.integer  "priority"
    t.integer  "status"
    t.integer  "program"
    t.string   "location"
    t.text     "description"
    t.boolean  "risk"
    t.integer  "user_id"
    t.date     "estimation"
    t.decimal  "cost"
    t.date     "completed_on"
    t.boolean  "notify_on_complete"
    t.text     "note"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
