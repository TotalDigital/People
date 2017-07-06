class CreateLanguages < ActiveRecord::Migration
  def change
    create_table :languages do |t|
      t.string :name

      t.timestamps null: false
    end

    create_table :users_languages, ud: false do |t|
    	t.belongs_to :user, index: true
    	t.belongs_to :languages, index: true
    end
  end
end
