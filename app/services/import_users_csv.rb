class ImportUsersCSV
  include CSVImporter

  model User

  column :email, required: true
  column :last_name
  column :first_name
  column :job_title
  column :entity
  column :internal_id, to: -> (internal_id, user) { user.internal_id = ( InternalIdValidator::Format.new(internal_id).valid? ? internal_id : nil ) }
  column :phone,       to: -> (phone, user)       { user.phone = ( PhoneNumberValidator::Format.new(phone).valid? ? phone : nil ) }

  when_invalid :skip

  after_build do |user|
    address = csv_attributes.values_at("address", "address_2", "postal_code", "city", "country")
    user.office_address = address.reject(&:blank?).join(" ")
    user.imported = true

    if user.save
      skill_names = csv_attributes["skills"].try(:split, ",")
      skill_names.map do |skill_name|
        skill = Skill.find_or_create_by(name: skill_name.downcase.strip)
        UsersSkill.create(user: user, skill: skill)
      end unless skill_names.blank?
    end
  end
end
