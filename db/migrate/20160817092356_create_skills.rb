class CreateSkills < ActiveRecord::Migration
  def change
    create_table :skills do |t|
      t.string :name

      t.timestamps null: false
    end

    create_table :users_skills, ud: false do |t|
    	t.belongs_to :user, index: true
    	t.belongs_to :skill, index: true
    end
  end
end
