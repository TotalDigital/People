class AddProfilePictureToUsers < ActiveRecord::Migration
  def up
    add_attachment :users, :profile_picture
  end

  def down
    remove_attachment :users, :profile_picture
  end
end
