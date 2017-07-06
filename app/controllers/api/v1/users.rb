module API
  module V1
    class Users < Grape::API
      include API::V1::Defaults
      include Grape::Kaminari

      namespace :users do

        desc "List all users"
        oauth2
        paginate per_page: @per_page, max_per_page: @max_per_page, offset: false
        get do
          paginate policy_scope(User)
        end

        desc "Get the current user"
        oauth2
        get "profile" do
          policy_scope(User).find(current_user.id)
        end

        desc "Get a list of featured users"
        oauth2
        get "featured" do
          policy_scope(User).featured(User::USERS_COUNT_FEATURED)
        end

        desc "Get a user's N+1 graph"
        oauth2
        params do
          requires :user_id, type: String, desc: "ID of the user"
        end
        get ":user_id/graph", serializer: GraphSerializer do
          policy_scope(User).find(permitted_params[:user_id])
        end

        desc "Get a user"
        oauth2
        params do
          requires :user_id, type: String, desc: "ID of the user"
        end
        get ":user_id" do
          policy_scope(User).find(permitted_params[:user_id])
        end

        desc "Update a user"
        oauth2
        params do
          requires :user_id
          requires :user, type: Hash do
            optional :first_name, type: String, desc: "User's first name"
            optional :last_name, type: String, desc: "User's last name"
            optional :internal_id, type: String, desc: "User's internal_id"
            optional :job_title, type: String, desc: "User's job_title"
            optional :phone, type: String, desc: "User's phone"
            optional :office_address, type: String, desc: "User's office address"
            optional :wat_link, type: String, desc: "User'wat_link"
            optional :entity, type: String, desc: "User's entity"
            optional :linkedin, type: String, desc: "User's linkedin"
            optional :twitter, type: String, desc: "User's twitter"
          end
        end
        put ":user_id" do
          user = policy_scope(User).find(permitted_params[:user_id])
          update_resource(user, permitted_params[:user])
        end

        desc "Upload the user's picture"
        oauth2
        params do
          requires :user_id, type: String, desc: "ID of the user"
        end
        post ":user_id/upload_picture" do
          user = policy_scope(User).find(permitted_params[:user_id])

          if UserPolicy.new(pundit_user, user).update?
            profile_picture      = params[:profile_picture]
            attachment           = {
                :filename => profile_picture[:filename],
                :type     => profile_picture[:type],
                :headers  => profile_picture[:head],
                :tempfile => profile_picture[:tempfile]
            }
            user.profile_picture = ActionDispatch::Http::UploadedFile.new(attachment)
            user.save! && user
          else
            api_error 401
          end
        end

        desc "Create a new user's skill"
        oauth2
        params do
          requires :user_id, type: String, desc: "ID of the user"
          requires :skill_id, type: String, desc: "ID of the skill"
        end
        post ":user_id/skills" do
          user = policy_scope(User).find(permitted_params[:user_id])

          if UserPolicy.new(pundit_user, user).update?
            skill = policy_scope(Skill).find(permitted_params[:skill_id])
            user.users_skills.build(skill_id: skill.id).save!
          else
            api_error 401
          end
        end

        desc "Create a new user's language"
        oauth2
        params do
          requires :user_id, type: String, desc: "ID of the user"
          requires :language_id, type: String, desc: "ID of the language"
        end
        post ":user_id/languages" do
          user = policy_scope(User).find(permitted_params[:user_id])

          if UserPolicy.new(pundit_user, user).update?
            language = policy_scope(Language).find(permitted_params[:language_id])
            user.users_languages.build(language_id: language.id).save!
          else
            api_error 401
          end
        end

        desc "Delete a user's skill"
        oauth2
        params do
          requires :user_id, type: String, desc: "ID of the user"
          requires :skill_id, type: String, desc: "ID of the skill"
        end
        delete ":user_id/skills/:skill_id" do
          user = policy_scope(User).find(permitted_params[:user_id])

          if UserPolicy.new(pundit_user, user).update?
            user.skills.destroy(permitted_params[:skill_id])
          else
            api_error 401
          end
        end

        desc "Delete a user"
        oauth2
        params do
          requires :user_id, type: String, desc: "ID of the user"
        end
        delete ":user_id" do
          if current_user.admin?
            user = policy_scope(User).find(permitted_params[:user_id])
            delete_resource(user)
          else
            api_error 401, "Only admins can delete users"
          end
        end

        desc "Delete a user's language"
        oauth2
        params do
          requires :user_id, type: String, desc: "ID of the user"
          requires :language_id, type: String, desc: "ID of the language"
        end
        delete ":user_id/languages/:language_id" do
          user = policy_scope(User).find(permitted_params[:user_id])

          if UserPolicy.new(pundit_user, user).update?
            user.languages.destroy(permitted_params[:language_id])
          else
            api_error 401
          end
        end

        desc "Search for users"
        oauth2
        paginate per_page: @per_page, max_per_page: @max_per_page, offset: false
        params do
          requires :search_term, type: String, desc: "Search term for users"
        end
        get "search/:search_term" do
          paginate policy_scope(User).search(permitted_params[:search_term], :attributes_cont_any)
        end

      end
    end
  end
end
