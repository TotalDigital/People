class RemoveDescriptionFromProjects < ActiveRecord::Migration
  def change
    remove_column :projects, :description, :text
  end
end
