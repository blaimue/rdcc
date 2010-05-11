class CreateFollowups < ActiveRecord::Migration
  def self.up
    create_table :followups do |t|
      t.string :comment
      t.integer :sir_id
      t.integer :user_id

      t.timestamps
    end
  end

  def self.down
    drop_table :followups unless self.check_table("followups")
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
