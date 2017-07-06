class Users::ConfirmationsController < Devise::ConfirmationsController

  protected

  def after_confirmation_path_for(resource_name, resource)
    if signed_in?(resource_name)
      signed_in_root_path(resource)
    else
      token = resource.send(:set_reset_password_token)
      edit_password_url(resource, reset_password_token: token)
    end
  end
end
