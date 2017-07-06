class Users::RegistrationsController < Devise::RegistrationsController

  before_action :check_domain, only: [:create]

  def create
    build_resource(sign_up_params)
    resource.save
    yield resource if block_given?
    if resource.persisted?
      flash[:notice] = "A message with a confirmation link has been sent to #{resource.email}. Please follow the link to activate your account."
      expire_data_after_sign_in!
      respond_with resource, location: after_inactive_sign_up_path_for(resource)
    else
      respond_with resource
    end
  end

  private

  def check_domain
    if Domain.count > 0
      email_address = sign_up_params[:email].downcase rescue nil
      unless email_address.present? && Domain.authorized?(email_address)
        build_resource(sign_up_params)
        flash[:alert] = "#{Domain.get_domain(email_address)} is not a member of #{People.app_owner}. Please contact your local administrator."
        render :new, locals: { resource: resource }
      end
    end
  end

  def after_sign_up_path_for(resource)
    onboarding_path
  end

  def after_update_path_for(resource)
    user_path(resource)
  end

  def sign_up_params
    params.require(:user).permit(:first_name, :last_name, :email, :conditions_of_use)
  end

  def account_update_params
    params.require(:user).permit(:first_name, :last_name, :email, :password, :password_confirmation, :current_password, :title, :phone, :office_address, :lync, :wat_link, :entity, :language)
  end
end
