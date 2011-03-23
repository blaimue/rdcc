class DashboardController < ApplicationController
  layout 'rdcc'
  
  def index
    if has_access? WORKORDER, MANAGER
      workorder_staff
      workorder_manager
      render :action => :workorder_manager
    elsif has_access? WORKORDER, STAFF
      workorder_staff
      render :action => :workorder_staff
    elsif has_access? PROGRAM, MANAGER
      @has_edit_access = true
      program_staff # managers see everything staff see, with extra
      program_manager
      user_workorders
      render :action => :program_manager
    elsif has_access? PROGRAM, STAFF
      program_staff
      user_workorders
      render :action => :program_staff
    elsif has_access? HR, STAFF
      redirect_to :action => :hr
    end
  end
  
  def user_workorders
    user = User.find(session[:user_id])
    workorders = user.workorders
    @user_workorders = []
    workorders.each do |workorder|
      if workorder.status == Workorder.STATUS[:pending] or workorder.status == Workorder.STATUS[:in_progress]
        @user_workorders.push(workorder)
      end
    end
  end

  def program_staff
    @draft_sirs = Sir.find(:all, :order => "id desc").delete_if{|x| x.signed}
  end

  def program_manager
    @signed_sirs = Sir.find(:all, :order => "id desc").delete_if{|x| x.locked || !x.signed}
  end

  def workorder_staff
    @in_progress_workorders = Workorder.find(:all, :conditions => ["status = ?", Workorder.STATUS[:in_progress]], :order => 'priority desc')
  end

  def workorder_manager
    @pending_workorders = Workorder.find(:all, :conditions => ["status = ?", Workorder.STATUS[:pending]], :order => 'priority asc')
  end

  def hr
    redirect_to :controller => :users
  end
end
