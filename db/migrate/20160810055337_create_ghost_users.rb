class CreateGhostUsers < ActiveRecord::Migration
  def change
    create_table :ghost_users do |t|
      t.string :first_name
      t.string :last_name
      t.string :email

      t.timestamps null: false
    end

    add_attachment :ghost_users, :profile_picture
  end
end
