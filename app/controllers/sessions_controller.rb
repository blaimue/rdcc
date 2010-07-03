# This controller handles the login/logout function of the site.  
class SessionsController < ApplicationController
  layout 'rdcc'
  
  skip_before_filter :authenticate
  
  # render new.rhtml
  def new
    @noReminders = true
  end

  def create
    session[:user_id] = nil
    user = User.authenticate(params[:email], params[:password])
    if user.nil? or user.kind_of? String
      flash[:error] = "Could not find user with that email and password"
      redirect_to :action => 'new'
    else
      # Protects against session fixation attacks, causes request forgery
      # protection if user resubmits an earlier form using back
      # button. Uncomment if you understand the tradeoffs.
      # reset_session
      session[:user_id] = user.id
      session[:user_email] = user.email
      session[:developer] = DEVELOPER_EMAILS.include? user.email
      
      flash[:notice] = "Logged in successfully"
      redirect_to :controller => :dashboard
    end
  end

  def destroy
    session[:user_id] = nil
    session[:user_email] = nil
    flash[:notice] = "You have been logged out."
    redirect_to :action => 'new'
  end

end
