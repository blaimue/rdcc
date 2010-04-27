class InterventionsController < ApplicationController
  layout 'rdcc'
  
  # GET /interventions
  # GET /interventions.xml
  def index
    @interventions = Intervention.find(:all, :order => 'name asc')

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @interventions }
    end
  end

  # GET /interventions/1
  # GET /interventions/1.xml
  def show
    @intervention = Intervention.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @intervention }
    end
  end

  # GET /interventions/new
  # GET /interventions/new.xml
  def new
    @intervention = Intervention.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @intervention }
    end
  end

  # GET /interventions/1/edit
  def edit
    @intervention = Intervention.find(params[:id])
  end

  # POST /interventions
  # POST /interventions.xml
  def create
    @intervention = Intervention.new(params[:intervention])

    respond_to do |format|
      if @intervention.save
        flash[:notice] = 'Intervention was successfully created.'
        format.html { redirect_to(@intervention) }
        format.xml  { render :xml => @intervention, :status => :created, :location => @intervention }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @intervention.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /interventions/1
  # PUT /interventions/1.xml
  def update
    @intervention = Intervention.find(params[:id])

    respond_to do |format|
      if @intervention.update_attributes(params[:intervention])
        flash[:notice] = 'Intervention was successfully updated.'
        format.html { redirect_to(@intervention) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @intervention.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /interventions/1
  # DELETE /interventions/1.xml
  def destroy
    @intervention = Intervention.find(params[:id])
    @intervention.destroy

    respond_to do |format|
      format.html { redirect_to(interventions_url) }
      format.xml  { head :ok }
    end
  end
end
