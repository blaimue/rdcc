class UsersController < ApplicationController
  layout 'rdcc'
  
  skip_before_filter :authenticate, :only => [:create, :new]
  before_filter :check_access, :except => [:create, :new, :index]
  
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
      format.js {
        @users = User.find(:all, :conditions => ['first_name LIKE ? or last_name LIKE ?', "%#{params[:search]}%", "%#{params[:search]}%"])
      }
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
end
