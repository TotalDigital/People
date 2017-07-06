class CreateProjectParticipations < ActiveRecord::Migration
  def change
    create_table :project_participations do |t|
      t.date :start_date
      t.date :end_date
      t.belongs_to :user, index: true
      t.belongs_to :project, index: true

      t.timestamps null: false
    end
  end
end
