# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  
  prawnto :prawn => {
            :left_margin => 24,
            :right_margin => 24,
            :top_margin => 48,
            :bottom_margin => 48}
            
  helper :all # include all helpers, all the time
  protect_from_forgery # See ActionController::RequestForgeryProtection for details

  # almost always want to auth... certain controllers/actions override this with skip_before_filter
  before_filter :authenticate
#  before_filter :find_messages

  # Scrub sensitive parameters from your log
  filter_parameter_logging :password, :password_confirmation

  def self.parameterized_before_filter(filter_name, *args)
      options = args.extract_options!

      self.before_filter(options) { |controller| controller.send(filter_name, *args) }
    end
    
  def find_messages
    @motds = Message.find(:all, :conditions => ["expiration > ?", Time.now.utc], :order => 'id desc')
  end

  def authenticate
    if session.nil? or session[:user_id].nil?
      flash[:error] = "Please log in"
      redirect_to :controller => :sessions, :action => :new
    else
      user = User.find(session[:user_id])
      if user.nil?
        flash[:error] = "Please log in"
        redirect_to :controller => :sessions, :action => :new
      elsif user.status == User.STATUS[:inactive]
        flash[:error] = "Your account has been deactivated, please contact HR to be reinstated"
        redirect_to :controller => :sessions, :action => :new
      end
    end
  end

  def check_access(pairs)
    for pair in pairs
      if has_access? pair[0], pair[1]
        return
      end
    end
    flash[:error] = "Access denied"
    redirect_to :controller => :dashboard
  end

  def has_access?(role, level)
    user = User.find(session[:user_id])
    case role
      when HR:
        return user.hr_role >= level
      when PROGRAM:
        return user.program_role >= level
      when WORKORDER:
        return user.workorder_role >= level
    end
    return false
  end
  
  protected
  def log_error(ex)
    logger.error(session[:user_email])
    super
  end

end
