class AddPrograms < ActiveRecord::Migration
  def self.up
    Program.create({:name => "BRS"})
    Program.create({:name => "SILP"})
    Program.create({:name => "SILS"})
    Program.create({:name => "YFS"})
  end

  def self.down
    Program.destroy_all
  end
end
