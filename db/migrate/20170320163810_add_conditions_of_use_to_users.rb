class AddConditionsOfUseToUsers < ActiveRecord::Migration
  def change
    add_column :users, :conditions_of_use, :boolean
  end
end
