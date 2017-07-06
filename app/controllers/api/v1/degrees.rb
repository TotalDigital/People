module API
  module V1
    class Degrees < Grape::API
      include API::V1::Defaults
      include Grape::Kaminari

      namespace :degrees do

        desc "List all degrees"
        oauth2
        paginate per_page: @per_page, max_per_page: @max_per_page, offset: false
        get do
          paginate policy_scope(Degree)
        end

        desc "Get a degree"
        oauth2
        params do
          requires :degree_id, type: String, desc: "ID of the degree"
        end
        get ":degree_id" do
          policy_scope(Degree).find(permitted_params[:degree_id])
        end

        desc "Create a new degree"
        oauth2
        params do
          requires :degree, type: Hash do
            requires :title, type: String, desc: "Degree's title"
            requires :entry_year, type: String, desc: "First year of degree"
            optional :graduation_year, type: String, desc: "Year of graduation"
            requires :user_id, type: String, desc: "ID of user"
          end
          requires :school, type: Hash do
            optional :id, type: String, desc: "ID of school"
            optional :name, type: String, desc: "Name of school if not in db"
          end
        end
        post do
          school = School.find_or_create_by(id: permitted_params[:school][:id]) do |school|
            school.name = permitted_params[:school][:name]
          end
          degree = Degree.new(permitted_params[:degree].merge(school_id: school.id))
          create_resource(degree)
        end

        desc "Update a degree"
        oauth2
        params do
          requires :degree_id, type: String, desc: "ID of the degree"
          requires :degree, type: Hash do
            optional :title, type: String, desc: "Degree's title"
            optional :entry_year, type: String, desc: "First year of degree"
            optional :graduation_year, type: String, desc: "Year of graduation"
            optional :school_id, type: String, desc: "ID of school"
          end
        end
        put ":degree_id" do
          degree = policy_scope(Degree).find(permitted_params[:degree_id])
          update_resource(degree, permitted_params[:degree])
        end

        desc "Delete a degree"
        oauth2
        params do
          requires :degree_id, type: String, desc: "ID of the relationship"
        end
        delete ":degree_id" do
          degree = policy_scope(Degree).find(permitted_params[:degree_id])
          delete_resource(degree)
        end
      end
    end
  end
end
