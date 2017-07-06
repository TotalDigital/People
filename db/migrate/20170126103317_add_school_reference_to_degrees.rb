class AddSchoolReferenceToDegrees < ActiveRecord::Migration

  def up
    add_column :degrees, :entry_year, :integer
    add_reference :degrees, :school, index: true
    move_school_to_reference
    remove_column :degrees, :institution
  end

  def down
    add_column :degrees, :institution, :string
    move_reference_to_school
    remove_column :degrees, :school_id
    remove_column :degrees, :entry_year
  end

  def move_school_to_reference
    Degree.all.each do |degree|
      school = School.find_or_create_by(name: degree.institution)
      degree.update_column(:school_id, school.id)
    end
  end

  def move_reference_to_school
    Degree.all.each do |degree|
      school_name = degree.school.name
      degree.update_column(:institution, school_name)
    end
  end
end
