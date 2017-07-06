class ProfilesController < ApplicationController

  before_action :authenticate_user!
  before_action :set_user, only: [:show, :update, :destroy]

  before_action :require_onboarding, if: :onboarding_needed?, except: [:update]
  after_action :discard_flash_xhr, only: [:update]

  def index
    @q = policy_scope(User).ransack(params[:q])
    if params["search"] && params["search"]["term"].present?
      @users = policy_scope(User).search(params["search"]["term"], :attributes_cont_any).page(params[:page])
    else
      @users = @q.result(distinct: true).page(params[:page])
    end
  end

  def show
  end

  def update
    respond_to do |format|
      if @user.update(profile_params)
        flash_detailed :notice, (t'.success')
        format.js   { render 'profiles/update' }
        format.html { redirect_to user_path(@user, guided_tour: params[:onboarding]), notice: (t'.success') }
      else
        flash_detailed :alert, (t'.failure'), @user.errors.full_messages
        format.js   { render 'profiles/update' }
        format.html do
          params[:onboarding] ? render('onboarding/index') : redirect_to(user_path(@user))
        end
      end
    end
  end

  def destroy
    if @user.destroy_with_password(profile_params[:password])
      flash[:notice] = t'.success'
      redirect_to root_path
    else
      flash[:alert] = t'.failure'
      redirect_to request.referrer
    end
  end

  def autocomplete
    @users = policy_scope(User).search(params[:term], :first_name_or_last_name_or_email_cont_any)
    respond_to do |format|
      format.json { render json: @users.map { |user| { id: user.id, label: user.name_with_position } }.to_json }
      format.html { render partial: 'profiles/search_results'}
    end
  end

  def import_list
    authorize User
    unless params[:users] && params[:users][:csv]
      flash[:alert] = "Please select a file"
    else
      file = FileUploader.new(params[:users][:csv]).file
      import = ImportUsersCSV.new(file: file)

      if import.valid_header? && import.run!
        failed_emails = import.report.invalid_rows.map { |row| row.model.email unless row.model.email.blank? }
        flash[:notice] = "#{import.report.message} #{ ('(' + failed_emails.join(', ') + ')') if failed_emails.any? }"
      else
        flash[:alert] = t'.failure'
      end
    end
    redirect_to request.referrer
  end

  def graph_json
    user = User.friendly.find(params[:user_id])
    render json: GraphSerializer.new(user, root: false, with_scope: current_user.scope).to_json
  end

  def user_json
    user = User.friendly.find(params[:user_id])
    render json: user
  end

  private

  def profile_params
    params.require(:user).permit(:profile_picture, :first_name, :last_name, :job_title, :entity, :office_address, :phone, :wat_link, :twitter, :linkedin, :internal_id, :password)
  end

  def index_params
    params.require(:term)
  end

  def set_user
    user = policy_scope(User).friendly.find(params[:id])
    authorize user
    @user = UserDecorator.decorate(user)
  end

  def onboarding_needed?
    if People.contact_info_attributes.include?(:internal_id)
      current_user.internal_id.blank?
    else
      false
    end
  end
end
