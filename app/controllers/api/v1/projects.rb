module API
  module V1
    class Projects < Grape::API
      include API::V1::Defaults
      include Grape::Kaminari

      namespace :projects do

        desc "List all projects"
        oauth2
        paginate per_page: @per_page, max_per_page: @max_per_page, offset: false
        get do
          paginate policy_scope(Project)
        end

        desc "Get a project"
        oauth2
        params do
          requires :project_id, type: String, desc: "ID of the project"
        end
        get ":project_id" do
          policy_scope(Project).find(permitted_params[:project_id])
        end

        desc "Update a project"
        oauth2
        params do
          requires :project_id
          requires :project, type: Hash do
            optional :name, type: String, desc: "Project's name"
            optional :location, type: String, desc: "Project's location"
          end
        end
        put ":project_id" do
          project = policy_scope(Project).find(permitted_params[:project_id])
          update_resource(project, permitted_params[:project])
        end

        desc "Delete a project"
        oauth2
        params do
          requires :project_id, type: String, desc: "ID of the relationship"
        end
        delete ":project_id" do
          project = policy_scope(Project).find(permitted_params[:project_id])
          delete_resource(project)
        end

        desc "Search for projects"
        oauth2
        params do
          requires :search_term, type: String, desc: "Search term for project name"
        end
        get "search/:search_term", serializer: ProjectSerializer::SearchResults do
          paginate policy_scope(Project).search(permitted_params[:search_term])
        end
      end
    end
  end
end
