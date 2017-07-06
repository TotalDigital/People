class AddExternalToUsers < ActiveRecord::Migration
  def up
    add_column :users, :external, :boolean
    set_users_external
  end

  def down
    remove_column :users, :external, :boolean
  end

  def set_users_external
    User.all.each do |user|
      user.update_attribute(:external, user.is_external?)
    end
  end
end
