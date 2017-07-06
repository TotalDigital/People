class AddLinkedinUidToUsers < ActiveRecord::Migration
  def change
    add_column :users, :linkedin_uid, :string
    add_column :users, :linkedin_token, :string
    add_column :users, :linkedin_token_expires_at, :datetime
  end
end
