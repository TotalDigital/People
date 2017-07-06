class AddDescriptionToProductParticipation < ActiveRecord::Migration
  def change
    add_column :project_participations, :description, :text
    ProjectParticipation.find_each do |p|
      p.description = p.project.description
    end
  end
end
