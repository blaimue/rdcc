class Workorder < ActiveRecord::Base
  
  belongs_to :sir
  belongs_to :user
  belongs_to :program

  class << self; attr_reader :STATUS end
  @STATUS = {
    :denied => -1,
    :pending => 0,
    :in_progress => 1,
    :complete => 2
  }
  
  def display_status
    case status
    when 0:
      "Pending approval"
    when 1:
      "In progress"
    when 2:
      "Complete"
    when -1:
      "Denied"
    end
  end

  def complete?
    !completed_on.nil?
  end
  
  def self.all
    Workorder.find(:all, :order => 'status asc, risk desc')
  end
  
end
