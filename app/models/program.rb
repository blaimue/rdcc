class Program < ActiveRecord::Base
  has_many :customers
  has_many :sirs
  has_many :users
  has_many :workorders
end
