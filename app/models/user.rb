class User < ActiveRecord::Base
  
  class << self; attr_reader :STATUS end
  @STATUS = {
    :fulltime => 0,
    :parttime => 1,
    :inactive => 2
  }
  class << self; attr_reader :DASHBOARD end
  @DASHBOARD = {
    :restricted => 0,
    :program_staff => 1,
    :program_manager => 2,
    :workorder_staff => 3,
    :workorder_manager => 4
  }
  
  has_many :workorders
  has_many :signatures
  has_many :signed_sirs, :through => :signatures, :source => :sir
  has_many :feedbacks
  has_many :followups
  has_many :notifications_sent, :class_name => "Notification", :foreign_key => :notified_by
  has_many :notifications_received, :class_name => "Notification", :foreign_key => :user_id
  has_and_belongs_to_many :sirs
  belongs_to :program

  validates_format_of :email, :with => EMAIL_REGEX
  validates_uniqueness_of :email
  
  attr_accessor :password_confirmation
  validates_confirmation_of :password

  def password=(pwd)
    @password = pwd
    self.salt = self.object_id.to_s + rand.to_s
    self.crypted_password = User.sha1(salt, pwd)
  end
  
  def password
    @password
  end

  def status_name
    User.status_names()[status]
  end
  
  def role_names
    roles = []
    if program_role == STAFF
      roles.push("Program staff")
    elsif program_role == MANAGER
      roles.push("Program manager")
    end
    if hr_role == STAFF
      roles.push("HR staff")
    elsif hr_role == MANAGER
      roles.push("HR manager")
    end
    if workorder_role == STAFF
      roles.push("Maintenance staff")
    elsif workorder_role == MANAGER
      roles.push("Maintenance manager")
    end
    return roles.to_sentence
  end
  
  def self.status_names
    ["Full Time", "Part Time", "Inactive"]
  end

  def self.find_active
    User.find(:all, :order => 'first_name asc, last_name asc', :conditions => ["status != ?", User.STATUS[:inactive]])
  end
  
  def self.find_active_program
    User.find(:all, :order => 'first_name asc, last_name asc', :conditions => ["status != ? and program_role >= ?", User.STATUS[:inactive], STAFF])
  end
  
  def self.find_by_role(role, level)
    role_names = {
      HR => "hr_role",
      PROGRAM => "program_role",
      WORKORDER => "workorder_role"
    }
    User.find(:all, :conditions => ["? >= ? and status != ?", role_names[role], level, User.STATUS[:inactive]])
  end
  
  def self.all
    User.find(:all, :order => 'first_name asc, last_name asc')
  end

  def short_name
    "#{first_name} #{last_name[0].chr}"
  end
  
  def full_name
    "#{first_name} #{last_name}"
  end

  def self.authenticate(email, password)
    user = User.find(:first, :conditions => ["email = ?", email])
    logger.info("user: #{user.inspect.to_s}")
    if user.nil? then return nil end
    unless (User.sha1(user.salt, password) == user.crypted_password)
      logger.info("bad password")
      return nil
    end
    logger.info("good password")
    return user
  end

private
  def self.sha1(salt, pass)
      Digest::SHA1.hexdigest("---#{salt}--#{pass}--")
  end

end
