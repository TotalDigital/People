module Linkedinable
  extend ActiveSupport::Concern

  def import_profile
    api_profile = GetLinkedinFullProfile.new(self).call
    import_basic_info(api_profile)
    import_jobs(api_profile)
  end

  private

  def import_basic_info(profile)
    self.job_title = profile["headline"]
    self.linkedin = profile["publicProfileUrl"]
    if profile["pictureUrls"].try(:[], "values").any?
      self.profile_picture = open(profile["pictureUrls"]["values"].first)
    end
    self.save
  end

  # TODO: Fix and plug when full profile is available
  # def import_languages(languages)
  #   languages.each do |language_name|
  #     language = Language.find_or_create_by(name: language_name)
  #     UsersLanguage.find_or_create_by(user_id: id, language_id: language.id)
  #   end
  # end

  # TODO: Fix and plug when full profile is available
  # def import_skills(skills)
  #   skills.each do |skill_name|
  #     skill = Skill.find_or_create_by(name: skill_name)
  #     UsersSkill.find_or_create_by(user_id: id, skill_id: skill.id)
  #   end
  # end

  def import_jobs(profile)
    positions = profile["positions"].try(:[], "values")
    positions.each do |position|
      Job.find_or_create_by(title: "#{position['title']} at #{position['company']['name']}", user_id: id) do |user|
        user.start_date = Time.parse("#{position['startDate']['month']}/#{position['startDate']['year']}")
        user.end_date   = Time.parse("#{position['endDate']['month']}/#{position['endDate']['year']}") unless position["isCurrent"]
        user.location   = position["location"]["name"]
      end
    end
  end
end
