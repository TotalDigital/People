class OnboardingController < ApplicationController

  before_action :skip_onboarding, if: "current_user.internal_id.present?"

  def index
    @user = current_user
    authorize(:onboarding, :index?)
  end

  def skip_onboarding
    redirect_to(root_path) && return
  end

end
