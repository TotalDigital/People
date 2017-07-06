class DegreesController < ApplicationController

  before_action :set_user, only: [:create, :destroy, :update]
  before_action :set_degree, only: [:destroy, :update]

  after_action :discard_flash_xhr, only: [:create, :update, :destroy]

  def create
    school = set_or_create_school
    degree = @user.degrees.build(degree_params.merge(school_id: school.id))
    authorize degree
    if degree.save
      flash_detailed :notice, (t'.success')
    else
      flash_detailed :alert, (t'.failure'), degree.errors.full_messages
    end

    respond_to do |format|
      format.js { render 'degrees/update' }
      format.html { redirect_to user_path(@user) }
    end
  end

  def update
    respond_to do |format|
      if @degree.update(degree_params)
        flash_detailed :notice, (t'.success')
      else
        flash_detailed :alert, (t'.failure'), @degree.errors.full_messages
      end
      format.js { render 'update' }
    end
  end

  def destroy
    if @degree.destroy
      flash_detailed :notice, (t'.success', title: @degree.title)
    else
      flash_detailed :alert, (t'.failure')
    end

    respond_to do |format|
      format.js { render 'degrees/update' }
      format.html { redirect_to user_path(@user) }
    end
  end

  private

  def set_degree
    @degree = Degree.find(params[:id])
    authorize @degree
  end

  def degree_params
    params.require(:degree).permit(:title, :graduation_year, :entry_year)
  end

  def school_params
    params.require(:degree).permit(:school_name, :school_id)
  end

  def set_or_create_school
    if school_params[:school_id].present?
      School.find_by_id(school_params[:school_id])
    else
      School.create(name: school_params[:school_name])
    end
  end
end
