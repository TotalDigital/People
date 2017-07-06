module API
  module V1
    class Skills < Grape::API
      include API::V1::Defaults
      include Grape::Kaminari

      namespace :skills do

        desc "List all skills"
        oauth2
        paginate per_page: @per_page, max_per_page: @max_per_page, offset: false
        get do
          paginate policy_scope(Skill)
        end

        desc "Get a skill"
        oauth2
        params do
          requires :skill_id, type: String, desc: "ID of the skill"
        end
        get ":skill_id" do
          policy_scope(Skill).find(permitted_params[:skill_id])
        end

        desc "Create a new skill"
        oauth2
        params do
          requires :skill, type: Hash do
            requires :name, type: String, desc: "Name of the skill"
          end
        end
        post do
          skill = Skill.new(permitted_params[:skill])
          create_resource(skill)
        end

        desc "Search for skills"
        oauth2
        params do
          requires :search_term, type: String, desc: "Search term for skill name"
        end
        get "search/:search_term" do
          paginate policy_scope(Skill).search(permitted_params[:search_term])
        end
      end
    end
  end
end
