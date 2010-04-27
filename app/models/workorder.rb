class Workorder < ActiveRecord::Base
  
  belongs_to :sir
  belongs_to :user

  class << self; attr_reader :STATUS end
  @STATUS = {
    :pending => 0,
    :in_progress => 1,
    :complete => 2
  }
  
  def status_names
    ["Awaiting approval", "In progress", "Complete"]
  end
  
end
