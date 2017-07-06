class CreateJobs < ActiveRecord::Migration
  def change
    create_table :jobs do |t|
      t.string :title
      t.date :start_date
      t.date :end_date
      t.text :description
      t.string :location
      t.belongs_to :user, index: true

      t.timestamps null: false
    end
  end
end
