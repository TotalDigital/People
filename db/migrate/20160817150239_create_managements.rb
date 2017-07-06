class CreateManagements < ActiveRecord::Migration
  def change
    create_table :managements do |t|
      t.integer :user_id
      t.integer :team_member_id

      t.timestamps null: false
    end
  end
end
