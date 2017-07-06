class CreateDomainsTable < ActiveRecord::Migration
  def change
    create_table :domains do |t|
      t.string :name
      t.string :branch
    end
  end
end
