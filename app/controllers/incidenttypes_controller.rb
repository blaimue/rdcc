class IncidenttypesController < ApplicationController
  layout 'rdcc'
  
  # GET /incidenttypes
  # GET /incidenttypes.xml
  def index
    @incidenttypes = Incidenttype.find(:all, :order => 'name asc')

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @incidenttypes }
    end
  end

  # GET /incidenttypes/1
  # GET /incidenttypes/1.xml
  def show
    @incidenttype = Incidenttype.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @incidenttype }
    end
  end

  # GET /incidenttypes/new
  # GET /incidenttypes/new.xml
  def new
    @incidenttype = Incidenttype.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @incidenttype }
    end
  end

  # GET /incidenttypes/1/edit
  def edit
    @incidenttype = Incidenttype.find(params[:id])
  end

  # POST /incidenttypes
  # POST /incidenttypes.xml
  def create
    @incidenttype = Incidenttype.new(params[:incidenttype])

    respond_to do |format|
      if @incidenttype.save
        flash[:notice] = 'Incidenttype was successfully created.'
        format.html { redirect_to(@incidenttype) }
        format.xml  { render :xml => @incidenttype, :status => :created, :location => @incidenttype }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @incidenttype.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /incidenttypes/1
  # PUT /incidenttypes/1.xml
  def update
    @incidenttype = Incidenttype.find(params[:id])

    respond_to do |format|
      if @incidenttype.update_attributes(params[:incidenttype])
        flash[:notice] = 'Incidenttype was successfully updated.'
        format.html { redirect_to(@incidenttype) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @incidenttype.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /incidenttypes/1
  # DELETE /incidenttypes/1.xml
  def destroy
    @incidenttype = Incidenttype.find(params[:id])
    @incidenttype.destroy

    respond_to do |format|
      format.html { redirect_to(incidenttypes_url) }
      format.xml  { head :ok }
    end
  end
end
