class AddLocations < ActiveRecord::Migration
  def self.up
    Location.create({:name => "Campus"})
    Location.create({:name => "Community"})
    Location.create({:name => "Home"})
    Location.create({:name => "School"})
  end

  def self.down
    Location.destroy_all
  end
end
