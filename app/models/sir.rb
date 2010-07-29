require 'chronic'

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
  
  attr_accessor :bad_incident_datetime_parse, :bad_der_time_in_parse, :bad_der_time_door_parse, :bad_der_time_out_parse

  def validate
    if !self.incident_datetime.nil? and self.incident_datetime > Time.now
      errors.add_to_base("Incident Time must be in the past")
    end
    if !self.der_time_in.nil? and self.der_time_in > Time.now
      errors.add_to_base("DER Time In must be in the past")
    end
    if !self.der_time_door.nil? and self.der_time_door > Time.now
      errors.add_to_base("DER Time Door must be in the past")
    end
    if !self.der_time_out.nil? and self.der_time_out > Time.now
      errors.add_to_base("DER Time Out must be in the past")
    end
    
    errors.add_to_base("Sorry, couldn't parse Incident Time. Please try again, eg 'July 10, 3:40pm'") if @bad_incident_datetime_parse
    errors.add_to_base("Sorry, couldn't parse DER Time In. Please try again, eg 'July 10, 3:40pm'") if @bad_der_time_in_parse
    errors.add_to_base("Sorry, couldn't parse DER Time Door. Please try again, eg 'July 10, 3:40pm'") if @bad_der_time_door_parse
    errors.add_to_base("Sorry, couldn't parse DER Time Out. Please try again, eg 'July 10, 3:40pm'") if @bad_der_time_out_parse
    # logger.info("Setting incident datetime to #{@incident_datetime.to_s(:db)}")
  end
  
  def incident_datetime_string
    self.incident_datetime.to_s
  end
  
  def der_time_in_string
    self.der_time_in.to_s
  end
  
  def der_time_door_string
    self.der_time_door.to_s
  end
  
  def der_time_out_string
    self.der_time_out.to_s
  end
  
  def incident_datetime_string=(idt)
    self.incident_datetime = Chronic.parse(idt)
    @bad_incident_datetime_parse = (self.incident_datetime.nil? and !idt.empty?)
  end
  
  def der_time_in_string=(det)
    self.der_time_in = Chronic.parse(det)
    @bad_der_time_in_parse = (self.der_time_in.nil? and !det.empty?)
  end
  
  def der_time_door_string=(det)
    self.der_time_door = Chronic.parse(det)
    @bad_der_time_door_parse = (self.der_time_door.nil? and !det.empty?)
  end
  
  def der_time_out_string=(det)
    self.der_time_out = Chronic.parse(det)
    @bad_der_time_out_parse = (self.der_time_out.nil? and !det.empty?)
  end
  
  def self.histogram_by_date()
    sirs = Sir.find(:all)
    hash = {}
    for sir in sirs
      bucket = hash[sir.incident_datetime.to_s(:date)]
      if bucket.nil?
        bucket = []
        hash[sir.incident_datetime.to_s(:date)] = bucket
      end
      bucket.push(sir)
    end
    return hash
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
