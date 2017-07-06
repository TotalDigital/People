class RenameIggToInternalId < ActiveRecord::Migration
  def change
    rename_column :users, :igg, :internal_id
  end
end
