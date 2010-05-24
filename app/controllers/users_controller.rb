class UsersController < ApplicationController
  layout 'rdcc'
  
  skip_before_filter :authenticate, :only => [:create, :new, :forgot_password, :reset_password]
  before_filter :check_access, :except => [:create, :new, :forgot_password, :reset_password]
  
  def check_access
    unless has_access? Role.find_by_name("hr")
      flash[:error] = "Access denied"
      redirect_to :controller => :dashboard
    end
  end
  
  # GET /users
  # GET /users.xml
  def index
    find_options = {:order => "last_name asc, first_name asc"}
    unless (params[:show] == "all")
      find_options[:conditions] = ["status != ?", User.STATUS[:inactive]]
    end
    @users = User.all(find_options)

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @users }
    end
  end

  # GET /users/1
  # GET /users/1.xml
  def show
    @user = User.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @user }
    end
  end

  # GET /users/new
  # GET /users/new.xml
  def new
    @user = User.new
    @noReminders = true

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @user }
    end
  end

  # GET /users/1/edit
  def edit
    @user = User.find(params[:id])
  end

  # POST /users
  # POST /users.xml
  def create
    @user = User.new(params[:user])

    respond_to do |format|
      if @user.save
        flash[:notice] = 'Your account was successfully created.'
        hr_managers = Role.find_by_name("hr_manager")
        unless hr_managers.nil?
          for recipient in hr_managers.users
            UserMailer.deliver_new(recipient.email, @user)
          end
        end
        format.html { redirect_to :controller => :dashboard }
        format.xml  { render :xml => @user, :status => :created, :location => @user }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @user.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /users/1
  # PUT /users/1.xml
  def update
    @user = User.find(params[:id])

    respond_to do |format|
      if @user.update_attributes(params[:user])
        flash[:notice] = 'User was successfully updated.'
        format.html { redirect_to(@user) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @user.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /users/1
  # DELETE /users/1.xml
  def destroy
    if session[:user_id] == params[:id]
      flash[:error] = "Can't delete yourself"
      redirect_to :action => :index
    else
      @user = User.find(params[:id])
      @user.destroy
    end

    respond_to do |format|
      format.html { redirect_to(users_url) }
      format.xml  { head :ok }
    end
  end
  
  def forgot_password
    if request.post?
      user = User.find_by_email(params[:email])
      if user.nil?
        flash.now[:error] = "Sorry, no user with that email exists."
      else
        user.remember_token = new_token
        user.remember_token_expires_at = 30.days.to_i.from_now
        if user.save
          email = UserMailer.create_remember_token(user)
          email.set_content_type("text/html")
          UserMailer.deliver(email)
          flash.now[:notice] = "A link to reset your password has been emailed to you."
        else
          flash.now[:error] = "Sorry, something went wrong."
        end
      end
    end
  end
  
  def reset_password
    @token = params[:token]
    if request.post?
      user = User.find_by_email(params[:email])
      if user.remember_token == params[:token] and user.remember_token_expires_at > Time.now
        user.password = params[:password]
        user.password_confirmation = params[:password_confirmation]
        user.remember_token = nil
        user.remember_token_expires_at = nil
        if user.save
          flash[:notice] = "Password saved, please log in."
          redirect_to login_path
        end
      end
      flash.now[:error] = "Unable to update password"
    end
  end
  
  private
  def new_token
    possible = "abcdefghijklmnopqrstuvwxyz0123456789"
    token = ""
    0.upto(10) do |i|
      token += possible[(rand * 36).to_i].chr
    end
    return token
  end
  
end
