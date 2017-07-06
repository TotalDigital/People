class AddIggToUsers < ActiveRecord::Migration

  def up
    add_column :users, :igg, :string
    fill_up_igg_column
    remove_column :users, :agil
    remove_column :users, :lync
  end

  def down
    add_column :users, :agil, :string
    add_column :users, :lync, :string
    fill_up_agil_column
    remove_column :users, :igg, :string
  end

  def fill_up_igg_column
    User.all.each do |user|
      unless user.agil.blank?
        user.igg = user.agil.match("\igg=(.*)").try(:[], 1)
        user.save(validate: false)
      end
    end
  end

  def fill_up_agil_column
    User.all.each do |user|
      unless user.igg.blank?
        user.agil = "http://agil.corp.local/agil/personne.view?actionaig=find&igg=#{user.igg}"
        user.save(validate: false)
      end
    end
  end
end
