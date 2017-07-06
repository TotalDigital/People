class ApplicationController < ActionController::Base
  include Pundit
  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized
  rescue_from ActionController::InvalidAuthenticityToken, with: :user_not_authorized

  protect_from_forgery with: :exception
  before_action :set_locale

  def user_not_authorized(exception)
    flash[:alert] = "You are not allowed to perform this action"
    redirect_to(request.referrer || root_path)
  end

  def pundit_user
    ApplicationPolicy::UserContext.new(current_user, session[:edit_mode])
  end

  def edit_mode
    session[:edit_mode] = !session[:edit_mode]
    redirect_to request.referrer
  end

  def flash_detailed(type, error_message, detailed_errors = nil)
    flash[type]     = error_message
    flash[:details] = detailed_errors unless detailed_errors.blank?
  end

  def discard_flash_xhr
    flash.discard if request.xhr?
  end

  private

  def after_sign_in_path_for(resource)
    request.env['omniauth.origin'] || session[:user_return_to] || root_path
  end

  def require_onboarding
    redirect_to(onboarding_path) && return
  end

  def set_user
    @user = policy_scope(User).find(params[:user_id])
  end

  def set_locale
    I18n.locale = current_user.try(:language) || People.default_locale || I18n.default_locale
  end

end
