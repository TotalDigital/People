class ProjectParticipationsController < ApplicationController

  before_action :set_user, only: [:create, :update, :destroy]
  before_action :set_project_participation, only: [:update, :destroy]

  after_action :discard_flash_xhr, only: [:create, :update, :destroy]

  def create
    project                = set_or_create_project
    @project_participation = ProjectParticipation.new(project_participation_params.merge(user: @user, project_id: project.id))
    authorize @project_participation

    if @project_participation.save
      flash_detailed :notice, (t'.success', name: project.name)
    else
      flash_detailed :alert, (t'.failure'), @project_participation.errors.full_messages
    end

    respond_to do |format|
      format.js { render 'projects/update' }
      format.html { redirect_to user_path(@user) }
    end
  end

  def update
    respond_to do |format|
      if @project_participation.update(project_participation_params)
        flash_detailed :notice, (t'.success')
      else
        flash_detailed :alert, (t'.failure'), @project_participation.errors.full_messages
      end
      format.js { render 'projects/update' }
    end
  end

  def destroy
    project = @project_participation.project
    if @project_participation.destroy
      flash_detailed :notice, (t'.success', name: project.name)
    else
      flash_detailed :alert, (t'.failure', name: project.name)
    end
    project.transfer_ownership_or_destroy if project.user == @user

    respond_to do |format|
      format.js { render 'projects/update' }
      format.html { redirect_to user_path(@user) }
    end
  end

  private

  def set_project_participation
    @project_participation = ProjectParticipation.find(params[:id])
    authorize @project_participation
  end

  def project_participation_params
    params.require(:project_participation).permit(:start_date, :end_date, :role_description)
  end

  def project_params
    params.require(:project_participation).permit(:project_id, :project_name, :project_location)
  end

  def set_or_create_project
    if project_params[:project_id].present?
      Project.find_by_id(project_params[:project_id])
    else
      Project.create(name: project_params[:project_name], location: project_params[:project_location], user: @user)
    end
  end
end
