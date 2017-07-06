class AddIndexToManagement < ActiveRecord::Migration
  def change
    add_index :managements,  [:team_member_id], unique: true
  end
end
