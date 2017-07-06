class AddContactfieldsToUsers < ActiveRecord::Migration
  def change
  	add_column :users, :agil, :string
  	add_column :users, :linkedin, :string
  	add_column :users, :twitter, :string
  end
end
