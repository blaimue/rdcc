class NoFeedback < ActiveRecord::Migration
  def self.up
    drop_table :feedbacks unless self.check_table("feedbacks")
  end

  def self.down
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
