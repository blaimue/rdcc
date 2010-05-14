class TeammatesController < ApplicationController
  layout 'rdcc'
  
  before_filter :check_access
    
  def check_access
    unless has_access? Role.find_by_name("hr")
      flash[:error] = "Access denied"
      redirect_to :controller => :dashboard
    end
  end
  
  # GET /teammates
  # GET /teammates.xml
  def index
    @teammates = Teammate.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @teammates }
    end
  end

  # GET /teammates/1
  # GET /teammates/1.xml
  def show
    @teammate = Teammate.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @teammate }
    end
  end

  # GET /teammates/new
  # GET /teammates/new.xml
  def new
    @teammate = Teammate.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @teammate }
    end
  end

  # GET /teammates/1/edit
  def edit
    @teammate = Teammate.find(params[:id])
  end

  # POST /teammates
  # POST /teammates.xml
  def create
    @teammate = Teammate.new(params[:teammate])

    respond_to do |format|
      if @teammate.save
        flash[:notice] = 'Teammate was successfully created.'
        format.html { redirect_to new_teammate_path }
        format.xml  { render :xml => @teammate, :status => :created, :location => @teammate }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @teammate.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /teammates/1
  # PUT /teammates/1.xml
  def update
    @teammate = Teammate.find(params[:id])

    respond_to do |format|
      if @teammate.update_attributes(params[:teammate])
        flash[:notice] = 'Teammate was successfully updated.'
        format.html { redirect_to(@teammate) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @teammate.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /teammates/1
  # DELETE /teammates/1.xml
  def destroy
    @teammate = Teammate.find(params[:id])
    @teammate.destroy

    respond_to do |format|
      format.html { redirect_to(teammates_url) }
      format.xml  { head :ok }
    end
  end
end
