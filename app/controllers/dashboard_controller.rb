class DashboardController < ApplicationController
  layout 'rdcc'
  
  def index
    if has_access? WORKORDER, MANAGER
      render :action => :workorder_manager
    elsif has_access? WORKORDER, STAFF
      render :action => :workorder_staff
    elsif has_access? PROGRAM, MANAGER
      @has_edit_access = true
      program_staff # managers see everything staff see, with extra
      program_manager
      render :action => :program_manager
    elsif has_access? PROGRAM, STAFF
      program_staff
      render :action => :program_staff
    elsif has_access? HR, STAFF
      redirect_to :action => :hr
    end
  end

  def program_staff
    @draft_sirs = Sir.find(:all).delete_if{|x| x.signed}
  end

  def program_manager
    @signed_sirs = Sir.find(:all).delete_if{|x| x.locked || !x.signed}
  end

  def workorder_staff
    @workorders = Workorder.find(:all)
  end

  def workorder_manager
    @workorders = Workorder.find(:all)
  end

  def hr
    redirect_to :controller => :users
  end
end
