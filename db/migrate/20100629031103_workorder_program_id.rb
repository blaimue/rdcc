class WorkorderProgramId < ActiveRecord::Migration
  def self.up
    rename_column :workorders, :program, :program_id
  end

  def self.down
  end
end
