class UnifySkills

  def self.call
    clean_skill_name
    unify_skills
  end

  def self.clean_skill_name
    Skill.all.each do |skill|
      skill.name = skill.name.downcase.strip
      skill.save(validate: false)
    end
  end

  def self.unify_skills
    skills_to_trim = Skill.group(:name).count.select{ |skill, count| count > 1 }.keys

    skills_to_trim.each do |skill_name|
      same_skills = Skill.where(name: skill_name)
      original_skill = same_skills.first
      UsersSkill.where(skill: same_skills).each do |user_skill|
        user_skill.update(skill: original_skill)
      end

      same_skills.where.not(id: original_skill.id).(&:destroy)
    end
  end
end
