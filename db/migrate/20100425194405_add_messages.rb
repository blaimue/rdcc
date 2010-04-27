class AddMessages < ActiveRecord::Migration
  def self.up
    Message.create({:description => "Please use the 'feedback' link above to report any problems or confusion.", :expiration => "2010-05-07 22:00"})
  end

  def self.down
    Message.destroy_all
  end
end
