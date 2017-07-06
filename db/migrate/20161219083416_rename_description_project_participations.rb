class RenameDescriptionProjectParticipations < ActiveRecord::Migration
  def change
    rename_column :project_participations, :description, :role_description
  end
end
