require 'chronic'

class SirsController < ApplicationController
  layout 'rdcc'
  
  before_filter :check_access
  
  auto_complete_for :sir, :customer_name
  auto_complete_for :sir, :user_name
  auto_complete_for :sir, :user_name2
  auto_complete_for :sir, :teammate_name
  
  # GET /sirs
  # GET /sirs.xml
  def index
    @sirs = Sir.all
    @has_edit_access = has_access? Role.find_by_name("program_manager")

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @sirs }
    end
  end

  # GET /sirs/1
  # GET /sirs/1.xml
  def show
    @sir = Sir.find(params[:id])
    @has_edit_access = has_access? Role.find_by_name("program_manager")

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @sir }
      format.pdf {
        filename = ""
        if @sir.incident_datetime
          filename += @sir.incident_datetime.strftime('%Y%m%d')
        end
        if @sir.customers
          filename += @sir.customers.collect{|x| "_" + x.first_name[0].chr + x.last_name}.to_sentence
        end
        prawnto :filename => "sir_#{filename}.pdf".downcase
      }
    end
  end

  def revert_to_draft
    @sir = Sir.find(params[:id])
    @sir.signatures.clear
    redirect_to sir_path(@sir)
  end

  def show_sign
    @sir = Sir.find(params[:sir_id])
    @signature = Signature.new
    @signature.sir = @sir
    @signature.user_id = session[:user_id]
    
    low_role = Role.find_by_name("program_staff")
    high_role = Role.find_by_name("program_manager")
    user = User.find(session[:user_id])
    for role in user.roles
      if role == high_role
        @role_id = high_role.id
        break
      elsif role == low_role
        @role_id = low_role.id  # keep going in case we find a better role
      end
    end
    
    render :partial => "sign_sir_form"
  end
  
  def sign_sir
    @signature = Signature.new(params[:signature])
    if @signature.save
      flash[:notice] = "Successfully signed SIR"
    else
      flash[:error] = @signature.errors.on_base.each{|attr, msg| "#{msg}<br />"}
    end
    redirect_to @signature.sir
  end

  # GET /sirs/new
  # GET /sirs/new.xml
  def new
    @sir = Sir.new
    render :edit
    # @header = "New SIR"
    # @submit_button = "Create"
    # render :edit
  end

  # GET /sirs/1/edit
  def edit
    @sir = Sir.find(params[:id])
    if @sir.locked or (@sir.signed and !has_access? Role.find_by_name("program_manager"))
      flash[:error] = "Can't edit SIR after it's signed and locked."
      redirect_to @sir
    end
    
    @header = "Editing SIR"
    @submit_button = "Update"
  end
  
  def add_user
    add_person("user")
  end
  
  def add_customer
    add_person("customer")
  end
  
  def add_person(person_table)
    @sir = Sir.find(params[:id])
    if person_table == "customer"
      person = Customer.find_by_full_name(params[:sir][:name])
    elsif person_table == "user"
      person = User.find_by_full_name(params[:sir][:name])
    end
    unless person.errors.on_base.nil?
      flash.now[:error] = person.errors.on_base.each{|attr, msg| "#{msg}<br />"}
    else
      existing = false
      for existingPerson in @sir.send("#{person_table}s")
        if person.full_name == existingPerson.full_name
          existing = true
        end
      end
      if existing
        flash.now[:error] = "#{params[:sir][:name]} is already associated with this SIR"
      else
        if person_table == "customer"
          @sir.customers << person
        elsif person_table == "user"
          @sir.users << person
        end
      end
    end
      
    render :partial => "editable_person_list", :object => @sir.send("#{person_table}s"), :locals => {:person_table => person_table}
  end

  def remove_customer
    remove_person("customer")
  end
  
  def remove_user
    remove_person("user")
  end
  
  def remove_person(person_table)
    @sir = Sir.find(params[:id])
    if person_table == "customer"
      person = Customer.find(params[:person_id])
    elsif person_table == "user"
      person = User.find(params[:person_id])
    end
    
    unless person.errors.on_base.nil?
      flash.now[:error] = person.errors.on_base.each{|attr, msg| "#{msg}<br />"}
    else
      @sir.send("#{person_table}s").delete(person)
    end
      
    render :partial => "editable_person_list", :object => @sir.send("#{person_table}s"), :locals => {:person_table => person_table}
  end

  # POST /sirs
  # POST /sirs.xml
  def create
    parse_date_fields
    @sir = Sir.new(params[:sir])

    respond_to do |format|
      if @sir.save
        flash[:notice] = 'Sir was successfully created.'
        format.html { redirect_to(@sir) }
        format.xml  { render :xml => @sir, :status => :created, :location => @sir }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @sir.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /sirs/1
  # PUT /sirs/1.xml
  def update
    parse_date_fields
    @sir = Sir.find(params[:id])

    if @sir.update_attributes(params[:sir])
      flash[:notice] = 'Sir was successfully updated.'
      redirect_to edit_sir_path(@sir)
    else
      render :action => "edit"
    end
  end

  # DELETE /sirs/1
  # DELETE /sirs/1.xml
  def destroy
    @sir = Sir.find(params[:id])
    @sir.destroy unless @sir.signed

    respond_to do |format|
      format.html { redirect_to(sirs_url) }
      format.xml  { head :ok }
    end
  end
  
private
  
  def check_access
    unless has_access? Role.find_by_name("program_staff")
      flash[:error] = "Access denied"
      redirect_to :controller => :dashboard
    end
  end
  
  def parse_date_fields
    params[:sir][:incident_datetime] = Chronic.parse(params[:sir][:incident_datetime])
    params[:sir][:der_time_in] = Chronic.parse(params[:sir][:der_time_in])
    params[:sir][:der_time_door] = Chronic.parse(params[:sir][:der_time_door])
    params[:sir][:der_time_out] = Chronic.parse(params[:sir][:der_time_out])
  end
end
