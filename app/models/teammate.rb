class Teammate < ActiveRecord::Base
  
  has_and_belongs_to_many :customers
  has_many :notifications
  
  validates_format_of :email, :with => EMAIL_REGEX, :allow_blank => true, :allow_nil => true
  
end
