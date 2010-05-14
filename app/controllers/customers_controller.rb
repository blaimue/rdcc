require 'chronic'

class CustomersController < ApplicationController
  layout 'rdcc'
  
  before_filter :check_access, :except => [:index]
    
  # GET /customers
  # GET /customers.xml
  def index
    find_options = {:order => "last_name asc, first_name asc"}
    @customers = Customer.all(find_options)

    unless (params[:show] == "all")
      @customers.reject!{|x| !x.released_on.nil? and x.released_on < Date.today}
    end

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @customers }
    end
  end

  # GET /customers/1
  # GET /customers/1.xml
  def show
    @customer = Customer.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @customer }
      format.pdf {
        filename = ""
        if @customers
          filename += (@customer.first_name[0].chr + @customer.last_name)
        end
        prawnto :filename => "sirs_#{filename}.pdf".downcase
      }
    end
  end

  # GET /customers/new
  # GET /customers/new.xml
  def new
    @customer = Customer.new

    render :edit
  end

  # GET /customers/1/edit
  def edit
    @customer = Customer.find(params[:id])
  end

  # POST /customers
  # POST /customers.xml
  def create
    params[:customer][:admitted_on] = Chronic.parse(params[:customer][:admitted_on])
    params[:customer][:released_on] = Chronic.parse(params[:customer][:released_on])
    unless params[:customer][:program].nil?
      params[:customer][:program] = Program.find(params[:customer][:program])
    end
    @customer = Customer.new(params[:customer])

    respond_to do |format|
      if @customer.save
        flash[:notice] = 'Customer was successfully created.'
        format.html { redirect_to new_customer_path }
        format.xml  { render :xml => @customer, :status => :created, :location => @customer }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @customer.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /customers/1
  # PUT /customers/1.xml
  def update
    params[:customer][:admitted_on] = Chronic.parse(params[:customer][:admitted_on])
    params[:customer][:released_on] = Chronic.parse(params[:customer][:released_on])
    @customer = Customer.find(params[:id])
    unless params[:customer][:program].nil?
      params[:customer][:program] = Program.find(params[:customer][:program])
    end

    respond_to do |format|
      if @customer.update_attributes(params[:customer])
        flash[:notice] = 'Customer was successfully updated.'
        format.html { redirect_to(@customer) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @customer.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /customers/1
  # DELETE /customers/1.xml
  def destroy
    @customer = Customer.find(params[:id])
    @customer.destroy

    respond_to do |format|
      format.html { redirect_to(customers_url) }
      format.xml  { head :ok }
    end
  end
  
private

  def check_access
    unless has_access? Role.find_by_name("hr")
      flash[:error] = "Access denied"
      redirect_to :controller => :dashboard
    end
  end
  
end
