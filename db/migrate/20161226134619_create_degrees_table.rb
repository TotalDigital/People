class CreateDegreesTable < ActiveRecord::Migration
  def change
    create_table :degrees do |t|
      t.string :title
      t.string :institution
      t.integer :graduation_year
      t.belongs_to :user, index: true
      t.timestamps null: false
    end
  end
end
