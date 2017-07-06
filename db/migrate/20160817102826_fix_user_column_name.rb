class FixUserColumnName < ActiveRecord::Migration
  def up
  	# Rename Title column
  	rename_column :users, :title, :job_title

  	# Merge first name and last name
  	add_column :users, :name, :string

    User.all.each do |person|
      person.update_attributes! :name => person.first_name + " " + person.last_name
    end

    remove_column :users, :first_name
    remove_column :users, :last_name
  end

  def down
  	rename_column :users, :job_title, :title

    add_column :users, :first_name, :string
    add_column :users, :last_name, :string

    User.all.each do |person|
      person.update_attributes! :first_name => person.name.match(/\w+/)[0]
      person.update_attributes! :last_name => person.name.match(/\w+/)[1]
    end

    remove_column :users, :name
  end
end
