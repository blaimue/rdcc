class WorkordersController < ApplicationController
  layout 'rdcc'
  
  # GET /workorders
  # GET /workorders.xml
  def index
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

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @workorder }
    end
  end

  # GET /workorders/1/edit
  def edit
    @workorder = Workorder.find(params[:id])
  end

  # POST /workorders
  # POST /workorders.xml
  def create
    params[:workorder][:status] = Workorder.STATUS[:pending]
    @workorder = Workorder.new(params[:workorder])

    respond_to do |format|
      if @workorder.save
        flash[:notice] = 'Workorder was successfully created.'
        format.html { redirect_to(@workorder) }
        format.xml  { render :xml => @workorder, :status => :created, :location => @workorder }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @workorder.errors, :status => :unprocessable_entity }
      end
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
