class JobsController < ApplicationController

  before_action :set_job, only: [:update, :destroy]
  before_action :set_user, except: [:import_list]

  after_action :discard_flash_xhr, only: [:create, :update, :destroy]

  def create
    job = @user.jobs.build(job_params)
    authorize job

    if job.save
      flash_detailed :notice, (t'.success', title: job_params[:title])
    else
      flash_detailed :alert, (t'.failure'), job.errors.full_messages
    end

    respond_to do |format|
      format.js { render 'jobs/update' }
      format.html { redirect_to user_path(@user) }
    end
  end

  def update
    respond_to do |format|
      if @job.update_attributes(job_params)
        flash_detailed :notice, (t'.success')
      else
        flash_detailed :alert, (t'.failure'), @job.errors.full_messages
      end
      format.js { render 'update' }
    end
  end

  def destroy
    @job.destroy
    flash_detailed :notice, (t'.success', title: @job.title)

    respond_to do |format|
      format.js { render 'jobs/update' }
      format.html { redirect_to user_path(@user) }
    end
  end

  def import_list
    authorize Job
    unless params[:jobs] && params[:jobs][:csv]
      flash[:alert] = t'.select_file'
    else
      file = FileUploader.new(params[:jobs][:csv]).file
      import = ImportJobsCSV.new(file: file)
      jobs_count = Job.count
      if import.valid_header? && import.run!
        flash[:notice] = t'.success', count: (Job.count - jobs_count)
      else
        flash[:alert] = t'.failure'
      end
    end
    redirect_to request.referrer
  end

  private

  def set_job
    @job = Job.find(params[:id])
    authorize @job
  end

  def job_params
    params.require(:job).permit(:title, :start_date, :end_date, :location, :description)
  end
end
