require 'chronic'

class Customer < ActiveRecord::Base
  
  has_and_belongs_to_many :teammates
  has_and_belongs_to_many :sirs
  belongs_to :program
  
  def short_name
    "#{first_name} #{last_name[0].chr}" 
  end
  
  def full_name
    "#{first_name} #{last_name}" 
  end
  
  def self.find_by_full_name(full_name)
    if full_name.nil? or full_name.empty?
      customer = Customer.new
      customer.errors.add_to_base("Please enter a customer name")
    else
      customer = Customer.find_by_sql ["select *, first_name || ' ' || last_name as full_name from customers where full_name = ?", full_name];
      if customer.nil? or customer.empty? or customer.length != 1
        customer = Customer.new
        customer.errors.add_to_base("Couldn't find a customer named #{full_name}")
      else
        customer = customer[0]
      end
    end
    return customer
  end
  
end
