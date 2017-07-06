class AddFieldsToUsers < ActiveRecord::Migration
  def change
    add_column :users , :title, :string
    add_column :users , :phone, :string
    add_column :users , :office_address, :string
    add_column :users , :lync, :string
    add_column :users , :wat_link, :string
    add_column :users , :entity, :string
  end
end
