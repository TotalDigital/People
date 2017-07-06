class RelationshipsController < ApplicationController

  before_action :require_onboarding, if: "current_user.internal_id.blank?", except: [:new]
  after_action :discard_flash_xhr, only: [:create, :destroy]

  def new
    @relationship = Relationship.new(relationship_params)
    flash[:alert] = t '.failure' if @relationship.target.nil?
  end

  def create
    @relationship = Relationship.new(relationship_params)
    authorize @relationship

    if @relationship.save
      flash_detailed :notice, (t '.success', name: @relationship.target.full_name)
    else
      flash_detailed :alert, (t '.failure'), @relationship.errors.full_messages
    end
    set_request_referrer_user
    respond_to do |format|
      format.js { render 'update' }
    end
  end

  def destroy
    @relationship = Relationship.find(params[:id])
    authorize @relationship

    if @relationship.destroy
      flash_detailed :notice, (t '.success', name: @relationship.target.full_name)
    else
      flash_detailed :alert, (t '.failure', name: @relationship.target.full_name)
    end
    set_request_referrer_user
    respond_to do |format|
      format.js { render 'update' }
    end
  end

  private

  def relationship_params
    params.require(:relationship).permit(:user_id, :target_id, :kind)
  end

  def set_request_referrer_user
    url = URI.parse(request.referrer)
    slug = url.path.split('/p/').last
    @request_referrer_user = User.find_by(slug: slug)
  end
end
