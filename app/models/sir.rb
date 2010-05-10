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
    required_role = Role.find_by_name("program_manager")
    for signature in signatures
      if signature.role == required_role
        return signature.user
      end
    end
    return nil
  end
  
end
