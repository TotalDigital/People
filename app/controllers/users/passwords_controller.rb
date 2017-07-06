class Users::PasswordsController < Devise::PasswordsController

  protected

  def after_resetting_password_path_for(resource)
    resource.sign_in_count <= 1 ? onboarding_path : root_path
  end
end
