class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController

  before_action :set_user, only: [:linkedin]

  def linkedin
    auth = env["omniauth.auth"]
    @user.update(
      linkedin_uid: auth.uid,
      linkedin_token: auth.credentials.token,
      linkedin_token_expires_at: Time.at(auth.credentials.expires_at)
    )
    @user.import_profile
    redirect_to request.referrer
    set_flash_message(:notice, :success, kind: "Linkedin") if is_navigational_format?
  end

  private

  def set_user
    @user = current_user
  end
end
