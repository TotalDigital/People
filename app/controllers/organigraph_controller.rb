class OrganigraphController < ApplicationController

  def index
    if user_signed_in?
      redirect_to action: "show", id: current_user.id
    else
      redirect_to root_path
    end
  end

  def show
    @user = User.find(params[:id])
    respond_to do |format|
      format.html {}
      format.json {}
    end
  end

end
