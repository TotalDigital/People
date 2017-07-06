class SkillsController < ApplicationController

  before_action :set_user, only: [:create, :destroy]

  after_action :discard_flash_xhr, only: [:create, :destroy]

  autocomplete :skill, :name, full: true

  def create
    skill = Skill.find_or_initialize_by(name: skill_name)
    authorize skill

    if skill.save && @user.users_skills.build(skill_id: skill.id).save
      flash_detailed :notice, (t'.success', name: skill.name)
    else
      flash_detailed :alert, (t'.failure'), skill.errors.full_messages
    end

    respond_to do |format|
      format.js { render 'skills/update' }
      format.html { redirect_to user_path(@user) }
    end
  end

  def destroy
    skill = Skill.find(params[:id])
    authorize @user, :update?
    if @user.skills.delete(skill)
      flash_detailed :notice, (t'.success', name: skill.name)
    else
      flash_detailed :alert, (t'.failure')
    end

    respond_to do |format|
      format.js { render 'skills/update' }
      format.html { redirect_to user_path(@user) }
    end
  end

  private

  def skill_params
    params.require(:skill).permit(:name)
  end

  def skill_name
    skill_params[:name].downcase
  end

  def index_params
    params.require(:term)
  end
end
