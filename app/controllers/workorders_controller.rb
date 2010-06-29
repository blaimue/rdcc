class WorkordersController < ApplicationController
  layout 'rdcc'
  
  parameterized_before_filter :check_access, [[WORKORDER, STAFF]], :except => [:index, :new, :create, :confirmed]
  parameterized_before_filter :check_access, [[WORKORDER, MANAGER]], :only => [:edit, :update, :approve, :intake]
  
  # GET /workorders
  # GET /workorders.xml
  def index
    unless has_access? WORKORDER, STAFF
      redirect_to :action => :new
      return
    end
    @workorders = Workorder.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @workorders }
    end
  end

  # GET /workorders/1
  # GET /workorders/1.xml
  def show
    @workorder = Workorder.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @workorder }
    end
  end

  # GET /workorders/new
  # GET /workorders/new.xml
  def new
    @workorder = Workorder.new
    unless params[:sir_id].nil?
      sir = Sir.find(params[:sir_id])
      @sir_id = sir.id
      if sir.program
        @workorder.program = sir.program
      end
    end

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @workorder }
    end
  end

  # GET /workorders/1/edit
  def edit
    @workorder = Workorder.find(params[:id])
  end
  def complete
    @workorder = Workorder.find(params[:id])
    if @workorder.complete?
      redirect_to workorders_path
    end
    
    if request.put?
      if @workorder.update_attributes(params[:workorder])
        flash[:notice] = "Workorder complete"
        redirect_to workorders_path
      else
        flash[:error] = "There was a problem, please try again"
        redirect_to complete_workorder_path(@workorder)
      end
    end
  end
  def estimate
    @workorder = Workorder.find(params[:id])
  end

  def confirmed
    @workorder = Workorder.find(params[:id])
  end
  
  def intake
    @workorder = Workorder.find(params[:id])
  end
  
  def approve
    @workorder = Workorder.find(params[:id])
    if request.put?
      if @workorder.update_attributes(params[:workorder])
        flash[:notice] = "Workorder approved"
        redirect_to workorders_path
      else
        flash[:error] = "There was a problem, please try again"
        redirect_to process_workorder_path(@workorder)
      end
    end
  end
  
  # POST /workorders
  # POST /workorders.xml
  def create
    params[:workorder][:status] = Workorder.STATUS[:pending]
    @workorder = Workorder.new(params[:workorder])

    if @workorder.save
      flash[:notice] = 'Workorder was successfully created.'
      redirect_to confirmed_workorder_path(@workorder)
    else
      render :action => "new"
    end
  end

  # PUT /workorders/1
  # PUT /workorders/1.xml
  def update
    @workorder = Workorder.find(params[:id])

    respond_to do |format|
      if @workorder.update_attributes(params[:workorder])
        flash[:notice] = 'Workorder was successfully updated.'
        format.html { redirect_to(@workorder) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @workorder.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /workorders/1
  # DELETE /workorders/1.xml
  def destroy
    @workorder = Workorder.find(params[:id])
    @workorder.destroy

    respond_to do |format|
      format.html { redirect_to(workorders_url) }
      format.xml  { head :ok }
    end
  end
end
