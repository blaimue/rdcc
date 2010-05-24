class Teammate < ActiveRecord::Base
  
  has_and_belongs_to_many :customers
  has_many :notifications
  
  validates_format_of :email, :with => EMAIL_REGEX, :allow_blank => true, :allow_nil => true

  def short_name
    "#{first_name} #{last_name[0].chr}"
  end
  
  def full_name
    "#{first_name} #{last_name}"
  end

  
end
