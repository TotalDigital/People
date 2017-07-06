module API
  module V1
    class Languages < Grape::API
      include API::V1::Defaults
      include Grape::Kaminari

      namespace :languages do

        desc "List all languages"
        oauth2
        paginate per_page: @per_page, max_per_page: @max_per_page, offset: false
        get do
          paginate policy_scope(Language)
        end

        desc "Get a language"
        oauth2
        params do
          requires :language_id, type: String, desc: "ID of the language"
        end
        get ":language_id" do
          policy_scope(Language).find(permitted_params[:language_id])
        end

        desc "Create a new language"
        oauth2
        params do
          requires :language, type: Hash do
            requires :name, type: String, desc: "Name of the language"
          end
        end
        post do
          language = Language.new(permitted_params[:language])
          create_resource(language)
        end

        desc "Search for languages"
        oauth2
        params do
          requires :search_term, type: String, desc: "Search term for language name"
        end
        get "search/:search_term" do
          paginate policy_scope(Language).search(permitted_params[:search_term])
        end
      end
    end
  end
end
