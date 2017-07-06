class ChangeLanguagesTable < ActiveRecord::Migration
  def change
  	rename_column :users_languages, :languages_id, :language_id
  end
end
