class AddBranchIdToDomains < ActiveRecord::Migration

  def up
    add_reference :domains, :branch, index: true
    move_branch_to_reference
    remove_column :domains, :branch
  end

  def down
    add_column :domains, :branch, :string
    move_reference_to_branch
    remove_column :domains, :branch_id
  end

  def move_branch_to_reference
    Domain.all.each do |domain|
      branch = Branch.find_or_create_by(name: domain.attributes["branch"])
      domain.update_column(:branch_id, branch.id)
    end
  end

  def move_reference_to_branch
    Domain.all.each do |domain|
      branch_name = domain.branch.name
      domain.update_column(:branch, branch_name)
    end
  end
end
