class AddBranchIdToUsers < ActiveRecord::Migration
  def change
    add_reference :users, :branch, index: true
  end
end
