class CreateTables < ActiveRecord::Migration
  def self.up
    create_table :users, :force => true do |t|
      
      # user info
      t.string :email, :limit => 100, :null => false
      t.string :first_name, :limit => 100, :default => ''
      t.string :last_name, :limit => 100, :default => ''
      t.string :job_title, :limit => 100, :default => ''
      t.integer :status, :limit => 100, :default => ''
      t.string :emergency_contact_name, :limit => 100, :default => ''
      t.string :emergency_contact_phone, :limit => 100, :default => ''
      t.integer :dashboard, :default => 0
      t.integer :program_id
      
      # system columns
      t.string :crypted_password, :limit => 40
      t.string :salt, :limit => 40
      t.string :remember_token, :limit => 40
      t.datetime :remember_token_expires_at
      t.timestamps
    end
    add_index :users, :email, :unique => true

    create_table :customers, :force => true do |t|
      
      # user info
      t.string :first_name, :limit => 100, :default => ''
      t.string :last_name, :limit => 100, :default => ''
      t.integer :program_id
      t.date :admitted_on
      t.date :released_on
      
      # system columns
      t.timestamps
    end

    create_table :feedbacks do |t|
      t.text :comment
      t.integer :user_id
      t.integer :status

      t.timestamps
    end

    create_table :teammates, :force => true do |t|
      
      # user info
      t.string :first_name, :limit => 100, :default => ''
      t.string :last_name, :limit => 100, :default => ''
      t.string :job_title, :limit => 100, :default => ''
      t.string :email, :limit => 100, :default => ''
      
      # system columns
      t.timestamps
    end
    add_index :teammates, :email, :unique => true
    
    create_table :customers_teammates, :force => true, :id => false do |t|
      t.integer :customer_id
      t.integer :teammate_id
    end

    create_table :workorders, :force => true do |t|
      
      t.integer :sir_id
      t.integer :priority
      t.integer :status
      t.integer :program
      t.string :location
      t.text :description
      t.boolean :risk
      t.integer :user_id
      t.date :estimation
      t.decimal :cost
      t.date :completed_on
      t.boolean :notify_on_complete
      t.text :note

      t.timestamps
    end
    
    # include customers affected?
    # include staff notifications
    
    create_table :sirs, :force => true do |t|
      t.integer :program_id
      t.integer :location_id
      t.datetime :incident_datetime
      t.text :antecedent
      t.text :description
      t.text :unsafe_behavior
      t.text :lsi_resolution
      t.datetime :der_time_in
      t.datetime :der_time_door
      t.datetime :der_time_out
      t.boolean :observation_report_completed
      t.text :injury_description
      t.text :injury_firstaid
      t.text :injury_followup
      t.text :medication_description
      t.text :medication_list
      t.text :medication_results
      t.text :medication_prevention
      t.string :police_report_number
      t.string :police_dispatcher_name
      t.string :police_officer_name
      t.text :police_description
      
      t.timestamps
    end
    
    create_table :signatures, :force => true do |t|
      t.integer :sir_id
      t.integer :user_id
      t.string :username
      t.integer :program_role
      t.timestamps
    end
    
    create_table :incidenttypes, :force => true do |t|
      t.string :name
    end
    
    create_table :programs, :force => true do |t|
      t.string :name
    end
    
    create_table :interventions, :force => true do |t|
      t.string :name
    end
    
    create_table :roles, :force => true do |t|
      t.string :name
      t.string :display
    end
    
    create_table :locations, :force => true do |t|
      t.string :name
    end
    
    create_table :incidenttypes_sirs, :force => true, :id => false do |t|
      t.integer :sir_id
      t.integer :incidenttype_id
    end
    
    create_table :sirs_users, :force => true, :id => false do |t|
      t.integer :sir_id
      t.integer :user_id
    end
    
    create_table :customers_sirs, :force => true, :id => false do |t|
      t.integer :sir_id
      t.integer :customer_id
    end
    
    create_table :interventions_sirs, :force => true, :id => false do |t|
      t.integer :sir_id
      t.integer :intervention_id
    end
    
    create_table :roles_users, :force => true, :id => false do |t|
      t.integer :role_id
      t.integer :user_id
    end
    
    create_table :notifications, :force => true, :id => false do |t|
      t.integer :sir_id
      t.datetime :notification_datetime
      t.integer :teammate_id
      t.integer :user_id
      t.integer :notified_by
      t.timestamps
    end
    
    create_table :messages, :force => true do |t|
      t.text :description
      t.datetime :expiration
      t.timestamps
    end
    
  end

  def self.down
    drop_table :users unless self.check_table("users")
    drop_table :customers unless self.check_table("customers")
    drop_table :teammates unless self.check_table("teammates")
    
    drop_table :workorders unless self.check_table("workorders")
    drop_table :feedbacks unless self.check_table("feedbacks")
    drop_table :sirs unless self.check_table("sirs")
    drop_table :signatures unless self.check_table("signatures")
    drop_table :notifications unless self.check_table("notifications")
    drop_table :messages unless self.check_table("messages")
    
    drop_table :incidenttypes unless self.check_table("incidenttypes")
    drop_table :interventions unless self.check_table("interventions")
    drop_table :programs unless self.check_table("programs")
    drop_table :roles unless self.check_table("roles")
    drop_table :locations unless self.check_table("locations")
    
    drop_table :customers_teammates unless self.check_table("customers_teammates")
    drop_table :incidenttypes_sirs unless self.check_table("incidenttypes_sirs")
    drop_table :sirs_users unless self.check_table("sirs_users")
    drop_table :customers_sirs unless self.check_table("customers_sirs")
    drop_table :interventions_sirs unless self.check_table("interventions_sirs")
    drop_table :roles_users unless self.check_table("roles_users")
  end

  private
  
  def self.check_table(name)
    begin
      User.connection.execute("select 1 from #{name}")
      say "Checking For Table: #{name} => Table Found"
      return false;
    rescue
      say "Checking For Table: #{name} => Table Not Found"
      return true;
    end
  end
end



