class AddFirstLastNamesToUsers < ActiveRecord::Migration

  def up
    add_column :users, :first_name, :string
    add_column :users, :last_name, :string
    migrate_to_first_and_last_names
    remove_column :users, :name
  end

  def down
    add_column :users, :name, :string
    migrate_to_names
    remove_column :users, :first_name
    remove_column :users, :last_name
  end

  def migrate_to_first_and_last_names
    User.all.each do |user|
      name_parts = user.read_attribute(:name).split(" ")
      first_name = name_parts.delete(name_parts.first)
      last_name = name_parts.join(" ")
      user.update_attributes(first_name: first_name, last_name: last_name)
    end
  end

  def migrate_to_names
    User.all.each do |user|
      user.update_attribute(:name, "#{user.first_name} #{user.last_name}")
    end
  end
end
