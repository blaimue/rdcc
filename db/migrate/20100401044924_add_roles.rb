class AddRoles < ActiveRecord::Migration
  def self.up
    Role.create({:name => "program_staff", :display => "Program Staff"})
    Role.create({:name => "program_manager", :display => "Program Manager"})
    Role.create({:name => "workorder_staff", :display => "Workorder Staff"})
    Role.create({:name => "workorder_manager", :display => "Workorder Manager"})
    Role.create({:name => "hr", :display => "HR"})
    
    user = User.find(:first)
    user.roles << Role.find_by_name("hr")
  end

  def self.down
  end
end
