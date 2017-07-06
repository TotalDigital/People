class AddRoleUsers < ActiveRecord::Migration
  def change
    add_column :users, :role, :string, default: "basic"
  end
end
