class Sir < ActiveRecord::Base
  
  has_and_belongs_to_many :customers
  has_and_belongs_to_many :incidenttypes
  has_and_belongs_to_many :interventions
  has_and_belongs_to_many :users
  
  has_many :signatures
  has_many :signatories, :through => :signatures, :source => :user
  has_many :notifications
  has_many :followups
  
  has_many :workorders
  
  belongs_to :program
  belongs_to :location
  
  # for autocomplete. Not actually used.
  attr_accessor :customer_name
  attr_accessor :teammate_name
  attr_accessor :user_name
  attr_accessor :user_name2

  def validate
    if !self.incident_datetime.nil? and self.incident_datetime > Time.now
      errors.add_to_base("Incident time must be in the past")
    end
  end
  
  def title
    sir_title = ""
    unless program.nil? or program.name.empty?
      sir_title += "#{program.name}: "
    end
    unless incidenttypes.nil? or incidenttypes.empty?
      sir_title += incidenttypes[0..2].collect{|x| x.name}.to_sentence
    end
    sir_title
  end
  
  def self.page(page_number)
    if page_number.class.to_s == "String"
      return Sir.all(:order => 'incident_datetime desc')
    end
    page_number = [page_number, 0].max
    page_number = [page_number, Sir.count/PAGE_SIZE].min
    Sir.all(:offset => PAGE_SIZE*page_number, :limit => PAGE_SIZE, :order => 'incident_datetime desc')
  end
  
  def customers_to_string
    customers.collect{|x| x.short_name}.to_sentence
  end
  
  def signatories_to_string
    signatories.collect{|x| x.short_name}.to_sentence
  end

  def signed
    return !(signatories.nil? || signatories.empty?)
  end
  
  def locked
    !locker.nil?
  end

  def locker
    for signature in signatures
      if signature.program_role >= MANAGER
        return signature.user
      end
    end
    return nil
  end
  
end
