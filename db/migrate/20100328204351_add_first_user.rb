class AddFirstUser < ActiveRecord::Migration
  def self.up
    user = User.create({:first_name => "Chris",
      :last_name => "Doyle",
      :email => "blaimue@gmail.com",
      :job_title => "Independent contractor",
      :status => User.STATUS[:parttime],
      :password => "rdcc444",
      :password_confirmation => "rdcc444",
      :dashboard => 2
    })
  end

  def self.down
    User.destroy_all
  end
end
