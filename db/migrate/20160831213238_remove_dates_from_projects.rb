class RemoveDatesFromProjects < ActiveRecord::Migration
  def change
    remove_column :projects, :start_date
    remove_column :projects, :end_date
  end
end
