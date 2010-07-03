class CreatePreferences < ActiveRecord::Migration
  def self.up
    create_table :preferences do |t|
      t.string :name, :null => false
      t.references :owner, :polymorphic => true, :null => false
      t.references :group, :polymorphic => true
      t.string :value
      t.timestamps
    end
    add_index :preferences, [:owner_id, :owner_type, :name, :group_id, :group_type], :unique => true, :name => 'index_preferences_on_owner_and_name_and_preference'
  end
  
  def self.down
    drop_table :preferences unless self.check_table("preferences")
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
