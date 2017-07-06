module API
  module V1
    class Jobs < Grape::API
      include API::V1::Defaults
      include Grape::Kaminari

      namespace :jobs do

        desc "List all jobs"
        oauth2
        paginate per_page: @per_page, max_per_page: @max_per_page, offset: false
        get do
          paginate policy_scope(Job)
        end

        desc "Get a job"
        oauth2
        params do
          requires :job_id, type: String, desc: "ID of the job"
        end
        get ":job_id" do
          policy_scope(Job).find(permitted_params[:job_id])
        end

        desc "Create a new job"
        oauth2
        params do
          requires :job, type: Hash do
            requires :title, type: String, desc: "Title of the job"
            requires :start_date, type: String, desc: "Start date of the job"
            optional :end_date, type: String, desc: "End date of the job"
            requires :description, type: String, desc: "Description of the job"
            requires :location, type: String, desc: "Location of the job"
            requires :user_id, type: String, desc: "ID of the user"
          end
        end
        post do
          job = Job.new(permitted_params[:job])
          create_resource(job)
        end

        desc "Update a job"
        oauth2
        params do
          requires :job_id
          requires :job, type: Hash do
            optional :title, type: String, desc: "Title of the job"
            optional :start_date, type: String, desc: "Start date of the job"
            optional :end_date, type: String, desc: "End date of the job"
            optional :description, type: String, desc: "Description of the job"
            optional :location, type: String, desc: "Location of the job"
          end
        end
        put ":job_id" do
          job = policy_scope(Job).find(permitted_params[:job_id])
          update_resource(job, permitted_params[:job])
        end

        desc "Delete a job"
        oauth2
        params do
          requires :job_id, type: String, desc: "ID of the job"
        end
        delete ":job_id" do
          job = Job.find(permitted_params[:job_id])
          delete_resource(job)
        end
      end
    end
  end
end
