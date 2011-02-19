require 'chronic'

class Customer < ActiveRecord::Base
  
  has_and_belongs_to_many :teammates
  has_and_belongs_to_many :sirs
  belongs_to :program
  
  def short_name
    "#{first_name} #{last_name[0].chr unless last_name.nil? or last_name[0].nil?}"
  end
  
  def full_name
    "#{first_name} #{last_name}" 
  end
  
  def self.find_active
    customers = Customer.find(:all, :order => "first_name asc, last_name asc")
    customers.reject!{|c| !c.released_on.nil? && c.released_on < Date.today}
    return customers
  end
  
  def self.all
    Customer.find(:all, :order => "first_name asc, last_name asc")
  end
end
