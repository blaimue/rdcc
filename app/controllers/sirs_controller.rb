require 'chronic'

class SirsController < ApplicationController
  layout 'rdcc'
  
  parameterized_before_filter :check_access, [[PROGRAM, STAFF]]
  
  # GET /sirs
  # GET /sirs.xml
  def index
    @has_edit_access = has_access? PROGRAM, MANAGER
    @total_count = Sir.count
    page_number = params[:page_number].to_i
    @page_number = page_number
    if page_number == 0 and params[:page_number] == 'all'
      page_number = 'all'
    end
    @sirs = Sir.page(page_number)

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @sirs }
    end
  end

  # GET /sirs/1
  # GET /sirs/1.xml
  def show
    @sir = Sir.find(params[:id])
    @has_edit_access = has_access? PROGRAM, MANAGER

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
    user = User.find(session[:user_id])
    @signature.program_role = user.program_role
    
    render :partial => "sign_sir_form"
  end
  
  def sign_sir
    @signature = Signature.new(params[:signature])
    if @signature.save
      flash[:notice] = "Successfully signed SIR"
      if @signature.program_role == MANAGER
        redirect_to sir_notifications_path(@signature.sir)
        return
      else
        recipients = User.all
        if @signature.sir.program.nil?
          recipients = User.find_by_role(PROGRAM, MANAGER)
        else
          recipients.reject!{|user| !user.preferred_sir_emails.split(",").include? @signature.sir.program.id.to_s}
        end
        logger.info("Sending SIR notifications to #{recipients.collect{|user| user.email}.to_sentence}")
        for recipient in recipients
          SirMailer.deliver_new(@signature.sir, recipient.email)
        end
      end
    else
      flash[:error] = @signature.errors.on_base.each{|attr, msg| "#{msg}<br />"}
    end
    redirect_to @signature.sir
  end
  
  def notifications
    @sir = Sir.find(params[:id])
  end
  
  def notified
    sir = Sir.find(params[:id])
    teammate = Teammate.find(params[:teammate_id])
    sir.notifications.create({:teammate_id => teammate.id, :user_id => session[:user_id], :notified_by => session[:user_id], :sir_id => sir.id})
    redirect_to sir_notifications_path(sir)
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
    if @sir.locked or (@sir.signed and !has_access? PROGRAM, MANAGER)
      flash[:error] = "Can't edit SIR after it's signed and locked."
      redirect_to @sir
    end
    
    id = sprintf("%04d", @sir.id)
    @header = "Editing SIR ##{id}"
    @submit_button = "Update"
  end
  
  # POST /sirs
  # POST /sirs.xml
  def create
    @sir = Sir.new(params[:sir])

    if @sir.save
      flash[:notice] = 'Sir was successfully created.'
      redirect_to @sir
    else
      render :action => :edit
    end
  end

  # PUT /sirs/1
  # PUT /sirs/1.xml
  def update
    @sir = Sir.find(params[:id])
    
    if @sir.update_attributes(params[:sir])
      flash[:notice] = 'Sir was successfully updated.'
      redirect_to edit_sir_path(@sir)
    else
      render :action => "edit"
    end
  end

  def followup
    sir = Sir.find(params[:id])
    unless sir.nil? or params[:followup].nil?
      followup = sir.followups.create(params[:followup])
      followup.user_id = session[:user_id]
      followup.save
    end
    redirect_to sir
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
  
end
