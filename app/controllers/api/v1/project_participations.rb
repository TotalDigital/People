module API
  module V1
    class ProjectParticipations < Grape::API
      include API::V1::Defaults
      include Grape::Kaminari

      namespace :project_participations do

        desc "List all project_participations"
        oauth2
        paginate per_page: @per_page, max_per_page: @max_per_page, offset: false
        get do
          paginate policy_scope(ProjectParticipation)
        end

        desc "Get a project_participation"
        oauth2
        params do
          requires :project_participation_id, type: String, desc: "ID of the project_participation"
        end
        get ":project_participation_id" do
          policy_scope(ProjectParticipation).find(permitted_params[:project_participation_id])
        end

        desc "Create a new project_participation"
        oauth2
        params do
          requires :project_participation, type: Hash do
            requires :start_date, type: String, desc: "Date user first worked on project"
            optional :end_date, type: String, desc: "Date user last worked on project"
            requires :user_id, type: String, desc: "ID of user"
            optional :role_description, type: String, desc: "Description of role"
          end
          requires :project, type: Hash do
            optional :id, type: String, desc: "ID of project if exists"
            optional :name, type: String, desc: "Name of project if not in db"
            optional :location, type: String, desc: "Location of project if not in db"
          end
        end

        post do
          project = policy_scope(Project).find_or_create_by(id: permitted_params[:project][:id]) do |project|
            project.assign_attributes(permitted_params[:project])
            project.user_id = permitted_params[:project_participation][:user_id]
          end
          project_participation = ProjectParticipation.new(permitted_params[:project_participation].merge(project_id: project.id))
          create_resource(project_participation)
        end


        desc "Update a project_participation"
        oauth2
        params do
          requires :project_participation_id
          requires :project_participation, type: Hash do
            optional :start_date, type: String, desc: "Date user first worked on project"
            optional :end_date, type: String, desc: "Date user last worked on project"
            optional :role_description, type: String, desc: "Description of role"
          end
        end
        put ":project_participation_id" do
          project_participation = policy_scope(ProjectParticipation).find(permitted_params[:project_participation_id])
          update_resource(project_participation, permitted_params[:project_participation])
        end

        desc "Delete a project_participation"
        oauth2
        params do
          requires :project_participation_id, type: String, desc: "ID of the project_participation"
        end
        delete ":project_participation_id" do
          project_participation = policy_scope(ProjectParticipation).find(permitted_params[:project_participation_id])
          delete_resource(project_participation)
        end
      end
    end
  end
end
