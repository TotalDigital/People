class ProjectsController < ApplicationController

  before_action :set_user, only: [:update]
  before_action :set_project, only: [:update]
  after_action :discard_flash_xhr, only: [:update]

  autocomplete :project, :name, extra_data: [:location], scopes: [:people], full: true

  def update
    respond_to do |format|
      if @project.update(project_params)
        flash_detailed :notice, (t'.success')
      else
        flash_detailed :alert, (t'.failure'), @project.errors.full_messages
      end
      format.js { render 'update' }
    end
  end

  private

  def set_project
    @project = Project.find(params[:id])
    authorize @project
  end

  def project_params
    params.require(:project).permit(:name, :location, :user_id)
  end
end
