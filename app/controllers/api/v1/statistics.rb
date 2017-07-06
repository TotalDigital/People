module API
  module V1
    class Statistics < Grape::API
      include API::V1::Defaults

      namespace :statistics do

        desc "List all statistics"
        get do
          {
              date:      Date.current,
              users:     {
                  description:             "Les utilisateurs de #{People.app_name}",
                  total_count:             "#{User.count} profils utilisateurs",
                  with_picture_count:      "#{User.where.not(profile_picture_file_name: nil).count} profils avec une photo",
                  total_created_past_week: "#{User.where('created_at >= ?', Date.current.beginning_of_day - 1.week).count} profils créés sur les 7 derniers jours"
              },
              skills:    {
                  description:             "Les compétences renseignées dans #{People.app_name}",
                  total_count:             "#{Skill.count} compétences créées",
                  used_count:              "#{UsersSkill.group(:skill_id).count.size} compétences utilisées",
                  added_to_profiles_count: "#{UsersSkill.count} fois ajoutées aux pages de profil",
                  top_trend:               UsersSkill.group(:skill_id).order('count_skill_id desc').count('skill_id').take(3).map { |id, count| "#{Skill.find(id).name} (#{count} profils)" }
              },
              languages: {
                  description:             "Les langues renseignées dans #{People.app_name}",
                  total_count:             "#{Language.count} langues créées",
                  used_count:              "#{UsersLanguage.group(:language_id).count.size} langues utilisées",
                  added_to_profiles_count: "#{UsersLanguage.count} fois ajoutées aux pages de profil",
                  top_trend:               UsersLanguage.group(:language_id).order('count_language_id desc').count('language_id').take(3).map { |id, count| "#{Language.find(id).name} (#{count} profils)" }
              },
              jobs:      {
                  description:                   "Les jobs renseignés dans #{People.app_name}",
                  total_count:                   "#{Job.count} jobs créés",
                  user_percentage_creating_jobs: "#{(Job.distinct.pluck(:user_id).count / User.count.to_f * 100).round(2)}% des utilisateurs ont créé au moins un job"
              },
              projects:  {
                  description:                                     "Les projets renseignés dans #{People.app_name}",
                  total_count:                                     "#{Project.count} projets créés",
                  participations_count:                            "#{ProjectParticipation.count} participations créées sur les projets",
                  user_percentage_creating_project_participations: "#{(ProjectParticipation.distinct.pluck(:user_id).count / User.count.to_f * 100).round(2)}% des utilisateurs ont créé au moins une participation à un projet"
              }
          }
        end

      end

    end
  end
end
