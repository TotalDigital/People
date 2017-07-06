class DropGhostUsersTable < ActiveRecord::Migration
  def up
    drop_table :ghost_users
  end

  def down
    create_table :ghost_users do |t|
      t.string :first_name
      t.string :last_name
      t.string :email
      t.timestamps null: false
    end
    add_attachment :ghost_users, :profile_picture
  end
end
