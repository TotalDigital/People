class LanguagesController < ApplicationController

  before_action :set_user, only: [:create, :destroy]

  after_action :discard_flash_xhr, only: [:create, :destroy]

  autocomplete :language, :name, full: true

  def create
    language = Language.find_by_id(language_params[:id]) || Language.find_or_initialize_by(name: language_name)
    authorize language

    if language.save && @user.users_languages.build(language_id: language.id).save
      flash_detailed :notice, (t'.success', language: language.name.capitalize)
    else
      flash_detailed :alert, (t'.failure'), language.errors.full_messages
    end

    respond_to do |format|
      format.js { render 'languages/update' }
      format.html { redirect_to user_path(@user) }
    end
  end

  def destroy
    language = Language.find(params[:id])
    authorize @user, :update?
    if @user.languages.delete(language)
      flash_detailed :notice, (t'.success', language: language.name.capitalize)
    else
      flash_detailed :alert, (t'.failure')
    end

    respond_to do |format|
      format.js { render 'languages/update' }
      format.html { redirect_to user_path(@user) }
    end
  end

  private

  def language_params
    params.require(:language).permit(:name, :id)
  end

  def language_name
    language_params[:name].downcase
  end
end
