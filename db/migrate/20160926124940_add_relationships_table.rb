class AddRelationshipsTable < ActiveRecord::Migration

  def change
    remove_index :managements, :team_member_id

    rename_table :managements, :relationships

    add_column :relationships, :state, :string
    add_column :relationships, :kind, :string

    rename_column :relationships, :team_member_id, :target_id

    if ActiveRecord::Base.connection.table_exists? 'relationships'
      Relationship.all.each do |relation|
        relation.update(kind: 'is_manager_of')
        relation.create_inverse unless relation.has_inverse?
      end

      Relationship.all.each do |relation|
        (relation.user.nil? || relation.target.nil?) ? relation.delete : nil
      end
    end

    reversible do |dir|
      dir.up do
        unless index_exists?(:relationships, [:user_id, :target_id])
          add_index :relationships, [:user_id, :target_id]
        end
      end
    end

  end

end
