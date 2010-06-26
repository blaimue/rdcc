class NewPermissions < ActiveRecord::Migration
  def self.up

    add_column :users, :program_role, :integer, :default => 0
    add_column :users, :hr_role, :integer, :default => 0
    add_column :users, :workorder_role, :integer, :default => 0
    
    rename_column :signatures, :role_id, :program_role
    
    # role ID maps properly to new program_role
    
    for user in User.all
      for role in user.roles
        if role.name == "program_staff"
          user.program_role = STAFF
        end
        if role.name == "program_manager" and user.program_role.nil?
          user.program_role = MANAGER
        end
        if role.name == "workorder_staff" and user.workorder_role.nil?
          user.workorder_role = STAFF
        end
        if role.name == "workorder_manager"
          user.workorder_role = MANAGER
        end
        if role.name == "hr" and user.hr_role.nil?
          user.hr_role = STAFF
        end
        if role.name == "hr_manager"
          user.hr_role = MANAGER
        end
      end
      user.save!
    end
    
    drop_table :roles
    drop_table :roles_users
    
  end

  def self.down
  end
end
