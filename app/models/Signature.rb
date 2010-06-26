class Signature < ActiveRecord::Base
  belongs_to :sir
  belongs_to :user
  
  validate :signed_own_name
  
  def signed_own_name
    if username != "#{user.first_name} #{user.last_name}"
      errors.add_to_base("You must type your full name as it appears in your HR record (#{user.first_name} #{user.last_name})")
    end
  end
  
end