class WelcomeController < ApplicationController

  def index
    @users = policy_scope(User).featured(User::USERS_COUNT_FEATURED)
  end

end
