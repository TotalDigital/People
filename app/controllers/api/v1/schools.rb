module API
  module V1
    class Schools < Grape::API
      include API::V1::Defaults
      include Grape::Kaminari

      namespace :schools do

        desc "List all schools"
        oauth2
        paginate per_page: @per_page, max_per_page: @max_per_page, offset: false
        get do
          paginate policy_scope(School)
        end

        desc "Get a school"
        oauth2
        params do
          requires :school_id, type: String, desc: "ID of the school"
        end
        get ":school_id" do
          policy_scope(School).find(permitted_params[:school_id])
        end

        desc "Search for schools"
        oauth2
        params do
          requires :search_term, type: String, desc: "Search term for school name"
        end
        get "search/:search_term" do
          paginate policy_scope(School).search(permitted_params[:search_term])
        end
      end
    end
  end
end
