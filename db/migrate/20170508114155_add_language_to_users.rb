class AddLanguageToUsers < ActiveRecord::Migration
  def change
    add_column :users, :language, :string, default: "en"
    User.all.each do |user|
      user.update_columns(language: "en")
    end
  end
end
