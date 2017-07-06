class DropTableUserAdmins < ActiveRecord::Migration

  def up
    migrate_admins
    drop_table :admin_users
  end

  def migrate_admins
    AdminUser.all.each do |admin_user|
      admin = User.create(
        email: admin_user.email,
        role: "admin",
        password: "changeme",
        password_confirmation: "changeme"
      )
      admin.send_reset_password_instructions if Rails.env.production?
    end
  end

  def down
    create_table(:admin_users) do |t|
      t.string :email,              null: false, default: ""
      t.string :encrypted_password, null: false, default: ""
      t.string   :reset_password_token
      t.datetime :reset_password_sent_at
      t.datetime :remember_created_at
      t.integer  :sign_in_count, default: 0, null: false
      t.datetime :current_sign_in_at
      t.datetime :last_sign_in_at
      t.string   :current_sign_in_ip
      t.string   :last_sign_in_ip
      t.timestamps
    end
    add_index :admin_users, :email,                unique: true
    add_index :admin_users, :reset_password_token, unique: true
    create_admins
  end

  def create_admins
    User.where(role: "admin").each do |user|
      AdminUser.create(email: user.email, password: "changeme", password_confirmation: "changeme")
      user.destroy
    end
  end
end

class AdminUser < ActiveRecord::Base
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable,
         :validatable, :omniauthable, password_length: 4..128
end
